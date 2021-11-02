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
    
    var memberIDs: Dictionary<String, String> = [String: String]()
    
    var subIDs:[String] = []
    
    var openess: String = "Private"
    
    var address: String = ""
    
    
    
    
    
}
