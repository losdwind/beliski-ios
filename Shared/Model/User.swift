//
//  Profile.swift
//  Beliski2
//
//  Created by Losd wind on 2021/9/22.
//


import FirebaseFirestoreSwift

struct User: Identifiable, Decodable {
    @DocumentID var id: String?
    let username: String
    let email: String
    let profileImageUrl: String
    let fullname: String
    var bio: String?
    var isCurrentUser: Bool { return AuthViewModel.shared.userSession?.uid == id }
    
}
