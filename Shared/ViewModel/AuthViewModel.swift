//
//  AuthViewModel.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/6.
//

import Foundation
import UIKit
import Firebase

class AuthViewModel: ObservableObject {
    
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var didSendResetPasswordLink = false
    
    @Published var isShowingAuthView:Bool = false
    
    static let shared = AuthViewModel()
    
    init() {
        userSession = Auth.auth().currentUser
        isShowingAuthView = (userSession?.uid == nil)
        fetchUser()
    }
    
    func login(withEmail email: String, password: String){
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("DEBUG: Login failed \(error.localizedDescription)")
                return
            }
            
            guard let user = result?.user else { return }
            self.userSession = user
            self.fetchUser()
            
//            I thing this method is better than others
//             UserDefaults.standard.set(userID, forKey: CurrentUserDefaults.userID)

        }
    }
    
    func register(withEmail email: String, password: String,
                  image: UIImage?, fullname: String, username: String) {
        
        guard let image = image else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let user = result?.user else { return }
            print("Successfully registered user...")
            
            
            MediaUploader.uploadImage(image: image, type: .profile) { imageUrl in
                
                let data = User(username: username, email: email, profileImageUrl: imageUrl, fullname: fullname, bio: "")
                
                do {
                    try COLLECTION_USERS.document(user.uid).setData(from:data)
                    print("Successfully uploaded user data to firestore...")
                    self.userSession = user
                    self.fetchUser()
                    
                    
                } catch let error {
                    print("Error upload User to Firestore: \(error)")
                }
            }
            
            
            
        }
    }
    
    func signout() {
        self.userSession = nil
        try? Auth.auth().signOut()
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
    
    func fetchUser() {
        guard let uid = userSession?.uid else { return }
        COLLECTION_USERS.document(uid).getDocument { snapshot, _ in
            guard let user = try? snapshot?.data(as: User.self) else { return }
            
            print(user.email)
            self.currentUser = user }
    }
    
}
