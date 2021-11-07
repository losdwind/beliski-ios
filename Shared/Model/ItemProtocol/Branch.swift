//
//  Branch.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/28.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

enum Permission {
    case full
    case edit
    case comment
    case read
}

enum OpenType: String {
    case Public = "Public"
    case Private = "Private"
    case OnInvite = "OnInvite"
}

struct Branch:Identifiable, Codable, Hashable, Item {
    
    var id: String = UUID().uuidString
    
    @ServerTimestamp var serverTimestamp: Timestamp?
    
    var localTimestamp: Timestamp?
    
    var ownerID: String = ""
    
    var linkedItems: [String] = []
    
    var title: String = ""
    
    var timeSlot:String = ""
    
    var description: String = ""
    
    var memberIDs: [String] = []
    
    
    // FIXME: here we shall not store the strings, maybe in a subcollection, because the id is usually 20 character, while the 1MB limitation only allows maximum 400,000 users
    var subIDs:[String] = []
    
    var openess: String = "Private"
    
    var address: String = ""
    
    var likes:Int = 0
    
    var dislikes:Int = 0
    
    var comments:Int = 0
    
    var shares:Int = 0
    
    var subs:Int = 0
    
    
    
    
    
}
