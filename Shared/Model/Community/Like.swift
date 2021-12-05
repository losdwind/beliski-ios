//
//  Like.swift
//  Beliski
//
//  Created by Losd wind on 2021/11/2.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift


struct Like: Identifiable, Codable {
    var id:String = UUID().uuidString
    var userID:String = ""
    var branchID:String = ""
    @ServerTimestamp var serverTimestamp:Timestamp?
}
