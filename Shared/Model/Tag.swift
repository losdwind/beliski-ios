//
//  Tag.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/15.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestoreSwift

// Tag Model...
struct Tag: Identifiable,Hashable, Codable {
    var id: String = UUID().uuidString
    @ServerTimestamp var serverTimestamp: Timestamp?
    var localTimestamp: Timestamp?
    var ownerItemID: String = "unknown"
    var name: String = ""
    var linkedID:[String] = []
    var linkedIDCount:Int = 0
    
    static func == (lhs: Tag, rhs: Tag) -> Bool {
            return lhs.name == rhs.name
        }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
    
    
}
