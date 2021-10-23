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
    @DocumentID var id:String?
    @ServerTimestamp var serverTimestamp: Timestamp?
    var localTimestamp: Timestamp?
    var ownerID:String = "unkown"
    var linkedItems:[String] = []
    
    var content:String = "untitled"
    var description:String = ""
    var completion: Bool = false
    var reminder: Timestamp?
    var tags:[String] = []
    
    
}
