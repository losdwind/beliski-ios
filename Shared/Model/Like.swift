//
//  Like.swift
//  Beliski
//
//  Created by Losd wind on 2021/11/2.
//

import Foundation
import FirebaseFirestoreSwift

struct Like: Identifiable, Codable {
    var id:UUID = UUID().uuidString
    var ownerID:String
    @ServerTimestamp var serverTimestamp:Timestamp?
    var likeorHate:Int
}
