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
    
    
    
    // for branch
    @Published var fetchedSubscribedBranches:[Branch] = [Branch]()
    @Published var fetchedPublicBranches:[Branch] = [Branch]()
    @Published var currentBranch:Branch = Branch()
    @Published var fetchedCurrentBranchComments:[Comment] = [Comment]()
    
    // for user
    @Published var fetchedUserGivenSubs:UserGivenSubs = UserGivenSubs()
    @Published var fetchedUserGivenSubsList:UserGivenSubsList = UserGivenSubsList()
    @Published var fetchedUserReceivedSubs:UserReceivedSubs = UserReceivedSubs()
    
    // for branch subcollection
    @Published var inputComment:Comment = Comment()
    @Published var inputLike:Like = Like()
    @Published var inputDislike:Dislike = Dislike()
    @Published var inputSub:Sub = Sub()
    
    
    lazy var worldCity = WorldCityJsonReader.shared.worldCity
    lazy var chinaCity = ChinaCityJsonReader.shared.chinaCity
    
    @Published var selectedLocation:WorldCityJsonReader.N?
    @Published var selectedCategory:String = ""
    @Published var isShowingLinkedBranchView = false
    
    
    
    func sendAction(branch:Branch, type:String, completion: @escaping (_ result: String?) -> () ){
        
        guard let userID = AuthViewModel.shared.userID else {
            print("userID is not valid here in like function")
            completion(nil)
            return
        }
        
        let action = Action(senderID: userID, objectID: branch.id, receiverID: branch.ownerID, onField:type)

       
        let actionData = try! Firestore.Encoder().encode(action)
        print(actionData)
        Functions.functions().httpsCallable("communityActionFunctions-onCallAction").call(actionData) { result, error in
          if let error = error {
            print(error)
              completion(nil)
              return
          }
            if let data = result?.data as? [String: Any], let actionResult = data["action"] as? String {
                if actionResult == "added" {
                    print("\(type) it")

                } else {
                    print("cancel \(type) it")
                }
                completion(actionResult)
                return
          }
            print("returned result is not valid, check cloud function")
            completion(nil)
            return
    }
    }
    
    
    // this function check if the current user liked/disliked/subed current branch
    func getStatus(branch:Branch) -> Dictionary<String, Bool>{
        
        var status:Dictionary<String, Bool> = ["isLiked":false, "isDisliked":false, "isSubed":false]
        
        
        
        if self.fetchedUserGivenSubsList.likes.contains(branch.id) {
            status["isLiked"] = true
        }
        
        if self.fetchedUserGivenSubsList.disLikes.contains(branch.id){
            status["isDisliked"] = true
        }
        
        if self.fetchedUserGivenSubsList.subs.contains(branch.id){
            status["isSubed"] = true
        }
        
        return status
    }
    
    
    
    func getUserGivenSubsList(completion: @escaping (_ success: Bool) -> ()) {
        
        guard let userID = AuthViewModel.shared.userID else {
            print("userID is not valid here in like function")
            completion(false)
            return
        }
                
        
        COLLECTION_USERS.document(userID).collection("privates").document("userGivenSubsList").addSnapshotListener { document, error in
            let result = Result {
                try document?.data(as: UserGivenSubsList.self)
            }
            switch result {
            case .success(let userSubsList):
                if let userSubsList = userSubsList {
                    // A `User` value was successfully initialized from the DocumentSnapshot.
                    self.fetchedUserGivenSubsList = userSubsList
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
                print("Error decoding moment: \(error)")
                completion(false)
                return
            }
        }
    }
    
    
    func getUserGivenSubs(completion: @escaping (_ success: Bool) -> ()) {
        
        guard let userID = AuthViewModel.shared.userID else {
            print("userID is not valid here in like function")
            completion(false)
            return
        }
        
        COLLECTION_USERS.document(userID).collection("privates").document("userGivenSubs").addSnapshotListener { document, error in
            let result = Result {
                try document?.data(as: UserGivenSubs.self)
            }
            switch result {
            case .success(let userSubs):
                if let userSubs = userSubs {
                    // A `User` value was successfully initialized from the DocumentSnapshot.
                    self.fetchedUserGivenSubs = userSubs
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
                print("Error decoding moment: \(error)")
                completion(false)
                return
            }
        }
    }
    
    func getUserReceivedSubs(completion: @escaping (_ success: Bool) -> ()) {
        
        guard let userID = AuthViewModel.shared.userID else {
            print("userID is not valid here in like function")
            completion(false)
            return
        }
        
        COLLECTION_USERS.document(userID).collection("privates").document("userReceivedSubs").addSnapshotListener { document, error in
            let result = Result {
                try document?.data(as: UserReceivedSubs.self)
            }
            switch result {
            case .success(let userSubs):
                if let userSubs = userSubs {
                    // A `User` value was successfully initialized from the DocumentSnapshot.
                    self.fetchedUserReceivedSubs = userSubs
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
                print("Error decoding moment: \(error)")
                completion(false)
                return
            }
        }
    }
    
    
    
    // MARK: Send
    // !!!: here exists a performance issue: https://firebase.google.com/docs/firestore/solutions/counters#swift_1
    // TODO: - here we should use security rules to check the sended like has the right userID and branchID
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
    
    func deleteLike(){
        guard let userID = AuthViewModel.shared.userID else {
            print("userID is not valid here in like function")
            return
        }

       COLLECTION_USERS.document(self.currentBranch.ownerID).collection("branches")
            .document(self.currentBranch.id).collection("likes").document(userID)
            .delete()
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
    
    
    func deleteDislike(){
        guard let userID = AuthViewModel.shared.userID else {
            print("userID is not valid here in like function")
            return
        }
        

       COLLECTION_USERS.document(self.currentBranch.ownerID).collection("branches")
            .document(self.currentBranch.id).collection("dislikes").document(userID)
            .delete()
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
    
    
    func deleteComment(){
        guard let userID = AuthViewModel.shared.userID else {
            print("userID is not valid here in like function")
            return
        }
        
  COLLECTION_USERS.document(self.currentBranch.ownerID).collection("branches")
            .document(self.currentBranch.id).collection("comments").document(userID).delete()
        
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
    
    func deleteSub(){
        guard let userID = AuthViewModel.shared.userID else {
            print("userID is not valid here in like function")
            return
        }
        COLLECTION_USERS.document(self.currentBranch.ownerID).collection("branches")
            .document(self.currentBranch.id).collection("subs").document(userID)
            .delete()
        
    }
    
    
    
    
    // MARK: get
    
    // FIXME: I think it is better to use cloud founctions to calculate the
    
    func getComments(branch:Branch,completion: @escaping (_ success: Bool) -> ()) {
        
        let listener = COLLECTION_USERS.document(branch.ownerID).collection("branches").document(branch.id).collection("comments")
            .order(by:"serverTimestamp")
            .limit(to:20)
            .addSnapshotListener { snapshot, _ in
                guard let documents = snapshot?.documents else { return }
                self.fetchedCurrentBranchComments = documents.compactMap({try? $0.data(as: Comment.self)})
                completion(true)
                
            }
        if branch != currentBranch {
            listener.remove()
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
        
        if self.fetchedUserGivenSubsList.subs == [] {
            self.fetchedSubscribedBranches = []
            completion(true)
            return
        }
                
        COLLECTION_BRANCHES.whereField("id", in: self.fetchedUserGivenSubsList.subs)
            .getDocuments { snapshot, _ in
                    guard let documents = snapshot?.documents else {
                        completion(false)
                        return }
                    self.fetchedSubscribedBranches = documents.compactMap({try? $0.data(as: Branch.self)})
                    completion(true)
                    return
                }
            }
        
        
    }
    
