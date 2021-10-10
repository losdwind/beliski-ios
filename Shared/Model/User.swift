//
//  Profile.swift
//  Beliski2
//
//  Created by Losd wind on 2021/9/22.
//


import FirebaseFirestoreSwift

struct User: Identifiable, Decodable {
    @DocumentID var id: String?
    var username: String
    var email: String
    var profileImageUrl: String
    var fullname: String
    var bio: String?
    var isCurrentUser: Bool { return AuthViewModel.shared.userSession?.uid == id }
    
}
