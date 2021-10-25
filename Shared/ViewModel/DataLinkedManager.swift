//
//  DataManager.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/19.
//

import Foundation

//https://developer.apple.com/documentation/swiftui/list
// display hierachical data
class DataLinkedManager: ObservableObject {
    

    @Published var linkedIds:[String] = []
    @Published var linkedJournals:[Journal] = [Journal]()
    @Published var linkedTasks:[Task] = [Task]()
    @Published var linkedPersons:[Person] = [Person]()
    
    
    init(linkedIDs: [String]){
        self.linkedIds = linkedIDs
        self.fetchItems { success in
            if success {
                print("successfully initalize and fetched the linked Items")
            } else {
                print("successfully to initalize and fetched the linked Items, please check if the linkedIDs you provided is compatiable")
            }
        }
    }
    
    
    init(){
    }


    
    // we can simplify by using print("\(String(describing: Self.self))")
    func fetchItems(completion: @escaping (_ sucess: Bool) -> ()){
        
        guard let userID = AuthViewModel.shared.currentUser?.id else {
            print("userID is not valid here in fetchJournal function")
            return
        }
        
        
        self.linkedJournals = [Journal]()
        self.linkedTasks = [Task]()
        self.linkedPersons = [Person]()
        
        
        let group = DispatchGroup()
        
        for id in linkedIds {
            
            group.enter()
            COLLECTION_USERS.document(userID).collection("journals").document(id).getDocument { (document, error) in
                let result = Result {
                      try document?.data(as: Journal.self)
                    }
                    switch result {
                    case .success(let journal):
                        if let journal = journal {
                            // A `City` value was successfully initialized from the DocumentSnapshot.
                            self.linkedJournals.append(journal)
                        } else {
                            // A nil value was successfully initialized from the DocumentSnapshot,
                            // or the DocumentSnapshot was nil.
                            print("Document does not exist")
                            return
                        }
                    case .failure(let error):
                        // A `City` value could not be initialized from the DocumentSnapshot.
                        print("Error decoding journal: \(error)")
                        return
                    }
                group.leave()
            }
            
            group.enter()
            COLLECTION_USERS.document(userID).collection("persons").document(id).getDocument { (document, error) in
                let result = Result {
                      try document?.data(as: Person.self)
                    }
                    switch result {
                    case .success(let person):
                        if let person = person {
                            // A `City` value was successfully initialized from the DocumentSnapshot.
                            self.linkedPersons.append(person)
                        } else {
                            // A nil value was successfully initialized from the DocumentSnapshot,
                            // or the DocumentSnapshot was nil.
                            print("Document does not exist")
                            return
                        }
                    case .failure(let error):
                        // A `City` value could not be initialized from the DocumentSnapshot.
                        print("Error decoding city: \(error)")
                        return
                    }
                group.leave()
            }
            
            group.enter()
            COLLECTION_USERS.document(userID).collection("tasks").document(id).getDocument { (document, error) in
                let result = Result {
                      try document?.data(as: Task.self)
                    }
                    switch result {
                    case .success(let task):
                        if let task = task {
                            // A `City` value was successfully initialized from the DocumentSnapshot.
                            self.linkedTasks.append(task)
                        } else {
                            // A nil value was successfully initialized from the DocumentSnapshot,
                            // or the DocumentSnapshot was nil.
                            print("Document does not exist")
                            return
                        }
                    case .failure(let error):
                        // A `City` value could not be initialized from the DocumentSnapshot.
                        print("Error decoding city: \(error)")
                        return
                    }
                group.leave()
            }
            
        }
        group.notify(queue: .main){
            completion(true)
        }
    }
    
    
}
