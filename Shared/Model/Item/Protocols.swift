//
//  Protocols.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/18.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift


protocol Item: Hashable, Identifiable, Codable {
    var id:String { get set }
    var dateCreated:Timestamp? {get set}
    var serverTimestamp: Timestamp? {get set}
    var localTimestamp: Timestamp? {get set}
//    var isSynced:Bool {get set}
//    var latestVersionID:String {get set}
    var ownerID:String { get set }
    var linkedItems: [String] {get set}
    
}
