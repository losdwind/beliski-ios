//
//  action.swift.swift
//  Beliski
//
//  Created by Losd wind on 2021/12/7.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
struct Action: Identifiable, Codable {
    var id:String = UUID().uuidString
    var senderID:String = "" // eg. the user's ID who click a like button
    var objectID:String = "" // eg. the content's ID which is liked by the user
    var receiverID:String = "" // eg. the content's owner's ID
    var onField:String = "likes" // likes, dislikes, subs
    
}
