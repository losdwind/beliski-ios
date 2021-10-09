//
//  Constants.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/7.
//

import Foundation
import Firebase
import FirebaseFirestore


typealias FirestoreCompletion = ((Error?) -> Void)?


let COLLECTION_USERS = Firestore.firestore().collection("users")
