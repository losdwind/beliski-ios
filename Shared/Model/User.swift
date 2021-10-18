//
//  Profile.swift
//  Beliski2
//
//  Created by Losd wind on 2021/9/22.
//


import FirebaseFirestoreSwift
import Foundation

struct User: Identifiable, Codable, Hashable {
    @DocumentID var id: String?
    var username: String
    var email: String
    var profileImageUrl: String
    var fullname: String
    var bio: String 
    
}
