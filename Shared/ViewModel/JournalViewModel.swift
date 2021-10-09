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
    
    @Published var journal = Journal()
    @Published var images:[UIImage]?
    @Published var audios:[NSData]?
    @Published var videos:[NSData]?
    
    @Published var fetchedJournals: [Journal]?
    
    @Published var journalInUpdation:Journal
    
    @Published var isUpdatingJournal: Bool = false
    
    func uploadJournal(handler: @escaping (_ success: Bool) -> ()) {
        
        guard let userID = AuthViewModel.shared.currentUser?.id else { return }
        
        let document = COLLECTION_USERS.document(userID).collection("journals").document()
        
        journal.ownerID = userID
        
        if self.images != nil {
            
            var imageURLs:[String] = []
            for img in self.images! {
                MediaUploader.uploadImage(image: img, type: .journal) { imageUrl in
                    imageURLs.append(imageUrl)
                }
                journal.imageURLs = imageURLs
            }}
        
        if self.videos != nil {
            
            var videoURLs:[String] = []
            for video in self.videos! {
                MediaUploader.uploadVideo(video: video, type: .journal) { videoUrl in
                    videoURLs.append(videoUrl)
                }
                journal.videoURLs = videoURLs
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
            try document.setData(from: journal)
            
            handler(true)
            return
        } catch let error {
            print("Error writing journal to Firestore: \(error)")
            handler(false)
            return
        }
        
    }
    
    
    
    func updateJournal(handler: @escaping (_ success: Bool) -> ()){
        handler(true)
    }
    
    func deleteJournal(handler: @escaping (_ success: Bool) -> ()){
        handler(true)
    }
    
    
    
    
    func fetchJournals(handler: @escaping (_ success: Bool) -> ()) {
        guard let userID = AuthViewModel.shared.currentUser?.id else { return }
        
        COLLECTION_USERS.document(userID).collection("journals").order(by: "timestamp", descending: true).getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            self.fetchedJournals = documents.compactMap({try? $0.data(as: Journal.self)})
            handler(true)
        }
    }
    
}
