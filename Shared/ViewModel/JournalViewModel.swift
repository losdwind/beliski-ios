//
//  JournalViewModel.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/8.
//

import Foundation
import Firebase
import UIKit

class JournalViewModel:ObservableObject {
    
    
    init(){
        
        self.fetchJournals() { success in
            
            if success {
                print("-------->successfully fetched the journals")
            } else {
                print("-------->failed to fetch the journals")
            }
        }
    }

    @Published var journal = Journal()
    @Published var fetchedJournals = [Journal]()
    
    
    @Published var images:[UIImage] = [UIImage]()
    @Published var audios:[NSData] = [NSData]()
    @Published var videos:[NSData] = [NSData]()
    
    
    func uploadJournal(handler: @escaping (_ success: Bool) -> ()) {
        
        guard let userID = AuthViewModel.shared.currentUser?.id else {
            print("userID is not valid in uploadJournal func")
            return }
        var document = COLLECTION_USERS.document(userID).collection("journals").document()
        if journal.id != nil {
            document = COLLECTION_USERS.document(userID).collection("journals").document(journal.id!)
        } else {
            journal.ownerID = userID
        }
        
        print("check if there are image urls in the journal.imageURLs before upload------->\(journal.imageURLs)")
        
        
        // MARK: - here I disabled the uploadImage because i want to upload right after the imagePicker
        
//        if self.images.isEmpty == false {
//
//            var imageURLs:[String] = []
//            for img in self.images {
//                MediaUploader.uploadImage(image: img, type: .journal) { imageUrl in
//                    imageURLs.append(imageUrl)
//                }
//                journal.imageURLs = imageURLs
//            }}
//
//        if self.videos.isEmpty == false {
//
//            var videoURLs:[String] = []
//            for video in self.videos {
//                MediaUploader.uploadVideo(video: video, type: .journal) { videoUrl in
//                    videoURLs.append(videoUrl)
//                }
//                journal.videoURLs = videoURLs
//            }
//        }
        
        do {
            try document.setData(from: journal)
            handler(true)
        } catch let error {
            print("Error upload journal to Firestore: \(error)")
            handler(false)
        }
        self.journal = Journal()
        self.images = [UIImage]()
        self.audios = [NSData]()
        self.videos = [NSData]()

    }
    
    
    
//    func updateJournal(handler: @escaping (_ success: Bool) -> ()){
//        guard let userID = AuthViewModel.shared.currentUser?.id else {
//            print("userID is not valid")
//            return }
//
//        if journal.id != nil {
//            let document = COLLECTION_USERS.document(userID).collection("journals").document(journal.id!)
//
//            do {
//                try document.setData(from: journal)
//                handler(true)
//                return
//            } catch let error {
//                print("Error updating journal to Firestore: \(error)")
//                handler(false)
//                return
//            }
//
//        } else {
//            self.journal = self.journal
//            self.updateJournal { success in
//                print("suppose to update journal but the journal is not exist in database, so we help you uploaded it")
//                handler(true)
//                return
//            }
//
//
//        }
//    }
    
    func deleteJournal(journal: Journal, handler: @escaping (_ success: Bool) -> ()){
        
        guard let userID = AuthViewModel.shared.currentUser?.id else {
            print("userID is not valid")
            return }
        
        if journal.id != nil {
            let document = COLLECTION_USERS.document(userID).collection("journals").document(journal.id!)
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
        } else {
            print("journal id is not available, means it's not yet uploaded into the firestore")
            handler(false)
            return
        }
        
    }
    
    
    
    
    func fetchJournals(handler: @escaping (_ success: Bool) -> ()) {
        guard let userID = AuthViewModel.shared.currentUser?.id else {
            print("userID is not valid here in fetchJournal function")
            return
        }
        
        COLLECTION_USERS.document(userID).collection("journals").order(by: "localTimestamp", descending: true).getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            self.fetchedJournals = documents.compactMap({try? $0.data(as: Journal.self)})
            handler(true)
        }
    }
    
}
