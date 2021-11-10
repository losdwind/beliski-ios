//
//  JournalViewModel.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/8.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import UIKit

class JournalViewModel:ObservableObject {
    
    
    @Published var journal = Journal()
    @Published var fetchedJournals = [Journal]()
    
    
    @Published var images:[UIImage] = [UIImage]()
    @Published var audios:[NSData] = [NSData]()
    @Published var videos:[NSData] = [NSData]()
    @Published var OwnerItemID: String = ""
    @Published var localTimestamp:Date = Date()

    
    
    func uploadJournal(handler: @escaping (_ success: Bool) -> ()) {
        
        guard let userID = AuthViewModel.shared.userID else {
            print("userID is not valid in uploadJournal func")
            handler(false)
            return }
        if journal.ownerID == "" {
            journal.ownerID = userID
        }
        
        if journal.ownerID != userID{
            handler(false)
            print("this journal does not belong to you")
            return
        }

        let document = COLLECTION_USERS.document(userID).collection("journals").document(journal.id)
       
        
        print("check if there are image urls in the journal.imageURLs before upload------->\(journal.imageURLs)")
        
        
        // MARK: - here I disabled the uploadImage because i want to upload right after the imagePicker
        

        
        do {
            try document.setData(from: journal)
            handler(true)
            
        } catch let error {
            print("Error upload journal to Firestore: \(error)")
            handler(false)
        }


    }
    
    
    func deleteJournal(journal: Journal, handler: @escaping (_ success: Bool) -> ()){
        
        guard let userID = AuthViewModel.shared.userID else {
            print("userID is not valid")
            return }
        
            let document = COLLECTION_USERS.document(userID).collection("journals").document(journal.id)
            document.delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                    handler(false)
                    return
                } else {
                    print("Document successfully removed!")
                    handler(true)
                    return
                }
            }
       
        
    }
    
    
    
    
    func fetchJournals(handler: @escaping (_ success: Bool) -> ()) {
        guard let userID = AuthViewModel.shared.userID else {
            print("userID is not valid here in fetchJournal function")
            return
        }
        
        COLLECTION_USERS.document(userID).collection("journals").order(by: "localTimestamp", descending: true).addSnapshotListener { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            self.fetchedJournals = documents.compactMap({try? $0.data(as: Journal.self)})
            handler(true)
        }
    }
    
    
    func fetchTodayJournals(handler: @escaping (_ success: Bool) -> ()) {
        guard let userID = AuthViewModel.shared.userID else {
            print("userID is not valid here in fetchJournal function")
            return
        }
        
        let dayStart = Calendar.current.startOfDay(for: Date())
        
        COLLECTION_USERS.document(userID).collection("journals").whereField("localTimestamp", isGreaterThanOrEqualTo: Timestamp(date: dayStart)).order(by: "localTimestamp", descending: true).addSnapshotListener{ snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            self.fetchedJournals = documents.compactMap({try? $0.data(as: Journal.self)})
            handler(true)
        }
    }

    
    
    
}
