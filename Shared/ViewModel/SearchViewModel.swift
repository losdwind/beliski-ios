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
    @Published var fileteredBranches:[Branch] = [Branch]()
    
    
    //
    //    @Published var journal:Journal = Journal()
    //    @Published var task:Task = Task()
    //    @Published var person:Person = Person()
    //    @Published var branch:Branch = Branch()
    @Published var selectedJournals: Set<Journal> = Set<Journal>()
    @Published var selectedTasks: Set<Task> = Set<Task>()
    @Published var selectedPersons:Set<Person> = Set<Person>()
    @Published var selectedBranches: Set<Branch> = Set<Branch>()
    
    
    func doubleLink(from item:Any, completion: @escaping(_ success: Bool) -> ()){
        
        var idSet = Set<String>()
        var sourceID = ""
        let group = DispatchGroup()
        
        for journal in selectedJournals{
            idSet.insert(journal.id)
        }
        
        for task in selectedTasks {
            idSet.insert(task.id)
        }
        
        for person in selectedPersons{
            idSet.insert(person.id)
        }
        
        for branch in selectedBranches{
            idSet.insert(branch.id)
        }
        
        
        
        if let source = item as? Journal {
            sourceID = source.id
            let vm = JournalViewModel()
            vm.journal = source
            vm.journal.linkedItems = Array(idSet.union(Set(source.linkedItems)))
            group.enter()
            vm.uploadJournal { success in
                if success {
                    group.leave()
                } else {
                    completion(false)
                    return
                }
            }
        }
        
        if let source = item as? Task {
            sourceID = source.id
            let vm = TaskViewModel()
            vm.task = source
            vm.task.linkedItems = Array(idSet.union(Set(source.linkedItems)))
            group.enter()
            vm.uploadTask { success in
                if success {
                    group.leave()
                } else {
                    completion(false)
                    return
                }
            }
        }
        
        if let source = item as? Person {
            sourceID = source.id
            let vm = PersonViewModel()
            vm.person = source
            vm.person.linkedItems = Array(idSet.union(Set(source.linkedItems)))
            group.enter()
            vm.uploadPerson { success in
                if success {
                    group.leave()
                } else {
                    completion(false)
                    return
                }
            }
        }
        
        
        if let source = item as? Branch {
            sourceID = source.id
            let vm = BranchViewModel()
            vm.branch = source
            vm.branch.linkedItems = Array(idSet.union(Set(source.linkedItems)))
            group.enter()
            vm.uploadBranch { success in
                if success {
                    group.leave()
                } else {
                    completion(false)
                    return
                }
            }
        }
        
        
        
        
        for journal in selectedJournals{
            group.enter()
            if !journal.linkedItems.contains(sourceID){
                var newJournal = journal
                newJournal.linkedItems.append(sourceID)
                let vm = JournalViewModel()
                vm.journal = newJournal
                vm.uploadJournal { success in
                    if success {
                        group.leave()
                    } else {
                        completion(false)
                        return
                    }
                }
                
            }
        }
        
        
        for task in selectedTasks{
            group.enter()
            if !task.linkedItems.contains(sourceID){
                var newTask = task
                newTask.linkedItems.append(sourceID)
                let vm = TaskViewModel()
                vm.task = newTask
                vm.uploadTask { success in
                    if success {
                        group.leave()
                    } else {
                        completion(false)
                        return
                    }
                }
                
            }
        }
        
        
        for person in selectedPersons{
            group.enter()
            if !person.linkedItems.contains(sourceID){
                var newPerson = person
                newPerson.linkedItems.append(sourceID)
                let vm = PersonViewModel()
                vm.person = newPerson
                vm.uploadPerson { success in
                    if success {
                        group.leave()
                    } else {
                        completion(false)
                        return
                    }
                }
                
            }
        }
        
        
        for branch in selectedBranches{
            group.enter()
            if !branch.linkedItems.contains(sourceID){
                var newBranch = branch
                newBranch.linkedItems.append(sourceID)
                let vm = BranchViewModel()
                vm.branch = newBranch
                vm.uploadBranch { success in
                    if success {
                        group.leave()
                    } else {
                        completion(false)
                        return
                    }
                }
                
            }
        }
        
        
        group.notify(queue: .main){
            completion(true)
            self.selectedJournals = Set<Journal>()
            self.selectedTasks = Set<Task>()
            self.selectedPersons = Set<Person>()
            self.selectedBranches = Set<Branch>()
        }
        
        
        
     
        
    }
    
    
    
    
    
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
        
        
        
        group.enter()
        
        COLLECTION_USERS.document(userID).collection("branches")
            .whereField("localTimestamp", isGreaterThanOrEqualTo: Timestamp(date: dateStart))
            .whereField("localTimestamp", isLessThanOrEqualTo: Timestamp(date: dateEnd))
            .order(by: "localTimestamp", descending: true)
            .getDocuments { snapshot, _ in
                guard let documents = snapshot?.documents else {
                    group.leave()
                    return }
                self.fileteredBranches = documents.compactMap({try? $0.data(as: Branch.self)})
                group.leave()
            }
        
        group.notify(queue: .main){
            print("successfully get the filtered items for each type (journals, tasks and persons branches)")
            handler(true)
            return
        }
        
    }
    
}
