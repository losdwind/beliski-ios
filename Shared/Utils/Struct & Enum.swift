//
//  Struct & Enum.swift
//  Beliski-Firebase
//
//  Created by Wind Losd on 2021/9/21.
//

import Foundation
import Firebase
import SwiftUI


enum Filter {
    case today
    case all
}

enum TimelineTab {
    case TODAY
    case EVENTS
    case TOPICS
}

enum MainTab {
    case timeline
    case score
    case create
    case squad
    case community
}

enum WellbeingTab {
    case Career
    case Social
    case Physical
    case Financial
    case Community
}

enum Theme {
    case compact
    case full
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

struct DatabaseMomentField { // Fields within Post Document in Database
    
    static let postID = "post_id"
    static let userID = "user_id"
    static let displayName = "display_name"
    static let caption = "caption"
    static let dateCreated = "date_created"
    
}

enum SearchType: String, CaseIterable {
    case moment
    case todo
    case person
    case branch
}


enum ItemType: CaseIterable {
    case Moment
    case Todo
    case Person
    case Branch
}

enum UploadType:String, CaseIterable {
    case profile
    case moment
    case todo
    case person
    
    var filePath: StorageReference {
        let filename = UUID().uuidString
        switch self {
        case .profile:
            return Storage.storage().reference(withPath: "/profile_medias/\(filename)")
        case .moment:
            return Storage.storage().reference(withPath: "/moment_medias/\(filename)")
        case .todo:
            return Storage.storage().reference(withPath: "/todo_medias/\(filename)")
        case .person:
            return Storage.storage().reference(withPath: "/person_medias/\(filename)")
        }
    }
}


