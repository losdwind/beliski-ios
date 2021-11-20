//
//  Step.swift
//  Beliski
//
//  Created by Losd wind on 2021/11/20.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct Step: Identifiable, Codable {
    var id:String = UUID().uuidString
    var count: Int = 0
    var localTimestamp: Timestamp = Timestamp(date:Date())
    var ownerID:String = ""
    @ServerTimestamp var serverTimestamp:Timestamp?
}
