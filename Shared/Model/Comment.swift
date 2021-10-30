//
//  Comment.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/30.
//

import Foundation
import Foundation
import SwiftUI


struct Comment: Identifiable, Hashable {
    
    var id = UUID()
    var commentID: String // ID for the comment in the Database
    var userID: String // ID for the user in the Database
    var username: String // Username for the user in the Database
    var content: String // Actually comment text
    var dateCreated: Date
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}
