//
//  AuthViewModel.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/6.
//

import Foundation
import Firebase
import FirebaseCore
import FirebaseAuth
import FirebaseFirestoreSwift
import GoogleSignIn
import SwiftUI
import AuthenticationServices
import CryptoKit

class AuthViewModel: ObservableObject {
    init(){
        addListeners()
    }
    
    @Published var didSendResetPasswordLink = false

    
    static let shared = AuthViewModel()
    
    
    @Published var currentUser:FirebaseAuth.User?
    
    // user state handler
    var handle: AuthStateDidChangeListenerHandle?
    

    @AppStorage(CurrentUserDefaults.userID) var userID: String?
    @AppStorage(CurrentUserDefaults.nickName) var nickName:String?
    @AppStorage(CurrentUserDefaults.profileImageURL) var profileImageURL:String?
    
    
    // For Apple Signin...
    @Published var nonce = ""

    private func addListeners() {
      if let handle = handle {
        Auth.auth().removeStateDidChangeListener(handle)
      }

        handle = Auth.auth()
        .addStateDidChangeListener { auth, user in
            if let user = user {
                self.currentUser = user
            } else {
                self.currentUser = nil
            }
        }
    }
    
// MARK: - Sign In with Apple
    func signInWithApple(credential: ASAuthorizationAppleIDCredential){
        
        // getting Token....
        guard let token = credential.identityToken else{
            print("error with firebase")
            
            return
        }
        
        // Token String...
        guard let tokenString = String(data: token, encoding: .utf8) else{
            print("error with Token")
            return
        }
        
        let firebaseCredential = OAuthProvider.credential(withProviderID: "apple.com", idToken: tokenString,rawNonce: nonce)
                
        Auth.auth().signIn(with: firebaseCredential) { (result, err) in
            
            if let error = err{
                print(error)
                return
            }
            guard let userID = result?.user.uid else {return}
            
            self.signToApp(userID: userID) { success in
                if success {
                    print("Logged with Apple In Success")
                }
            }
           
        }
    }


    


    
    // MARK: - Sign In with Google
    
    func signInWithGoogle() {
        

        // Google Sign in...
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        
        GIDSignIn.sharedInstance.signIn(with: config, presenting: getRootViewController()) {[self] user, err in

            
            if let error = err {
                print(error.localizedDescription)
              return
            }

            guard
              let authentication = user?.authentication,
              let idToken = authentication.idToken
            else {
              return
            }

            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: authentication.accessToken)
            
            // Firebase Auth...
            Auth.auth().signIn(with: credential) { result, err in
                                
                if let error = err {
                    print(error.localizedDescription)
                  return
                }
                
                // Displaying User Name...
                guard let userID = result?.user.uid else{
                    return
                }
                
                self.signToApp(userID: userID) { success in
                    if success {
                        print("Logged with Google In Success")
                     
                    }
                }
            }
        }
    }
   
    // Retreiving RootView COntroller...
    func getRootViewController()->UIViewController{
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else{
            return .init()
        }
        
        guard let root = screen.windows.first?.rootViewController else{
            return .init()
        }
        
        return root
    }
    
    
    
    // MARK: - Sign In with Email
    
    func signInWithEmail(email:String, password:String) async throws{
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            let userID = result.user.uid
            self.signToApp(userID: userID) { success in
                if success {
                    print("Logged with Email In Success")
                   
                }
            }
        } catch {
            throw error
        }
    }
  
    
    func signUpWithEmail(email: String, password: String) async throws -> Bool {
        
        do {
            try await Auth.auth().createUser(withEmail: email, password: password)
            return true
        } catch {
            return false
        }
        
        }
    
    
    
    func resetPassword(withEmail email: String) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                print("Failed to send link with error \(error.localizedDescription)")
                return
            }
            
            self.didSendResetPasswordLink = true
        }
    }

    
    
    // MARK: - Sign Out
    
    func signout() {
        do {
            try Auth.auth().signOut()

            let defaultsDictionary = UserDefaults.standard.dictionaryRepresentation()
            defaultsDictionary.keys.forEach { (key) in
                UserDefaults.standard.removeObject(forKey: key)
            }

        } catch {
            print(error)
        }
        
    }
    
    
    
    // MARK: - Log Info to APP
    
    func signToApp(userID: String, handler: @escaping (_ success: Bool) -> ()) {
        
        
        // Get the users info
        self.fetchUser(userID: userID) { user in
            if let user = user {
                // Success
                print("Success getting user info while logging in")
                // Set the users info into our app
                UserDefaults.standard.set(user.id, forKey: CurrentUserDefaults.userID)
                UserDefaults.standard.set(user.nickName, forKey: CurrentUserDefaults.nickName)
                UserDefaults.standard.set(user.profileImageURL, forKey: CurrentUserDefaults.profileImageURL)
                handler(true)
            } else {
                handler(false)
            }
                
        }
        
        
    }
    
    func fetchUser(userID:String, handler: @escaping (_ user: User?) -> ()) {
        
        COLLECTION_USERS.document(userID).getDocument { snapshot, _ in
            guard let user = try? snapshot?.data(as: User.self) else {
                handler(nil)
                return }
            print("fetched user")
            handler(user)
            return
            
        }
        
    }
    
    
    
    // MARK: - Helpler
    
    // Apple Sign In helpler
    
    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
      var result = ""
      var remainingLength = length

      while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
          var random: UInt8 = 0
          let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
          if errorCode != errSecSuccess {
            fatalError(
              "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
          }
          return random
        }

        randoms.forEach { random in
          if remainingLength == 0 {
            return
          }

          if random < charset.count {
            result.append(charset[Int(random)])
            remainingLength -= 1
          }
        }
      }

      return result
    }


    @available(iOS 13, *)
    func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
      }.joined()

      return hashString
    }
}




