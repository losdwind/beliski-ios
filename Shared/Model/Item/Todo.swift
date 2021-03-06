//
//  Todo.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/8.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct Todo:Identifiable, Codable, Hashable, Item {
    
    // Item Protocol
    var id:String = UUID().uuidString
    var dateCreated: Timestamp?

    @ServerTimestamp var serverTimestamp: Timestamp?
    var localTimestamp: Timestamp?
    var ownerID:String = ""
    var linkedItems:[String] = []
    
    var content:String = ""
    
    var wish:String = ""
    var outcome:String = ""
    var obstacle:String = ""
    var plan:String = ""
    
    var description:String = ""
    
    var completion: Bool = false
    
    var reminder: Timestamp?
    var start:Timestamp?
    var end:Timestamp?
    var tagNames:[String] = []
    
    var isUsingWoop:Bool = true
    var openness:String = "Private"


    

    
}

extension Todo {
    init(dictionary: [String: Any]) throws {
            self = try JSONDecoder().decode(Todo.self, from: JSONSerialization.data(withJSONObject: dictionary))
        }
}
