//
//  Struct & Enum.swift
//  Beliski-Firebase
//
//  Created by Wind Losd on 2021/9/21.
//

import Foundation




enum MainTab {
    case timeline
    case score
    case create
    case squad
    case community
}

struct CurrentUserDefaults { // Fields for UserDefaults saved within app
    
    static let userID = "user_id"
    static let userName = "user_name"
    static let displayName = "display_name"
    static let bio = "bio"

    
}

struct DatabaseUserField { // Fields within the User Document in Database
    
    static let displayName = "display_name"
    static let email = "email"
    static let providerID = "provider_id"
    static let provider = "provider"
    static let userID = "user_id"
    static let bio = "bio"
    static let dateCreated = "date_created"
    
}

struct DatabaseJournalField { // Fields within Post Document in Database
    
    static let postID = "post_id"
    static let userID = "user_id"
    static let displayName = "display_name"
    static let caption = "caption"
    static let dateCreated = "date_created"
    
}
