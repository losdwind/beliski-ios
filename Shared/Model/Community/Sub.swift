//
//  Sub.swift
//  Beliski
//
//  Created by Losd wind on 2021/11/5.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct Sub: Identifiable, Codable, Hashable {
    
    var id:String = UUID().uuidString
    
    var userID:String = ""
    
    var branchID:String = ""
    
    @ServerTimestamp var serverTimestamp: Timestamp?
    
    
}
