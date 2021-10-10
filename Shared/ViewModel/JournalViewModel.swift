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
            print("successfully fetched the journals")
        }
    }

    @Published var journalInCreation = Journal()
    @Published var journalInUpdation = Journal()
    @Published var fetchedJournals = [Journal]()
    
    
    @Published var images:[UIImage]?
    @Published var audios:[NSData]?
    @Published var videos:[NSData]?
    
    
    
    @Published var isUpdatingJournal: Bool = false
    
    func uploadJournal(handler: @escaping (_ success: Bool) -> ()) {
        
        guard let userID = AuthViewModel.shared.currentUser?.id else {
            print("userID is not valid")
            return }
        
        let document = COLLECTION_USERS.document(userID).collection("journals").document()
        
        journalInCreation.ownerID = userID
        
        if self.images != nil {
            
            var imageURLs:[String] = []
            for img in self.images! {
                MediaUploader.uploadImage(image: img, type: .journal) { imageUrl in
                    imageURLs.append(imageUrl)
                }
                journalInCreation.imageURLs = imageURLs
            }}
        
        if self.videos != nil {
            
            var videoURLs:[String] = []
            for video in self.videos! {
                MediaUploader.uploadVideo(video: video, type: .journal) { videoUrl in
                    videoURLs.append(videoUrl)
                }
                journalInCreation.videoURLs = videoURLs
            }
        }
        
        // MARK: - pending to support the audios, videos
        //            let data = ["journalID": journal.id,
        //                        "ownerId": journal.ownerID,
        //                        "timestamp": journal.timestamp,
        //                        "serverTimestamp": FieldValue.serverTimestamp(),
        //                        "content": journal.content,
        //                        "imageURL": imageURLs,
        //                        "audioURL":[],
        //                        "videoURL": [],
        //                        "location": "",
        //                        "linkedJournal": []
        //            ] as [String : Any]
        
        
        do {
            try document.setData(from: journalInCreation)
            handler(true)
            return
        } catch let error {
            print("Error upload journal to Firestore: \(error)")
            handler(false)
            return
        }
        
        
    }
    
    
    
    func updateJournal(handler: @escaping (_ success: Bool) -> ()){
        guard let userID = AuthViewModel.shared.currentUser?.id else {
            print("userID is not valid")
            return }
        
        if journalInUpdation.id != nil {
            let document = COLLECTION_USERS.document(userID).collection("journals").document(journalInUpdation.id!)
            
            do {
                try document.setData(from: journalInUpdation)
                handler(true)
                return
            } catch let error {
                print("Error updating journal to Firestore: \(error)")
                handler(false)
                return
            }
            
        } else {
            self.journalInCreation = self.journalInUpdation
            self.updateJournal { success in
                print("suppose to update journal but the journal is not exist in database, so we help you uploaded it")
                handler(true)
                return
            }


        }
    }
    
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
            print("userID is not valid")
            return }
        
        COLLECTION_USERS.document(userID).collection("journals").order(by: "timestamp", descending: true).getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            self.fetchedJournals = documents.compactMap({try? $0.data(as: Journal.self)})
            handler(true)
        }
    }
    
}
