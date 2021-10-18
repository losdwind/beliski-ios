//
//  Person.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/8.
//

import Foundation
import UIKit
import CoreLocation
import Firebase
import FirebaseFirestoreSwift

struct Person: Identifiable, Codable, Hashable {
    
    @DocumentID var id: String?
    @ServerTimestamp var serverTimestamp: Timestamp?
    var localTimestamp:Timestamp?
    var address: [String: String] = [
        "longitude": "",
        "latitude": ""]
    var birthday:Timestamp = Timestamp(date:Date())
    var contact:String = ""
    var description:String = ""
    var wordCount: Int = 0
    var firstName:String = ""
    var lastName:String = ""
    var avatarURL:String = ""
    var photoURLs:[String] = []
    var audioURLs:[String] = []
    var videoURLs:[String] = []
    var priority:Int = 0
    var ownerID:String?
    var labels:[String] = []
}
