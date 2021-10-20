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
    @DocumentID var id:String?
    @ServerTimestamp var serverTimestamp: Timestamp?
    var localTimestamp: Timestamp?
    var ownerID: String = "unknown"
    var name: String = ""
    var linkedID:[String] = []
    var linkedIDCount:Int {
        linkedID.count
    }
    var size: CGFloat = 0
}
