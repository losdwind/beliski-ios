//
//  PersonViewModel.swift
//  Beliski
//
//  Created by Wind Losd on 2021/5/25.
//

import Foundation
import CoreData
import MapKit
import UIKit
import Firebase
import FirebaseFirestoreSwift

class PersonViewModel: ObservableObject {
    @Published var person:Person = Person()
    @Published var avatarImage:UIImage = UIImage()
    @Published var images:[UIImage] = [UIImage]()
    @Published var audios:[NSData] = [NSData]()
    @Published var videos:[NSData] = [NSData]()
    @Published var birthday:Date = Date()
    @Published var tags:[Tag] = [Tag]()
    
    @Published var fetchedPersons:[Person] = [Person]()
    
    
    
    func uploadPerson(handler: @escaping (_ success: Bool) -> ()) {
        
        guard let userID = AuthViewModel.shared.currentUser?.id else {
            print("userID is not valid in uploadTask func")
            return }
        var document = COLLECTION_USERS.document(userID).collection("persons").document()
        if person.id != nil {
            document = COLLECTION_USERS.document(userID).collection("persons").document(person.id!)
        } else {
            person.ownerID = userID
        }
        
        
        
        // MARK: - here I disabled the uploadImage because i want to upload right after the imagePicker
        

        
        do {
            try document.setData(from: person)
            handler(true)
            
        } catch let error {
            print("Error upload person to Firestore: \(error)")
            handler(false)
        }


    }
    
    
    func deletePerson(task: Task, handler: @escaping (_ success: Bool) -> ()){
        
        guard let userID = AuthViewModel.shared.currentUser?.id else {
            print("userID is not valid")
            return }
        
        if person.id != nil {
            let document = COLLECTION_USERS.document(userID).collection("persons").document(person.id!)
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
            print("person id is not available, means it's not yet uploaded into the firestore")
            handler(false)
            return
        }
        
    }
    
    
    
    
    func fetchPersons(handler: @escaping (_ success: Bool) -> ()) {
        guard let userID = AuthViewModel.shared.currentUser?.id else {
            print("userID is not valid here in fetchPerson function")
            return
        }
        
        COLLECTION_USERS.document(userID).collection("persons").order(by: "localTimestamp", descending: true).getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            self.fetchedPersons = documents.compactMap({try? $0.data(as: Person.self)})
            handler(true)
        }
    }
    
    
    func fetchTodayPersons(handler: @escaping (_ success: Bool) -> ()) {
        guard let userID = AuthViewModel.shared.currentUser?.id else {
            print("userID is not valid here in fetchPerson function")
            return
        }
        
        let dayStart = Calendar.current.startOfDay(for: Date())
        
        COLLECTION_USERS.document(userID).collection("persons").whereField("localTimestamp", isGreaterThanOrEqualTo: Timestamp(date: dayStart)).order(by: "localTimestamp", descending: true).getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            self.fetchedPersons = documents.compactMap({try? $0.data(as: Person.self)})
            handler(true)
        }
    }
    
    
    
    
    
    
}
