//
//  SquadViewModel.swift
//  Beliski
//
//  Created by Losd wind on 2021/11/2.
//

import Foundation
class SquadViewModel: ObservableObject {
    
    @Published var fetchedOnInviteBranches:[Branch]  = [Branch]()
        
    
    @Published var fetchedMessages:[Message] = [Message]()
    
    @Published var message:Message = Message()
    
    @Published var branch:Branch = Branch()
    
    
    func getProfile(message: Message,completion: @escaping (_ user: User?) -> () ){
        COLLECTION_USERS.document(message.ownerID).getDocument { (document, error) in
            let result = Result {
                  try document?.data(as: User.self)
                }
                switch result {
                case .success(let user):
                    if let user = user {
                        // A `User` value was successfully initialized from the DocumentSnapshot.
                        completion(user)
                        return
                    } else {
                        // A nil value was successfully initialized from the DocumentSnapshot,
                        // or the DocumentSnapshot was nil.
                        print("Document does not exist")
                        completion(nil)
                        return
                    }
                case .failure(let error):
                    // A `User` value could not be initialized from the DocumentSnapshot.
                    print("Error decoding journal: \(error)")
                    completion(nil)
                    return
                }
        }
    }

    
    
    func sendMessage(completion: @escaping (_ success: Bool) -> ()){
        guard let userID = AuthViewModel.shared.userID else {
            print("userID is not valid here in like function")
            completion(false)
            return
        }
        
        message.ownerID = userID
        let document =  COLLECTION_USERS.document(branch.ownerID).collection("branches")
            .document(branch.id).collection("messages").document(message.id)
        do {
            try document.setData(from: message)
            completion(true)
            return
            
        } catch let error {
            print("Error upload message to branch: \(error)")
            completion(false)
            return
        }
        
    }
    
    
    func getMessages(completion: @escaping (_ success: Bool) -> ()) {
        
        let first  = COLLECTION_USERS.document(branch.ownerID).collection("branches").document(branch.id).collection("messages")
            .order(by:"serverTimestamp")
            .limit(to:20)
        
        first.addSnapshotListener() { snapshot, _ in
                guard let lastSnapshot = snapshot?.documents.last else {completion(false)
                return}
            
            COLLECTION_USERS.document(self.branch.ownerID).collection("branches").document(self.branch.id).collection("messages")
                .order(by:"serverTimestamp")
                .start(afterDocument: lastSnapshot)
                .getDocuments { (snapshot, _) in
                    guard let documents = snapshot?.documents else { return }
                    self.fetchedMessages = documents.compactMap({try? $0.data(as: Message.self)})
            
            completion(true)
        }
    }
    }
    
    
    
    // MARK: get OnInvite branches
    func fetchOnInviteBranchs(completion: @escaping (_ success: Bool) -> ()) {
        guard let userID = AuthViewModel.shared.userID else {
            print("userID is not valid here in fetchJournal function")
            completion(false)
            return
        }
        
        
        COLLECTION_USERS.document(userID).collection("branches")
            .whereField("openess", isEqualTo: OpenType.OnInvite)
            .addSnapshotListener { snapshot, _ in
                guard let documents = snapshot?.documents else {
                    completion(false)
                    return }
                self.fetchedOnInviteBranches = documents.compactMap({try? $0.data(as: Branch.self)})
                completion(true)
                return
            }
        
    }
    
    
}
