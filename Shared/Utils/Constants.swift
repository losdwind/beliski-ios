//
//  Constants.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/7.
//

import Foundation
import Firebase
import FirebaseFirestore


let COLLECTION_USERS = Firestore.firestore().collection("users")


let JOBS = [
    "Architecture and engineering" : ["Architect","Civil engineer","Landscape architect","Sustainable designer","Biomedical engineer"],
    
    "Arts, culture and entertainment" : ["Singer/songwriter",
                                         "Music producer",
                                         "Art curator",
                                         "Animator/video game designer",
                                         "Filmmaker",
                                         "Graphic designer",
                                         "Fashion designer",
                                         "Photographer"]
    
]
