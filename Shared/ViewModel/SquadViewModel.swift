//
//  SquadViewModel.swift
//  Beliski
//
//  Created by Losd wind on 2021/11/2.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import OrderedCollections

class SquadViewModel: ObservableObject {
    
    // for branches
    @Published var fetchedOnInviteBranches:[Branch]  = [Branch]()
    
    
    
    // for a specific branch
    @Published var fetchedMessages:[Message] = [Message]()
    @Published var fetchedProfiles:[User] = [User]()
    @Published var fetchedMessagesAndProfiles:OrderedDictionary<Message,User> = [:]
    
    // for edit the
//    @Published var editBranch:Branch = Branch()
    @Published var currentBranch:Branch = Branch()
    @Published var inputMessage:Message = Message()

    
//
//    func getProfile(message: Message,completion: @escaping (_ user: User?) -> () ){
//        COLLECTION_USERS.document(message.ownerID).getDocument { (document, error) in
//            let result = Result {
//                  try document?.data(as: User.self)
//                }
//                switch result {
//                case .success(let user):
//                    if let user = user {
//                        // A `User` value was successfully initialized from the DocumentSnapshot.
//                        completion(user)
//                        return
//                    } else {
//                        // A nil value was successfully initialized from the DocumentSnapshot,
//                        // or the DocumentSnapshot was nil.
//                        print("Document does not exist")
//                        completion(nil)
//                        return
//                    }
//                case .failure(let error):
//                    // A `User` value could not be initialized from the DocumentSnapshot.
//                    print("Error decoding journal: \(error)")
//                    completion(nil)
//                    return
//                }
//        }
//    }
//
    
    // get the profiles of a branch by user ids
    func fetchProfiles(ids: [String], completion: @escaping (_ users: [User]?) -> () ){
    
        var users:[User] = []
        COLLECTION_USERS
            .whereField("id", in: ids)
            .getDocuments { (snapshot, _) in
                guard let documents = snapshot?.documents else {
                    completion(nil)
                    return }
                users = documents.compactMap({try? $0.data(as: User.self)})
                completion(users)
    }
    }

    
    
    func sendMessage(completion: @escaping (_ success: Bool) -> ()){
        
        // MARK: here we shall have an authentication that user is in the member list
        
        guard let userID = AuthViewModel.shared.userID else {
            print("userID is not valid here in like function")
            completion(false)
            return
        }
        
        self.inputMessage.userID = userID
        self.inputMessage.branchID = currentBranch.id
        
        let document =  COLLECTION_USERS.document(self.currentBranch.ownerID).collection("branches")
            .document(self.currentBranch.id).collection("messages").document(self.inputMessage.id)
        do {
            try document.setData(from: self.inputMessage)
            completion(true)
            return
            
        } catch let error {
            print("Error upload message to branch: \(error)")
            completion(false)
            return
        }
        
    }
    
    
    func getMessages(branch:Branch, completion: @escaping (_ success: Bool) -> ()) {
        
        let first  = COLLECTION_USERS.document(branch.ownerID).collection("branches").document(branch.id).collection("messages")
            .order(by:"serverTimestamp")
            .limit(to:20)
        
        first.addSnapshotListener() { snapshot, _ in
                guard let lastSnapshot = snapshot?.documents.last else {completion(false)
                return}
            
            COLLECTION_USERS.document(branch.ownerID).collection("branches").document(branch.id).collection("messages")
                .order(by:"serverTimestamp")
                .start(afterDocument: lastSnapshot)
                .getDocuments { (snapshot, _) in
                    guard let documents = snapshot?.documents else { return }
                    self.fetchedMessages = documents.compactMap({try? $0.data(as: Message.self)})
            
            completion(true)
        }
    }
    }
    
    
    func fetchProfilesAndMessages(branch:Branch,completion: @escaping (_ success: Bool) -> ()){
        var messageProfilePairs:OrderedDictionary<Message,User> = [:]
                
        let group = DispatchGroup()
        var profileIDs:[String] = []
        profileIDs.append(branch.ownerID)
        profileIDs.append(contentsOf: Array(branch.memberIDs.keys))
        
        print(profileIDs)
        
        group.enter()
        self.fetchProfiles(ids: profileIDs, completion: { users in
            if let users = users {
                self.fetchedProfiles =  users
                group.leave()

            } else {
                print("failed to fetch profiles from this branch")
                group.leave()
            }
        })
        
        group.enter()
        self.getMessages(branch: branch) { success in
            if success {
                for message in self.fetchedMessages{
                    
                    for user in self.fetchedProfiles {
                        if user.id == message.userID {
                            messageProfilePairs[message] = user
                        }
                    }
                    group.leave()

                    
                }
            }
        }
        
        group.notify(queue: .main){
            self.fetchedMessagesAndProfiles = messageProfilePairs
            completion(true)
            return
        }
        
        completion(false)
    }
    
    
    
    // MARK: get OnInvite branches
    func fetchOnInviteBranches(completion: @escaping (_ success: Bool) -> ()) {
        guard let userID = AuthViewModel.shared.userID else {
            print("userID is not valid here in fetchJournal function")
            completion(false)
            return
        }
        self.fetchedOnInviteBranches = []
        let group = DispatchGroup()
        
        group.enter()
        COLLECTION_BRANCHES
            .whereField("openess", isEqualTo: OpenType.OnInvite.rawValue)
            .whereField("memberIDs", arrayContains: userID)
            .addSnapshotListener { snapshot, _ in
                guard let documents = snapshot?.documents else {
                    completion(false)
                    return
                }
                self.fetchedOnInviteBranches.append(contentsOf: documents.compactMap({try? $0.data(as: Branch.self)}))
                group.leave()
            }
        group.enter()
        COLLECTION_BRANCHES
            .whereField("openess", isEqualTo: OpenType.OnInvite.rawValue)
            .whereField("ownerID", isEqualTo: userID)
            .addSnapshotListener { snapshot, _ in
                guard let documents = snapshot?.documents else {
                    completion(false)
                    return
                }
                self.fetchedOnInviteBranches.append(contentsOf: documents.compactMap({try? $0.data(as: Branch.self)}))
                group.leave()
            }
        group.notify(queue: .main){
            completion(true)
        }
        
    }
    

    
}
