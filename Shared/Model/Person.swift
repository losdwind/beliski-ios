//
//  Person.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/8.
//

import Foundation
import FirebaseFirestoreSwift
import UIKit
import CoreLocation

struct Person: Identifiable {
    @DocumentID var id: String?
    var timestamp:Date
    var address:CLLocation?
    var birthday:Date?
    var contact:String?
    var describe:String?
    var firstName:String?
    var lastName:String?
    var avatar:UIImage?
    var photos:[UIImage]?
    var priority = 1
}
