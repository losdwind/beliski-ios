//
//  Message.swift
//  Beliski
//
//  Created by Losd wind on 2021/11/2.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct Message:Identifiable, Codable, Hashable {
    
    var id:String = UUID().uuidString
    var userID:String = ""
    var branchID:String = ""
    @ServerTimestamp var serverTimestamp:Timestamp?
    var content: String = ""
    var sendToID:String = ""
    
    static func == (lhs: Message, rhs: Message) -> Bool {
            return lhs.id == rhs.id
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    
    
}
