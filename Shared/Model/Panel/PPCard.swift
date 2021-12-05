//
//  PPCard.swift
//  Beliski
//
//  Created by Losd wind on 2021/11/19.
//

import Foundation
import SwiftUI

struct PPCard: Identifiable, Hashable{
    var id:String = UUID().uuidString
    var title:String = ""
    var description:String = ""
    var detail:String = ""
    var imageURL:String = ""
    var cardColor:Color = Color(.white)
    var category:String = ""
}
