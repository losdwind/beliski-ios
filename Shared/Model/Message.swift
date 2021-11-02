//
//  Message.swift
//  Beliski
//
//  Created by Losd wind on 2021/11/2.
//

import Foundation

struct Message:Identifiable, Codable {
    var id:UUID = UUID().uuidString
    var ownerID:String
    @ServerTimestamp var serverTimestamp:Timestamp?
    var content: String
    var sendToID:String
}
