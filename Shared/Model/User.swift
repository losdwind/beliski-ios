//
//  Profile.swift
//  Beliski2
//
//  Created by Losd wind on 2021/9/22.
//

import Firebase
import FirebaseFirestoreSwift
import Foundation



enum SocialMediaCategory: String, CaseIterable{
    case facebook
    case instagram
    case linkedin
    case paypal
    case pinterest
    case skype
    case spotify
    case twitter
    case youtube
}

enum Marriage:String, CaseIterable {
    case single
    case married
    case divorced
    case separated
    case spouseDeceased
}


enum Income:String, CaseIterable {
    case single
    case married
    case divorced
    case separated
    case spouseDeceased
}



struct User: Identifiable, Codable, Hashable {
    
    // can be retreive from the Auth.auth().currentUser : uid, email. photoURL
    var id: String?
    var email: String?
    var profileImageURL: String?
    var nickName: String? //first name, family name
    var dateCreated:Timestamp?

}



struct UserPrivate: Identifiable, Codable, Hashable{
    
    // can be retreive from the Auth.auth().currentUser : uid, email. photoURL
    var id: String = UUID().uuidString
    var email: String?
    
    var profileImageURL: String?
    var nickName: String? //first name, family name
    var dateCreated:Timestamp?
    
    var bio: String?
    
    var realName:String?
    var gender:String?
    var birthday:Timestamp?
    var address:String?
    var mobile:String?
    var job:String?
    var income:String?
    var marriage:String?
    
    var socialMedia:Dictionary<String,String>? // phone, facebook, twitter, wechat
    
    
    var interest:[String]? //fishing, gaming
    var bigFive:Dictionary<String,Int>? //O C E A N
    var WBIndex:Dictionary<String, Int>? // career, health, emotion, finance, community
    var trajectories:String? // save in google storage
    var misc:String?

}


struct UserGivenSubsList: Identifiable, Codable, Hashable{
    var id:String = UUID().uuidString
    var likes:[String] = []
    var disLikes:[String] = []
    var comments:[String] = []
    var shares:[String] = []
    var subs:[String] = []
}

struct UserGivenSubs: Identifiable, Codable, Hashable{
    var id:String = UUID().uuidString
    var likes:Int = 0
    var disLikes:Int = 0
    var comments:Int = 0
    var shares:Int = 0
    var subs:Int = 0
}

struct UserReceivedSubs: Identifiable, Codable, Hashable{
    var id:String = UUID().uuidString
    var likes:Int = 0
    var disLikes:Int = 0
    var comments:Int = 0
    var shares:Int = 0
    var subs:Int = 0
}

