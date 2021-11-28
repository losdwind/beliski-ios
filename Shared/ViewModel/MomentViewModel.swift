//
//  MomentViewModel.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/8.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import UIKit

class MomentViewModel:ObservableObject {
    
    
    @Published var moment = Moment()
    @Published var fetchedMoments = [Moment]()
    
    
    @Published var images:[UIImage] = [UIImage]()
    @Published var audios:[NSData] = [NSData]()
    @Published var videos:[NSData] = [NSData]()
    @Published var OwnerItemID: String = ""
    @Published var localTimestamp:Date = Date()

    
    
    func uploadMoment(handler: @escaping (_ success: Bool) -> ()) {
        
        guard let userID = AuthViewModel.shared.userID else {
            print("userID is not valid in uploadMoment func")
            handler(false)
            return }
        if moment.ownerID == "" {
            moment.ownerID = userID
        }
        
        if moment.ownerID != userID{
            handler(false)
            print("this moment does not belong to you")
            return
        }

        let document = COLLECTION_USERS.document(userID).collection("moments").document(moment.id)
       
        
        print("check if there are image urls in the moment.imageURLs before upload------->\(moment.imageURLs)")
        
        
        // MARK: - here I disabled the uploadImage because i want to upload right after the imagePicker
        

        
        do {
            try document.setData(from: moment)
            handler(true)
            
        } catch let error {
            print("Error upload moment to Firestore: \(error)")
            handler(false)
        }


    }
    
    
    func deleteMoment(moment: Moment, handler: @escaping (_ success: Bool) -> ()){
        
        guard let userID = AuthViewModel.shared.userID else {
            print("userID is not valid")
            return }
        
            let document = COLLECTION_USERS.document(userID).collection("moments").document(moment.id)
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
    
    
    
    
    func fetchMoments(handler: @escaping (_ success: Bool) -> ()) {
        guard let userID = AuthViewModel.shared.userID else {
            print("userID is not valid here in fetchMoment function")
            return
        }
        
        COLLECTION_USERS.document(userID).collection("moments").order(by: "localTimestamp", descending: true).addSnapshotListener { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            self.fetchedMoments = documents.compactMap({try? $0.data(as: Moment.self)})
            handler(true)
        }
    }
    
    
    func fetchTodayMoments(handler: @escaping (_ success: Bool) -> ()) {
        guard let userID = AuthViewModel.shared.userID else {
            print("userID is not valid here in fetchMoment function")
            return
        }
        
        let dayStart = Calendar.current.startOfDay(for: Date())
        
        COLLECTION_USERS.document(userID).collection("moments").whereField("localTimestamp", isGreaterThanOrEqualTo: Timestamp(date: dayStart)).order(by: "localTimestamp", descending: true).addSnapshotListener{ snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            self.fetchedMoments = documents.compactMap({try? $0.data(as: Moment.self)})
            handler(true)
        }
    }

    
    
    
}
