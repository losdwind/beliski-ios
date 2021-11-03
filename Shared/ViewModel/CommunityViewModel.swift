//
//  CommunityViewModel.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/30.
//

import Foundation
import OrderedCollections

class CommunityViewModel: ObservableObject {
    
    @Published var fetchedOpenBranches:[Branch] = [Branch]()
    @Published var fetchedLikes: [Like] = [Like]()
    @Published var fetchedDislikes:[Like] = [Like]()
    @Published var fetchedProfiles:[User] = [User]()
    @Published var fetchedComments:[Comment] = [Comment]()
    @Published var fetchedCommentsAndProfiles:OrderedDictionary<Comment,User> = [:]
    

    
    
    @Published var inputComment:Comment = Comment()
    @Published var inputLike:Like = Like()
    @Published var inputDislike:Like = Like()
    
    @Published var currentBranch:Branch = Branch()
    
    
    @Published var selectedCategory:String = ""
    @Published var isShowingLinkedBranchView = false
    
    
    func getProfile(comment: Comment,completion: @escaping (_ user: User?) -> () ){
        COLLECTION_USERS.document(comment.ownerID).getDocument { (document, error) in
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
    
    
    
    
    // MARK: Send
    // !!!: here exists a performance issue: https://firebase.google.com/docs/firestore/solutions/counters#swift_1
    func sendLike(completion: @escaping (_ success: Bool) -> ()){
        guard let userID = AuthViewModel.shared.userID else {
            print("userID is not valid here in like function")
            completion(false)
            return
        }
        
        
        self.inputLike.ownerID = userID
        
        let document =  COLLECTION_USERS.document(self.currentBranch.ownerID).collection("branches")
            .document(self.currentBranch.id).collection("likes").document(self.inputLike.id)
        
        do {
            try document.setData(from: self.inputLike)
            completion(true)
            return
            
        } catch let error {
            print("Error send like to branch: \(error)")
            completion(false)
            return
        }
        
    }
    
    
    
    func sendComment(completion: @escaping (_ success: Bool) -> ()){
        guard let userID = AuthViewModel.shared.userID else {
            print("userID is not valid here in like function")
            completion(false)
            return
        }
        
        self.inputComment.ownerID = userID
        let document =  COLLECTION_USERS.document(self.currentBranch.ownerID).collection("branches")
            .document(self.currentBranch.id).collection("comments").document(self.inputComment.id)
        do {
            try document.setData(from: self.inputComment)
            completion(true)
            return
            
        } catch let error {
            print("Error send comment to branch: \(error)")
            completion(false)
            return
        }
        
    }
    

    
    
    
    
    // MARK: get
    
    // FIXME: I think it is better to use cloud founctions to calculate the 
    
    func getlikes(branch:Branch, completion: @escaping (_ success: Bool) -> ()){
        
        COLLECTION_USERS.document(branch.ownerID).collection("branches").document(branch.id).collection("likes")
            .whereField("like", isEqualTo: 1)
            .limit(to:20)

        let first  = COLLECTION_USERS.document(branch.ownerID).collection("branches").document(branch.id).collection("likes")
            .order(by:"serverTimestamp")
            .limit(to:20)
        
        first.addSnapshotListener() { snapshot, _ in
                guard let lastSnapshot = snapshot?.documents.last else {completion(false)
                return}
            
            COLLECTION_USERS.document(branch.ownerID).collection("branches").document(branch.id).collection("likes")
                .order(by:"serverTimestamp")
                .limit(to:20)
                .start(afterDocument: lastSnapshot)
                .getDocuments { snapshot, _ in
                    guard let documents = snapshot?.documents else { return }
                    self.fetchedLikes = documents.compactMap({try? $0.data(as: Like.self)})
            
            completion(true)
            return
        }
        
    }
    }
    
    
    func getDislikes(branch:Branch, completion: @escaping (_ success: Bool) -> ()){
        
        COLLECTION_USERS.document(branch.ownerID).collection("branches").document(branch.id).collection("likes")
            .whereField("like", isEqualTo: -1)
            .limit(to:20)

        let first  = COLLECTION_USERS.document(branch.ownerID).collection("branches").document(branch.id).collection("likes")
            .order(by:"serverTimestamp")
            .limit(to:20)
        
        first.addSnapshotListener() { snapshot, _ in
                guard let lastSnapshot = snapshot?.documents.last else {completion(false)
                return}
            
            COLLECTION_USERS.document(branch.ownerID).collection("branches").document(branch.id).collection("likes")
                .order(by:"serverTimestamp")
                .limit(to:20)
                .start(afterDocument: lastSnapshot)
                .getDocuments { snapshot, _ in
                    guard let documents = snapshot?.documents else { return }
                    self.fetchedDislikes = documents.compactMap({try? $0.data(as: Like.self)})
            
            completion(true)
            return
        }
        
    }
    }
    
    
    func getComments(branch:Branch,completion: @escaping (_ success: Bool) -> ()) {
        
        let first  = COLLECTION_USERS.document(branch.ownerID).collection("branches").document(branch.id).collection("comments")
            .order(by:"serverTimestamp")
            .limit(to:20)
        
        first.addSnapshotListener() { snapshot, _ in
                guard let lastSnapshot = snapshot?.documents.last else {completion(false)
                return}
            
            COLLECTION_USERS.document(branch.ownerID).collection("branches").document(branch.id).collection("comments")
                .order(by:"serverTimestamp")
                .start(afterDocument: lastSnapshot)
                .getDocuments { snapshot, _ in
                    guard let documents = snapshot?.documents else { return }
                    self.fetchedComments = documents.compactMap({try? $0.data(as: Comment.self)})
            
            completion(true)
        }
    }
    }
    
    
    
    func fetchCommentsAndProfiles(branch:Branch,completion: @escaping (_ success: Bool) -> ()){
        var commentProfilePairs:OrderedDictionary<Comment,User> = [:]
        var profiles:Set<User> = Set<User>()
        
        let group = DispatchGroup()
        
        group.enter()
        self.getComments(branch: branch) { success in
            if success {
                for comment in self.fetchedComments{
                    self.getProfile(comment: comment) { user in
                        if let user = user {
                            profiles.insert(user)
                            commentProfilePairs[comment] = user
                            group.leave()
                        } else {
                            print("fail to get corresponding user for this comment")
                            completion(false)
                            return
                        }
                    }
                }
            } else {
                print("fail to get corresponding comments for this branch")
                completion(false)
                return
            }
        }
        
        group.notify(queue: .main){
            self.fetchedCommentsAndProfiles = commentProfilePairs
            self.fetchedProfiles = Array(profiles)
            completion(true)
            return
        }
    }
    
    
    
    

    
    
    
    
    
    
    
    
    
    // MARK: get open branches
    func fetchOpenBranchs(completion: @escaping (_ success: Bool) -> ()) {
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
                self.fetchedOpenBranches = documents.compactMap({try? $0.data(as: Branch.self)})
                completion(true)
                return
            }
        
    }
    
    
    
}
