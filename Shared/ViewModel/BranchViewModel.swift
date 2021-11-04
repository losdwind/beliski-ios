//
//  BranchViewModel.swift.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/28.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
class BranchViewModel: ObservableObject {
    
    
    
    @Published var branch:Branch = Branch()
    @Published var localTimestamp:Date = Date()
    
    
    
    
    
    
    
    @Published var fetchedAllBranches: [Branch] = [Branch]()
    @Published var fetchedSharedBranches:[Branch] = [Branch]()
    
    
    
    
    
    // MARK: Upload Branch
    func uploadBranch(completion: @escaping (_ success: Bool) -> ()) {
        
        guard let userID = AuthViewModel.shared.userID else {
            print("userID is not valid here in fetchJournal function")
            completion(false)
            return
        }
        branch.ownerID = userID
//
//        switch branch.openess {
//        case "Private ":
//            let document = COLLECTION_USERS.document(userID).collection("privatebranches").document(branch.id)
//
//        case "OnInvite":
//            let document = COLLECTION_USERS.document(userID).collection("oninvitebranches").document(branch.id)
//
//        case "Public":
//            let document = COLLECTION_USERS.document(userID).collection("publicbranches").document(branch.id)
//
//        }
        let document = COLLECTION_USERS.document(userID).collection("branches").document(branch.id)
        
        
        do {
            try document.setData(from: branch)
            completion(true)
            return
            
        } catch let error {
            print("Error upload branch to Firestore: \(error)")
            completion(false)
            return
        }
        
        
    }
    
    
    // MARK: Delete branch
    
    func deleteBranch(branch: Branch, handler: @escaping (_ success: Bool) -> ()){
        
        guard let userID = AuthViewModel.shared.userID else {
            print("userID is not valid")
            return }
        
            let document = COLLECTION_USERS.document(userID).collection("branches").document(branch.id)
            document.delete() { err in
                if let err = err {
                    print("Error removing branch: \(err)")
                    handler(false)
                    return
                } else {
                    print("Branch successfully removed!")
                    handler(true)
                    return
                }
            }
       
        
    }
    
    
    
    // TODO: addSnapshotListener
    // MARK: get all branches
    func fetchAllBranchs(completion: @escaping (_ success: Bool) -> ()) {
        guard let userID = AuthViewModel.shared.userID else {
            print("userID is not valid here in fetchJournal function")
            completion(false)
            return
        }
        
        
        COLLECTION_USERS.document(userID).collection("branches")
            .addSnapshotListener { snapshot, _ in
                guard let documents = snapshot?.documents else {
                    completion(false)
                    return }
                self.fetchedAllBranches = documents.compactMap({try? $0.data(as: Branch.self)})
                completion(true)
                return
            }
            
    }
    
    
    
}
