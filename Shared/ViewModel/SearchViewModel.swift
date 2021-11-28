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
    @Published var searchType:SearchType = .moment
    
    
    
    
    @Published var filteredMoments: [Moment] = [Moment]()
    @Published var filteredTodos: [Todo] = [Todo]()
    @Published var filteredPersons:[Person] = [Person]()
    @Published var filteredBranches:[Branch] = [Branch]()
    
    
    //
    //    @Published var moment:Moment = Moment()
    //    @Published var todo:Todo = Todo()
    //    @Published var person:Person = Person()
    //    @Published var branch:Branch = Branch()
    @Published var selectedMoments: Set<Moment> = Set<Moment>()
    @Published var selectedTodos: Set<Todo> = Set<Todo>()
    @Published var selectedPersons:Set<Person> = Set<Person>()
    @Published var selectedBranches: Set<Branch> = Set<Branch>()
    
    
    func doubleLink(from item:Any, completion: @escaping(_ success: Bool) -> ()){
        
        var idSet = Set<String>()
        var sourceID = ""
        let group = DispatchGroup()
        
        for moment in selectedMoments{
            idSet.insert(moment.id)
        }
        
        for todo in selectedTodos {
            idSet.insert(todo.id)
        }
        
        for person in selectedPersons{
            idSet.insert(person.id)
        }
        
        for branch in selectedBranches{
            idSet.insert(branch.id)
        }
        
        
        
        if let source = item as? Moment {
            sourceID = source.id
            let vm = MomentViewModel()
            vm.moment = source
            vm.moment.linkedItems = Array(idSet.union(Set(source.linkedItems)))
            group.enter()
            vm.uploadMoment { success in
                if success {
                    group.leave()
                } else {
                    completion(false)
                    return
                }
            }
        }
        
        if let source = item as? Todo {
            sourceID = source.id
            let vm = TodoViewModel()
            vm.todo = source
            vm.todo.linkedItems = Array(idSet.union(Set(source.linkedItems)))
            group.enter()
            vm.uploadTodo { success in
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
        
        
        
        
        for moment in selectedMoments{
            if !moment.linkedItems.contains(sourceID){
                group.enter()
                var newMoment = moment
                newMoment.linkedItems.append(sourceID)
                let vm = MomentViewModel()
                vm.moment = newMoment
                vm.uploadMoment { success in
                    if success {
                        group.leave()
                    } else {
                        completion(false)
                        return
                    }
                }
                
            }
        }
        
        
        for todo in selectedTodos{
            if !todo.linkedItems.contains(sourceID){
                group.enter()
                var newTodo = todo
                newTodo.linkedItems.append(sourceID)
                let vm = TodoViewModel()
                vm.todo = newTodo
                vm.uploadTodo { success in
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
            if !person.linkedItems.contains(sourceID){
                group.enter()

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
            if !branch.linkedItems.contains(sourceID){
                group.enter()

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
            self.selectedMoments = Set<Moment>()
            self.selectedTodos = Set<Todo>()
            self.selectedPersons = Set<Person>()
            self.selectedBranches = Set<Branch>()
        }
        
        
        
     
        
    }
    
    
    
    
    
    func fetchIDsFromFilter(handler: @escaping(_ success: Bool) -> ()){
        
        guard let userID = AuthViewModel.shared.userID else {
            print("userID is not valid in uploadMoment func")
            return }
        
        
        let group = DispatchGroup()
        
        group.enter()
        
        COLLECTION_USERS.document(userID).collection("moments")
            .whereField("localTimestamp", isGreaterThanOrEqualTo: Timestamp(date: dateStart))
            .whereField("localTimestamp", isLessThanOrEqualTo: Timestamp(date: dateEnd))
            .order(by: "localTimestamp", descending: true)
            .getDocuments { snapshot, _ in
                guard let documents = snapshot?.documents else {
                    group.leave()
                    return }
                self.filteredMoments = documents.compactMap({try? $0.data(as: Moment.self)})
                group.leave()
            }
        
        group.enter()
        
        COLLECTION_USERS.document(userID).collection("todos")
            .whereField("localTimestamp", isGreaterThanOrEqualTo: Timestamp(date: dateStart))
            .whereField("localTimestamp", isLessThanOrEqualTo: Timestamp(date: dateEnd))
            .order(by: "localTimestamp", descending: true)
            .getDocuments { snapshot, _ in
                guard let documents = snapshot?.documents else {
                    group.leave()
                    return }
                self.filteredTodos = documents.compactMap({try? $0.data(as: Todo.self)})
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
                self.filteredPersons = documents.compactMap({try? $0.data(as: Person.self)})
                group.leave()
            }
        
        group.notify(queue: .main){
            print("successfully get the filtered items for each type (moments, todos and persons)")
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
                self.filteredBranches = documents.compactMap({try? $0.data(as: Branch.self)})
                group.leave()
            }
        
        group.notify(queue: .main){
            print("successfully get the filtered items for each type (moments, todos and persons branches)")
            handler(true)
            return
        }
        
    }
    
}
