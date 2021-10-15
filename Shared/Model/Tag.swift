//
//  Tag.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/15.
//

import Foundation
import SwiftUI

// Tag Model...
struct Tag: Identifiable,Hashable {
    var id = UUID().uuidString
    var text: String
    var size: CGFloat = 0
}
