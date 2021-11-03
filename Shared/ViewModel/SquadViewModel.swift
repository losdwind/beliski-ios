//
//  SquadViewModel.swift
//  Beliski
//
//  Created by Losd wind on 2021/11/2.
//

import Foundation
import OrderedCollections
class SquadViewModel: ObservableObject {
    
    @Published var fetchedOnInviteBranches:[Branch]  = [Branch]()
    @Published var fetchedPublicBranches:[Branch] = [Branch]()
    @Published var fetchedMessages:[Message] = [Message]()
    @Published var fetchedProfiles:[User] = [User]()
    @Published var fetchedMessagesAndProfiles:OrderedDictionary<Message,User> = [:]
    
    
    
    @Published var editBranch:Branch = Branch()
    
    
    
    @Published var currentBranch:Branch = Branch()
    @Published var inputMessage:Message = Message()

    
    
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
        
        self.inputMessage.ownerID = userID
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
        var profiles:Set<User> = Set<User>()
        
        let group = DispatchGroup()
        
        group.enter()
        self.getMessages(branch: branch) { success in
            if success {
                for message in self.fetchedMessages{
                    self.getProfile(message: message) { user in
                        if let user = user {
                            profiles.insert(user)
                            messageProfilePairs[message] = user
                            group.leave()
                        }
                    }
                }
            }
        }
        
        group.notify(queue: .main){
            self.fetchedMessagesAndProfiles = messageProfilePairs
            self.fetchedProfiles = Array(profiles)
        }
    }
    
    
    
    // MARK: get OnInvite branches
    func fetchOnInviteBranches(completion: @escaping (_ success: Bool) -> ()) {
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
    
    
    // MARK: get OnInvite branches
    func fetchPublicBranches(completion: @escaping (_ success: Bool) -> ()) {
        guard let userID = AuthViewModel.shared.userID else {
            print("userID is not valid here in fetchJournal function")
            completion(false)
            return
        }
        
        
        COLLECTION_USERS.document(userID).collection("branches")
            .whereField("openess", isEqualTo: OpenType.Public)
            .addSnapshotListener { snapshot, _ in
                guard let documents = snapshot?.documents else {
                    completion(false)
                    return }
                self.fetchedPublicBranches = documents.compactMap({try? $0.data(as: Branch.self)})
                completion(true)
                return
            }
        
    }
    
    
}
