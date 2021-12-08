//
//  DataManager.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/19.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

//https://developer.apple.com/documentation/swiftui/list
// display hierachical data
class DataLinkedManager: ObservableObject {
    

    @Published var linkedIds:[String] = []
    @Published var linkedMoments:[Moment] = [Moment]()
    @Published var linkedTodos:[Todo] = [Todo]()
    @Published var linkedPersons:[Person] = [Person]()
    @Published var linkedItems:[Dictionary<String, Any>] = [Dictionary<String, Any>]()
    
    
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
        Functions.functions().httpsCallable("linkedItemsFunctions-onCallLinkedItems").call(linkedIds) { result, error in
          if let error = error {
            print(error)
            // ...
          }
            if let data = result?.data as? [Dictionary<String, Any>] {
              self.linkedItems = data
              print(data)
          }
        }
        

    }
    
    
}
