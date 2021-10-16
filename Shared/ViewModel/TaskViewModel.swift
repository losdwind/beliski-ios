//
//  TaskViewModel.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/16.
//

import Foundation
import Foundation
import CoreData
import Firebase
import FirebaseFirestoreSwift

class TaskViewModel: ObservableObject {
    
    @Published var task:Task = Task()
    @Published var reminder: Date = Date()
    @Published var fetchedTasks:[Task] = [Task]()
    
    
    func uploadTask(handler: @escaping (_ success: Bool) -> ()) {
        
        guard let userID = AuthViewModel.shared.currentUser?.id else {
            print("userID is not valid in uploadTask func")
            return }
        var document = COLLECTION_USERS.document(userID).collection("tasks").document()
        if task.id != nil {
            document = COLLECTION_USERS.document(userID).collection("tasks").document(task.id!)
        } else {
            task.ownerID = userID
        }
        
        task.reminder = Timestamp(date: self.reminder)
        
        
        
        // MARK: - here I disabled the uploadImage because i want to upload right after the imagePicker
        

        
        do {
            try document.setData(from: task)
            handler(true)
            
        } catch let error {
            print("Error upload journal to Firestore: \(error)")
            handler(false)
        }


    }
    
    
    func deleteTask(task: Task, handler: @escaping (_ success: Bool) -> ()){
        
        guard let userID = AuthViewModel.shared.currentUser?.id else {
            print("userID is not valid")
            return }
        
        if task.id != nil {
            let document = COLLECTION_USERS.document(userID).collection("tasks").document(task.id!)
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
            print("task id is not available, means it's not yet uploaded into the firestore")
            handler(false)
            return
        }
        
    }
    
    
    
    
    func fetchTasks(handler: @escaping (_ success: Bool) -> ()) {
        guard let userID = AuthViewModel.shared.currentUser?.id else {
            print("userID is not valid here in fetchTasks function")
            return
        }
        
        COLLECTION_USERS.document(userID).collection("tasks").order(by: "localTimestamp", descending: true).getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            self.fetchedTasks = documents.compactMap({try? $0.data(as: Task.self)})
            handler(true)
        }
    }
    
    
    func fetchTodayTasks(handler: @escaping (_ success: Bool) -> ()) {
        guard let userID = AuthViewModel.shared.currentUser?.id else {
            print("userID is not valid here in fetchTasks function")
            return
        }
        
        let dayStart = Calendar.current.startOfDay(for: Date())
        
        COLLECTION_USERS.document(userID).collection("tasks").whereField("localTimestamp", isGreaterThanOrEqualTo: Timestamp(date: dayStart)).order(by: "localTimestamp", descending: true).getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            self.fetchedTasks = documents.compactMap({try? $0.data(as: Task.self)})
            handler(true)
        }
    }
    
    
    
    
    
    

}
