//
//  Comment.swift
//  Beliski
//
//  Created by Losd wind on 2021/11/2.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct Comment: Identifiable, Codable {
    
    var id:String = UUID().uuidString
    
    var ownerID:String
    
    @ServerTimestamp var serverTimestamp: Timestamp?
    
    var content: String
    
}
