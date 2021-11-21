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
    
    func logInUserToFirebase(credential:OAuthCredential) async -> (_ providerID: String?, _ isError: Bool, _ isNewUser: Bool?, _ userID: String?) {
        
        Auth.auth().signIn(with: credential) { (result, err) in
            
            if let error = err{
                self.handleError(error: error)
                return
            }
            
            guard let user = result?.user else {
                handler(nil, true, nil, nil)
                return
            }
            
            self.checkIfUserExistsInFirestore(providerID: user.uid) { (returnedUserID) in
                
                if let userID = returnedUserID {
                    // User exists, log in to app immediately
                    handler(user.uid, false, false, userID)
                    return
                    
                } else {
                    // User exist in Authenticate but no in the firestore, try register with the same method again
                    handler(user.uid, false, true, nil)
                    return
                }
                
            }
        }
    }
    
    
    
    
    
    
    func logInUserToFirebase(email: String, password: String, handler: @escaping (_ providerID: String?, _ isError: Bool, _ isNewUser: Bool?, _ userID: String?) -> ()){
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("DEBUG: Login failed \(error.localizedDescription)")
                handler(nil, true, nil, nil)
                return
            }
            
            guard let user = result?.user else {
                handler(nil, true, nil, nil)
                return
            }
            
            self.checkIfUserExistsInFirestore(providerID: user.uid) { (returnedUserID) in
                
                if let userID = returnedUserID {
                    // User exists, log in to app immediately
                    handler(user.uid, false, false, userID)
                    return
                    
                } else {
                    // User exist in Authenticate but no in the firestore, try register with the same method again
                    handler(user.uid, false, true, nil)
                    return
                }
                
            }
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
    

    
    
    func registerToCloudStore(user: FirebaseAuth.User,  handler: @escaping (_ success: Bool) -> ()) {
        
        
        // Set up a user Document with the user Collection
        let document = COLLECTION_USERS.document()
                    
        let data = User(id: user.uid, email: user.email, profileImageURL: user.photoURL, nickName: user.displayName, dateCreated:Timestamp(date: Date()))
            
            do {
                try document.setData(from: data)

            } catch let error {
                print("Error upload User to Firestore: \(error)")
                handler(false)
                return
            }
            
//
//            let privates = Private(id: user.uid, email: email, profileImageURL: imageUrl, nickName: nickName, dateCreated:Timestamp(date: Date()))
//            let privateDocument = COLLECTION_USERS.document(user.uid).collection("privates").document(user.uid)
//            do {
//                try privateDocument.setData(from: privates)
//                print("successfully generate user privates data to firestore")
//            } catch let error{
//                print("Error upload Privates to Firestore: \(error)")
//                handler(false)
//                return
//            }
//
//
//
//            let userSubscribe = UserSubscibe(id: user.uid, profileImageURL: imageUrl, nickName: nickName)
//            let userSubscribeDocument = COLLECTION_USERS.document(user.uid).collection("usersubscribe").document(user.uid)
//            do {
//                try userSubscribeDocument.setData(from: userSubscribe)
//                print("successfully initialize user subscription data to firestore")
//            } catch let error{
//                print("Error initialize user subscription data to Firestore: \(error)")
//                handler(false)
//                return
//            }
            
            
            print("Successfully uploaded user data to firestore...")

            
            
            handler(true)
            return
            
        
    }
  
    
    func register(email: String, password: String,
                  profileImage: UIImage?, nickName: String, userName: String, handler: @escaping (_ success: Bool) -> ()) {
        
        guard let image = profileImage else {
            print("No valid profile Image")
            handler(false)
            return }
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print(error.localizedDescription)
                handler(false)
                return
            }
            
            guard let user = result?.user else {
                handler(false)
                return }
            print("Successfully registered user...")
            
            MediaUploader.uploadImage(image: image, type: .profile) { imageUrl in
                user.photoURL = URL(string: imageUrl)
                self.registerToCloudStore(user: user) { success in
                    if success {
                        handler(true)
                    } else {
                        handler(false)
                        print("failed to register user")
                    }
                }
            }

            
            
            
            
           
            
            
            
        }
    }
    
    
    
    
    
    func signout(handler: @escaping (_ success: Bool) -> ()) {
        do {
            try Auth.auth().signOut()
            // Updated UserDefaults
            
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
    
    
    private func checkIfUserExistsInFirestore(providerID: String, handler: @escaping (_ existingUserID: String?) -> ()) {
        // If a userID is returned, then the user does exist in our database
        
        COLLECTION_USERS.whereField("providerID", isEqualTo: providerID).getDocuments { (querySnapshot, error) in
            
            if let snapshot = querySnapshot, snapshot.count > 0, let document = snapshot.documents.first {
                //SUCCESS
                let existingUserID = document.documentID
                handler(existingUserID)
                return
            } else {
                // ERROR, NEW USER
                handler(nil)
                return
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
    
    
    
}
