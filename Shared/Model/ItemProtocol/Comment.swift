//
//  Comment.swift
//  Beliski
//
//  Created by Losd wind on 2021/11/2.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct Comment: Identifiable, Codable, Hashable {
    
    var id:String = UUID().uuidString
    var branchID:String = ""
    @ServerTimestamp var serverTimestamp: Timestamp?
    var content: String = ""
    
    
    var userID:String = ""
    var userProfileImageURL:String = ""
    var nickName:String = ""
    
}
