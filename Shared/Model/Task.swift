//
//  Task.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/8.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct Task:Identifiable, Codable, Hashable {
    @DocumentID var id:String?
    @ServerTimestamp var serverTimestamp: Timestamp?
    
    var content:String = "untitled"
    var description:String?
    var localTimestamp: Timestamp?
    var completion: Bool = false
    var reminder: Timestamp?
    var linkedItems:[String]?
    var ownerID:String?
    
    
}
