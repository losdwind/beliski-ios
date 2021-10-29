//
//  AuthViewModel.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/6.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth

class AuthViewModel: ObservableObject {
    
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var didSendResetPasswordLink = false
    
    @Published var isShowingAuthView:Bool = false
    
    static let shared = AuthViewModel()
    
    init() {
        userSession = Auth.auth().currentUser
        isShowingAuthView = (userSession?.uid == nil)
        fetchUser(completion: {_ in})
    }
    
    func login(withEmail email: String, password: String, completion: @escaping (_ success: Bool) -> ()){
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("DEBUG: Login failed \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let user = result?.user else {
                completion(false)
                return }
            self.userSession = user
            self.fetchUser { success in
                if success {
                    completion(true)
                    return
                }
            }
            

        }
    }
    
    func register(withEmail email: String, password: String,
                  image: UIImage?, fullname: String, username: String, completion: @escaping (_ success: Bool) -> ()) {
        
        guard let image = image else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
                return
            }
            
            guard let user = result?.user else {
                completion(false)
                return }
            print("Successfully registered user...")
            
            
            MediaUploader.uploadImage(image: image, type: .profile) { imageUrl in
                
                let data = User(email: email, profileImageUrl: imageUrl, username: username, fullname: fullname, bio: "")
                
                do {
                    try COLLECTION_USERS.document(user.uid).setData(from:data)
                    print("Successfully uploaded user data to firestore...")
                    self.userSession = user
                    self.fetchUser { success in
                        if success {
                            completion(true)
                            return
                        }
                    }
                    
                    
                } catch let error {
                    print("Error upload User to Firestore: \(error)")
                    completion(false)
                    return
                }
            }
            
            
            
        }
    }
    
    func signout() {
        self.userSession = nil
        self.currentUser = nil
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
    
    func fetchUser(completion: @escaping (_ success: Bool) -> ()) {
        guard let uid = userSession?.uid else {
            completion(false)
            return }
        COLLECTION_USERS.document(uid).getDocument { snapshot, _ in
            guard let user = try? snapshot?.data(as: User.self) else {
                completion(false)
                return }
            
            print(user.email)
            self.currentUser = user
            completion(true)
            return
            
        }
        
    }
    
}
