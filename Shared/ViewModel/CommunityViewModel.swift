//
//  CommunityViewModel.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/30.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import OrderedCollections

class CommunityViewModel: ObservableObject {
    
    @Published var fetchedSubscribedBranches:[Branch] = [Branch]()
    
    @Published var fetchedPublicBranches:[Branch] = [Branch]()
        
    // for branch
    @Published var fetchedLikes: [Like] = [Like]()
    @Published var fetchedDislikes:[Dislike] = [Dislike]()
    @Published var fetchedProfiles:[User] = [User]()
    @Published var fetchedComments:[Comment] = [Comment]()
    @Published var fetchedSubs:[Sub] = [Sub]()
    
    
    // for user
    @Published var fetchedUserSubscribedBranchIDs:[Sub] = [Sub]()
    //get what branch ids do the user subscribed
    
    
    @Published var inputComment:Comment = Comment()
    @Published var inputLike:Like = Like()
    @Published var inputDislike:Dislike = Dislike()
    @Published var inputSub:Sub = Sub()
    @Published var currentBranch:Branch = Branch()
    
    @Published var fetchedUserSubscribe:UserSubscibe = UserSubscibe()
    
    
    @Published var selectedCategory:String = ""
    @Published var isShowingLinkedBranchView = false
    
    func getStatus(branch:Branch,completion: @escaping (_ status: Dictionary<String, Bool>?) -> ()){
        
        
        
        
        
        guard let userID = AuthViewModel.shared.userID else {
            print("userID is not valid here in fetchMoment function")
            completion(nil)
            return
        }

        
        var status:Dictionary<String, Bool> = ["isLike":false, "isDislike":false, "isSubed":false]
        let group = DispatchGroup()


        
        // isLike
        group.enter()
        COLLECTION_USERS.document(branch.ownerID).collection("branches")
            .document(branch.id).collection("likes").document(userID)
        .getDocument { (document, error) in
            if let document = document, document.exists {
                if let like = try? document.data(as: Like.self){
                    self.inputLike.isLike = like.isLike
                    status["isLike"] = like.isLike
                }
            }
            group.leave()
        }


        // isDislike
        group.enter()
        COLLECTION_USERS.document(branch.ownerID).collection("branches")
            .document(branch.id).collection("dislikes").document(userID)
        .getDocument { (document, error) in
            if let document = document, document.exists {
                if let dislike = try? document.data(as: Dislike.self){
                    self.inputDislike.isDislike = dislike.isDislike
                    status["isDislike"] = dislike.isDislike
                }
            }
            group.leave()
        }


        // isSubed
        group.enter()
        COLLECTION_USERS.document(branch.ownerID).collection("branches")
            .document(branch.id).collection("subs").document(userID)
        .getDocument { (document, error) in
            if let document = document, document.exists {
                if let sub = try? document.data(as: Sub.self){
                    self.inputSub.isSubed = sub.isSubed
                    status["isSubed"] = sub.isSubed
                }
            }
            group.leave()
        }
        


        group.notify(queue: .main){
            completion(status)
            return
        }
        
        
    }
    
    
    
    
    func getProfile(comment: Comment,completion: @escaping (_ user: User?) -> () ){
        COLLECTION_USERS.document(comment.userID).getDocument  { (document, error) in
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
                    print("Error decoding moment: \(error)")
                    completion(nil)
                    return
                }
        }
    }
    
//    func getUserSubscribe(completion: @escaping (_ success: Bool) -> ()) {
//        
//        guard let userID = AuthViewModel.shared.userID else {
//            print("userID is not valid here in like function")
//            completion(false)
//            return
//        }
//        
//        COLLECTION_USERS.document(userID).collection("usersubscribe")
//            .addSnapshotListener { (snapshot, error) in
//                    guard let documents = snapshot?.documents else {
//                        completion(false)
//                        return }
//                self.fetchedUserSubscribe = documents.compactMap({try? $0.data(as: UserSubscibe.self)})[0]
//                    completion(true)
//                    return
//        }
//    }
    
    
    // MARK: Send
    // !!!: here exists a performance issue: https://firebase.google.com/docs/firestore/solutions/counters#swift_1
    func sendLike(completion: @escaping (_ success: Bool) -> ()){
        guard let userID = AuthViewModel.shared.userID else {
            print("userID is not valid here in like function")
            completion(false)
            return
        }
        
        
        self.inputLike.userID = userID
        self.inputLike.branchID = self.currentBranch.id
        
        
        // here we put self.inputLike.userID as the documentID is to better identify the like status
        let document =  COLLECTION_USERS.document(self.currentBranch.ownerID).collection("branches")
            .document(self.currentBranch.id).collection("likes").document(self.inputLike.userID)
        
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
    
    
    
    // !!!: here exists a performance issue: https://firebase.google.com/docs/firestore/solutions/counters#swift_1
    func sendDislike(completion: @escaping (_ success: Bool) -> ()){
        guard let userID = AuthViewModel.shared.userID else {
            print("userID is not valid here in like function")
            completion(false)
            return
        }
        
        
        self.inputDislike.userID = userID
        self.inputDislike.branchID = self.currentBranch.id
        
        let document =  COLLECTION_USERS.document(self.currentBranch.ownerID).collection("branches")
            .document(self.currentBranch.id).collection("dislikes").document(self.inputDislike.userID)
        
        do {
            try document.setData(from: self.inputDislike)
            completion(true)
            return
            
        } catch let error {
            print("Error send dislike to branch: \(error)")
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
        
        self.inputComment.userID = userID
        self.inputComment.nickName = AuthViewModel.shared.nickName
        self.inputComment.userProfileImageURL = AuthViewModel.shared.profileImageURL
        self.inputComment.branchID = currentBranch.id
        
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
    
    
    // !!!: here exists a performance issue: https://firebase.google.com/docs/firestore/solutions/counters#swift_1
    func sendSub(completion: @escaping (_ success: Bool) -> ()){
        guard let userID = AuthViewModel.shared.userID else {
            print("userID is not valid here in like function")
            completion(false)
            return
        }
        
        
        self.inputSub.userID = userID
        self.inputSub.branchID = currentBranch.id
        
        let document =  COLLECTION_USERS.document(self.currentBranch.ownerID).collection("branches")
            .document(self.currentBranch.id).collection("subs").document(self.inputSub.userID)
        
        do {
            try document.setData(from: self.inputSub)
            completion(true)
            return
            
        } catch let error {
            print("Error send Subscription to branch: \(error)")
            completion(false)
            return
        }
        
    }
    
    
    
    
    // MARK: get
    
    // FIXME: I think it is better to use cloud founctions to calculate the
    
    func getlikes(branch:Branch, completion: @escaping (_ success: Bool) -> ()){
        
        COLLECTION_USERS.document(branch.ownerID).collection("branches").document(branch.id).collection("likes")
            .whereField("isLike", isEqualTo: true)
            .limit(to:20)
                .getDocuments { snapshot, _ in
                    guard let documents = snapshot?.documents else { return }
                    self.fetchedLikes = documents.compactMap({try? $0.data(as: Like.self)})
                    
                    completion(true)
                    return
                }
            
        
    }
    
    
    func getDislikes(branch:Branch, completion: @escaping (_ success: Bool) -> ()){
        
        COLLECTION_USERS.document(branch.ownerID).collection("branches").document(branch.id).collection("dislikes")
            .whereField("isDislike", isEqualTo: true)
            .limit(to:20)
                .getDocuments { snapshot, _ in
                    guard let documents = snapshot?.documents else { return }
                    self.fetchedDislikes = documents.compactMap({try? $0.data(as: Dislike.self)})
                    
                    completion(true)
                    return
                }
            
        
    }
    
    
    func getComments(branch:Branch,completion: @escaping (_ success: Bool) -> ()) {
        
        let listener = COLLECTION_USERS.document(branch.ownerID).collection("branches").document(branch.id).collection("comments")
            .order(by:"serverTimestamp")
            .limit(to:20)
            .addSnapshotListener { snapshot, _ in
                guard let documents = snapshot?.documents else { return }
                self.fetchedComments = documents.compactMap({try? $0.data(as: Comment.self)})
                for comment in self.fetchedComments {
                    print(comment.content)
                }
                completion(true)
                
            }
        if branch != currentBranch {
            listener.remove()
        }
    }
    
    
    func getSubs(branch:Branch, completion: @escaping (_ success: Bool) -> ()){
        
        COLLECTION_USERS.document(branch.ownerID).collection("branches").document(branch.id).collection("subs")
            .whereField("isSubed", isEqualTo: true)
            .limit(to:20)
            .getDocuments { snapshot, _ in
                    guard let documents = snapshot?.documents else {
                        completion(false)
                        return }
                    self.fetchedSubs = documents.compactMap({try? $0.data(as: Sub.self)})
                    completion(true)
                    return
                }
            
        }
    
    
    
    
    
    
    // MARK: get public branches
    func fetchPublicBranches(completion: @escaping (_ success: Bool) -> ()) {
        guard let userID = AuthViewModel.shared.userID else {
            print("userID is not valid here in fetchMoment function")
            completion(false)
            return
        }
        
        
        COLLECTION_BRANCHES
            .whereField("openness", isEqualTo: OpenType.Public.rawValue)
            .order(by: "comments", descending: true)
            .limit(to: 20)
            .addSnapshotListener { snapshot, _ in
                guard let documents = snapshot?.documents else {
                    completion(false)
                    return }
                self.fetchedPublicBranches = documents.compactMap({try? $0.data(as: Branch.self)})
                completion(true)
                return
            }
        
    }
    
    
    // MARK: get subscribed branches
    func fetchSubscribedBranches(completion: @escaping (_ success: Bool) -> ()) {
        guard let userID = AuthViewModel.shared.userID else {
            print("userID is not valid here in fetchMoment function")
            completion(false)
            return
        }
        
        
        COLLECTION_SUBS
            .whereField("userID", isEqualTo: userID)
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else {
                    completion(false)
                    return }
                self.fetchedUserSubscribedBranchIDs = documents.compactMap({try? $0.data(as: Sub.self)})
                
                let subscribedBranchIDs = self.fetchedUserSubscribedBranchIDs.map{$0.branchID}
                
                if !subscribedBranchIDs.isEmpty{
                    COLLECTION_BRANCHES
                        .whereField("openness", isEqualTo: OpenType.Public.rawValue)
                        .whereField("isSubed", isEqualTo: true)
                        .whereField("id", in: subscribedBranchIDs)
                        .getDocuments { snapshot, _ in
                            guard let documents = snapshot?.documents else {
                                completion(false)
                                return }
                            self.fetchedSubscribedBranches = documents.compactMap({try? $0.data(as: Branch.self)})
                            completion(true)
                            return
                        }
                } else {
                    completion(false)
                    return
                }
                
               
                
            }
    }
    
    
    
}
