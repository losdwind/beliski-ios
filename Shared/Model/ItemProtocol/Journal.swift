//
//  Journal.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/8.
//

import Foundation
import FirebaseFirestoreSwift
import Firebase
import UIKit
import CoreLocation
import MapKit

struct Journal:Identifiable, Codable, Hashable, Item{
    
    // Item Protocol
    var id: String = UUID().uuidString
    @ServerTimestamp var serverTimestamp: Timestamp?
    var localTimestamp: Timestamp?
    var ownerID:String = ""
    var linkedItems: [String] = []  //actually here the string is the id of the linked items

    
    var content: String = ""
    var wordCount: Int = 0
    var imageURLs: [String] = []
    var audioURLs: [String] = []
    var videoURLs: [String] = []
    var tagNames:[String] = []
    
    //    https://developer.apple.com/documentation/foundation/archives_and_serialization/encoding_and_decoding_custom_types
    //    var location: CLLocation? it is not support by codable protocal, pending solved
    
    
}
