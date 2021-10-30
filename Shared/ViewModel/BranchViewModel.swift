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
    
    func fetchBranchs(completion: @escaping (_ success: Bool) -> ()) {
        guard let userID = AuthViewModel.shared.userID else {
            print("userID is not valid here in fetchJournal function")
            completion(false)
            return
        }
        
        
        COLLECTION_USERS.document(userID).collection("branches")
//            .whereField("memberIDs", arrayContains: userID)
            .getDocuments { snapshot, _ in
                guard let documents = snapshot?.documents else {
                    completion(false)
                    return }
                self.fetchedBranches = documents.compactMap({try? $0.data(as: Branch.self)})
                completion(true)
                return
            }
    }
    
    
    
    
}
