//
//  Task.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/8.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct Task:Identifiable, Codable, Hashable, Item {
    
    // Item Protocol
    var id:String = UUID().uuidString
    @ServerTimestamp var serverTimestamp: Timestamp?
    var localTimestamp: Timestamp?
    var ownerID:String = ""
    var linkedItems:[String] = []
    
    var content:String = ""
    var description:String = ""
    var completion: Bool = false
    var reminder: Timestamp?
    var tagNames:[String] = []
    
    var openess:String = "Private"

    
    
    
}
