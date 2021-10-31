//
//  Struct & Enum.swift
//  Beliski-Firebase
//
//  Created by Wind Losd on 2021/9/21.
//

import Foundation
import Firebase



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

struct CurrentUserDefaults { // Fields for UserDefaults saved within app
    
    static let userID = "user_id"
    static let userName = "asiefhXLhf#221"
    static let nickName = "Iron Man"
    static let profileImgURL = ""

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

enum SearchType: String, CaseIterable {
    case journal
    case task
    case person
    case branch
}

enum UploadType:String, CaseIterable {
    case profile
    case journal
    case task
    case person
    
    var filePath: StorageReference {
        let filename = NSUUID().uuidString
        switch self {
        case .profile:
            return Storage.storage().reference(withPath: "/profile_medias/\(filename)")
        case .journal:
            return Storage.storage().reference(withPath: "/journal_medias/\(filename)")
        case .task:
            return Storage.storage().reference(withPath: "/task_medias/\(filename)")
        case .person:
            return Storage.storage().reference(withPath: "/person_medias/\(filename)")
        }
    }
}

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
