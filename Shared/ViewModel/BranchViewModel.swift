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
    @Published var fetchedBranches: [Branch] = [Branch]()
    
    
    
    
    // MARK: Upload Branch
    func uploadBranch(completion: @escaping (_ success: Bool) -> ()) {
        
        guard let userID = AuthViewModel.shared.userID else {
            print("userID is not valid here in fetchJournal function")
            completion(false)
            return
        }
        branch.ownerID = userID
        
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
    
    func deleteBranch(journal: Journal, handler: @escaping (_ success: Bool) -> ()){
        
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
    func fetchBranchs(completion: @escaping (_ success: Bool) -> ()) {
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
                self.fetchedBranches = documents.compactMap({try? $0.data(as: Branch.self)})
                completion(true)
                return
            }
            
    }
    
    // MARK: get shared branches
    func fetchSharedBranchs(completion: @escaping (_ success: Bool) -> ()) {
        guard let userID = AuthViewModel.shared.userID else {
            print("userID is not valid here in fetchJournal function")
            completion(false)
            return
        }
        
        
        COLLECTION_USERS.document(userID).collection("branches")
            .whereField("openess", isNotEqualTo: OpenType.OnInvite.rawValue)
            .addSnapshotListener { snapshot, _ in
                guard let documents = snapshot?.documents else {
                    completion(false)
                    return }
                self.fetchedBranches = documents.compactMap({try? $0.data(as: Branch.self)})
                completion(true)
                return
            }
    }
    
    
    
    
}
