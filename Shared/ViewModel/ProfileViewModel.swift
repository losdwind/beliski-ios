//
//  ProfileViewModel.swift
//  Beliski-Firebase
//
//  Created by Wind Losd on 2021/9/21.
//

import Foundation
import SwiftUI



class ProfileViewModel: ObservableObject{
    
    @Published var user:User = User()
    
    // MARK: - here is the issue that the use could be nil becuase the AuthViewModel may not initlize the currentUser correctly (on time)
    
    
    
    
    func uploadUser(completion: @escaping (_ success: Bool) -> ()){
        
        guard let userID = AuthViewModel.shared.currentUser?.id else {
            print("userID is not valid here in fetchPerson function")
            completion(false)
            return
        }
        
        let document = COLLECTION_USERS.document(userID).collection("persons").document(user.id!)
        
        // MARK: - here I disabled the uploadImage because i want to upload right after the imagePicker
        
        do {
            try document.setData(from: user)
            completion(true)
            
        } catch let error {
            print("Error upload person to Firestore: \(error)")
            completion(false)
        }
        
    }
    
    
    func fetchUser(completion: @escaping (_ success: Bool) -> ()){
        
        guard let userID = AuthViewModel.shared.currentUser?.id else {
            print("userID is not valid here in fetchPerson function")
            completion(false)
            return
        }
        
        COLLECTION_USERS.document(userID).collection("users").document(userID).getDocument { (document, error) in
            let result = Result {
                  try document?.data(as: User.self)
                }
                switch result {
                case .success(let user):
                    if let user = user {
                        // A `User` value was successfully initialized from the DocumentSnapshot.
                        self.user = user
                        completion(true)
                        return
                    } else {
                        // A nil value was successfully initialized from the DocumentSnapshot,
                        // or the DocumentSnapshot was nil.
                        print("Document does not exist")
                        completion(false)
                        return
                    }
                case .failure(let error):
                    // A `User` value could not be initialized from the DocumentSnapshot.
                    print("Error decoding journal: \(error)")
                    completion(true)
                    return
                }
        }
        
    }
    
    
    
    func connectSocialMedia(source: SocialMediaCategory, completion: @escaping (_ success: Bool) -> () ){
        
    }
    
    
}
