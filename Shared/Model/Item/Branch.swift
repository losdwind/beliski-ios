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
    var dateCreated: Timestamp?
    
    @ServerTimestamp var serverTimestamp: Timestamp?
    
    var localTimestamp: Timestamp?
    
    var ownerID: String = ""
    
    var linkedItems: [String] = []
    
    var title: String = ""
    
    var timeSlot:String = ""
    
    var description: String = ""
    
    var memberIDs: [String] = []
    var memberIDsAvatar:[String] = []
    var memberIDsNickname:[String] = []
    
    
    // FIXME: here we shall not store the strings, maybe in a subcollection, because the id is usually 20 character, while the 1MB limitation only allows maximum 400,000 users
    
    var openness: String = "Private"
    
    
    var address: String = ""
    var category:categoryOfBranch = .Hobby
    
    
    
    
    // statistics

    var likes:Int = 0
    
    var dislikes:Int = 0
    
    var comments:Int = 0
    
    var shares:Int = 0
    
    var subs:Int = 0
    
    var rating:Double = 4.0
    
    
}

extension Branch {
    init(dictionary: [String: Any]) throws {
            self = try JSONDecoder().decode(Branch.self, from: JSONSerialization.data(withJSONObject: dictionary))
        }
}
