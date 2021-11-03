//
//  CommunityViewModel.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/30.
//

import Foundation

class CommunityViewModel: ObservableObject {
    @Published var fetchedOpenBranches:[Branch] = [Branch]()
    
    @Published var fetchedLikes: [Like] = [Like]()
    
    @Published var fetchedComments:[Comment] = [Comment]()
    
    
    @Published var comment:Comment = Comment()
    
    @Published var openBranch:Branch = Branch()
    
    
    
    
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
    func sendLike(like: Like, branch:Branch, completion: @escaping (_ success: Bool) -> ()){
        guard let userID = AuthViewModel.shared.userID else {
            print("userID is not valid here in like function")
            completion(false)
            return
        }
        
        
        comment.ownerID = userID
        
        let document =  COLLECTION_USERS.document(branch.ownerID).collection("branches")
            .document(branch.id).collection("likes").document(like.id)
        
        do {
            try document.setData(from: like)
            completion(true)
            return
            
        } catch let error {
            print("Error send like to branch: \(error)")
            completion(false)
            return
        }
        
    }
    
    
    
    func sendComment(branch:Branch,completion: @escaping (_ success: Bool) -> ()){
        guard let userID = AuthViewModel.shared.userID else {
            print("userID is not valid here in like function")
            completion(false)
            return
        }
        
        comment.ownerID = userID
        let document =  COLLECTION_USERS.document(branch.ownerID).collection("branches")
            .document(branch.id).collection("comments").document(comment.id)
        do {
            try document.setData(from: comment)
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
    
    
    func getComments(branch:Branch, completion: @escaping (_ success: Bool) -> ()) {
        
        let first  = COLLECTION_USERS.document(branch.ownerID).collection("branches").document(branch.id).collection("comments")
            .order(by:"serverTimestamp")
            .limit(to:20)
        
        first.addSnapshotListener() { snapshot, _ in
                guard let lastSnapshot = snapshot?.documents.last else {completion(false)
                return}
            
            let next = COLLECTION_USERS.document(branch.ownerID).collection("branches").document(branch.id).collection("comments")
                .order(by:"serverTimestamp")
                .start(afterDocument: lastSnapshot)
                .getDocuments { snapshot, _ in
                    guard let documents = snapshot?.documents else { return }
                    self.fetchedComments = documents.compactMap({try? $0.data(as: Comment.self)})
            
            completion(true)
        }
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
