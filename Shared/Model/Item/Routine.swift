//
//  Routine.swift
//  Beliski
//
//  Created by Losd wind on 2021/11/28.
//

import Foundation
struct Routine: Identifiable, Codable {
    
    // Item Protocol
    var id: String = UUID().uuidString
    @ServerTimestamp var serverTimestamp: Timestamp?
    var localTimestamp:Timestamp?
    var ownerID: String = ""
    var linkedItems: [String] = []

    
    
    
    
    
}

