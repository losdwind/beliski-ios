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
    @DocumentID var id: String?
    @ServerTimestamp var serverTimestamp: Timestamp?
    var localTimestamp: Timestamp?
    var ownerID:String = "unkown"
    var linkedItems: [String] = []

    
    var content: String = "pending to add"
    var wordCount: Int = 0
    var imageURLs: [String] = []
    var audioURLs: [String] = []
    var videoURLs: [String] = []
    var tagNames:[String] = []
    
    //    https://developer.apple.com/documentation/foundation/archives_and_serialization/encoding_and_decoding_custom_types
    //    var location: CLLocation? it is not support by codable protocal, pending solved
    
    
    func convertFIRTimestamptoString(timestamp: Timestamp?) -> String {
        if timestamp != nil {
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
            formatter.maximumUnitCount = 1
            formatter.unitsStyle = .abbreviated
            return formatter.string(from: timestamp!.dateValue(), to: Date()) ?? "Timestamp cannot be converted"
        } else {
            return "Timestamp is nil"
        }

    }
}
