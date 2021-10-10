//
//  Task.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/8.
//

import Foundation
import FirebaseFirestoreSwift
struct Task:Identifiable {
    @DocumentID var id:String?
    
    var task:String?
    var description:String?
    var timestamp: Date?
    var completion: Bool?
    var reminder: Date?
    
    
    
}
