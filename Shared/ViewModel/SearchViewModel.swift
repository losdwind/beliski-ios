//
//  SearchViewModel.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/15.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

//enum SearchItemConfig {
//    case followers(String)
//    case following(String)
//    case likes(String)
//    case search
//    case newMessage
//}

class SearchViewModel: ObservableObject {
    
    
    @Published var keywords:String = ""
    @Published var tags:[String] = []
    @Published var dateStart:Date = Date(timeIntervalSince1970: 0)
    @Published var dateEnd:Date = Date()
    @Published var searchType:SearchType = .journal
    
    
    @Published var filteredJournals: [Journal] = [Journal]()
    @Published var filteredTasks: [Task] = [Task]()
    @Published var fileteredPersons:[Person] = [Person]()
    
    
    @Published var selectedJournals: Set<Journal> = Set<Journal>()
    @Published var selectedTasks: Set<Task> = Set<Task>()
    @Published var selectedPersons:Set<Person> = Set<Person>()
    
    
    func fetchIDsFromFilter(handler: @escaping(_ success: Bool) -> ()){
        
        guard let userID = AuthViewModel.shared.userID else {
            print("userID is not valid in uploadJournal func")
            return }

        
        let group = DispatchGroup()
        
        group.enter()
            
        COLLECTION_USERS.document(userID).collection("journals")
            .whereField("localTimestamp", isGreaterThanOrEqualTo: Timestamp(date: dateStart))
            .whereField("localTimestamp", isLessThanOrEqualTo: Timestamp(date: dateEnd))
            .order(by: "localTimestamp", descending: true)
            .getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else {
                group.leave()
                return }
            self.filteredJournals = documents.compactMap({try? $0.data(as: Journal.self)})
                group.leave()
        }
        
        group.enter()
            
        COLLECTION_USERS.document(userID).collection("tasks")
            .whereField("localTimestamp", isGreaterThanOrEqualTo: Timestamp(date: dateStart))
            .whereField("localTimestamp", isLessThanOrEqualTo: Timestamp(date: dateEnd))
            .order(by: "localTimestamp", descending: true)
            .getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else {
                group.leave()
                return }
            self.filteredTasks = documents.compactMap({try? $0.data(as: Task.self)})
                group.leave()
        }
        
        
        group.enter()
            
        COLLECTION_USERS.document(userID).collection("persons")
            .whereField("localTimestamp", isGreaterThanOrEqualTo: Timestamp(date: dateStart))
            .whereField("localTimestamp", isLessThanOrEqualTo: Timestamp(date: dateEnd))
            .order(by: "localTimestamp", descending: true)
            .getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else {
                group.leave()
                return }
            self.fileteredPersons = documents.compactMap({try? $0.data(as: Person.self)})
                group.leave()
        }
        
        group.notify(queue: .main){
            print("successfully get the filtered items for each type (journals, tasks and persons)")
            handler(true)
            return
        }
        
    }
    
}
