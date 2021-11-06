//
//  Profile.swift
//  Beliski2
//
//  Created by Losd wind on 2021/9/22.
//

import Firebase
import FirebaseFirestoreSwift
import Foundation

struct User: Identifiable, Codable, Hashable {
    
    // can be retreive from the Auth.auth().currentUser : uid, email. photoURL
    var id: String?
    var email: String?
    var providerID:String?
    var providerName: String?
    var profileImageURL: String?
    var userName: String?
    var nickName: String? //first name, family name
    var dateCreated:Timestamp?

}



struct Private: Identifiable, Codable, Hashable{
    
    // can be retreive from the Auth.auth().currentUser : uid, email. photoURL
    var id: String = UUID().uuidString
    var email: String?
    var providerID:String?
    var providerName: String?
    var profileImageURL: String?
    var userName: String?
    var nickName: String? //first name, family name
    var dateCreated:Timestamp?
    
    var bio: String?
    var gender:String?
    var birthday:Timestamp?
    var address:String?
    var contact:Dictionary<String,String>? // phone, facebook, twitter, wechat
    var job:String?
    var income:String?
    var marriage:String?
    var interest:[String]? //fishing, gaming
    var bigFive:Dictionary<String,Int>? //O C E A N
    var WBIndex:Dictionary<String, Int>? // career, health, emotion, finance, community
    var trajectories:String? // save in google storage
    var misc:String?

}


struct UserSubscibe: Identifiable, Codable, Hashable{
    var id:String?
    var profileImageURL: String?
    var userName: String?
    var nickName: String? //first name, family name
    
    var likes:[String]
    var disLikes:[String]
    var comments:[String]
    var shares:[String]
    var subs:[String]
}
