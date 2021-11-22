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

class AuthViewModel: ObservableObject {
    
    @Published var didSendResetPasswordLink = false
    @Published var isShowingLogInView:Bool = false
    @Published var isShowingSignUpView:Bool = false
    
    static let shared = AuthViewModel()

    
    @AppStorage(CurrentUserDefaults.userID) var userID: String?
    @AppStorage(CurrentUserDefaults.nickName) var nickName:String?
    @AppStorage(CurrentUserDefaults.profileImgURL) var profileImageURL:String?

    
    
    
    
    
    func logInUserToFirebase(credential:FIRGoogleAuthCredential) async -> Bool{
        
    }
    
    func logInUserToFirebase(credential:OAuthCredential) async throws -> Bool {
        
        do {
            try await Auth.auth().signIn(with: credential)
            return true
        } catch {
            throw error
            return false
        }

    }
    

    
    
    
    
    
    func logInUserToAppStorage(userID: String, handler: @escaping (_ success: Bool) -> ()) {
        
        
        // Get the users info
        fetchUser(userID: userID) { user in
            if let nickName = user?.nickName, let profileImgURL = user?.profileImageURL  {
                // Success
                print("Success getting user info while logging in")
                // Set the users info into our app
                UserDefaults.standard.set(userID, forKey: CurrentUserDefaults.userID)
                UserDefaults.standard.set(nickName, forKey: CurrentUserDefaults.nickName)
                UserDefaults.standard.set(profileImgURL, forKey: CurrentUserDefaults.profileImgURL)
                handler(true)
                
                
            } else {
                // Error
                print("Error getting user info while logging in")
                handler(false)
            }
        }
        
        
    }
    

    func logIn(email:String, password:String) async throws -> Bool {
        do {
            try await Auth.auth().signIn(withEmail: email, password: password)
            return true
        } catch {
            throw error
            return false
        }
    }
  
    
    func register(email: String, password: String) async throws -> Bool {
        
        do {
            try await Auth.auth().createUser(withEmail: email, password: password)
            return true
        } catch {
            print(error)
            return false
        }
        
        }
        
    
    
    
    
    func signout(handler: @escaping (_ success: Bool) -> ()) {
        do {
            try Auth.auth().signOut()

            let defaultsDictionary = UserDefaults.standard.dictionaryRepresentation()
            defaultsDictionary.keys.forEach { (key) in
                UserDefaults.standard.removeObject(forKey: key)
            }
            handler(true)
            return
        } catch {
            print("Error \(error)")
            handler(false)
            return
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
    
    
    
}
