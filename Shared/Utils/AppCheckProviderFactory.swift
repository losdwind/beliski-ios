//
//  AppCheckProviderFactory.swift
//  Beliski
//
//  Created by Losd wind on 2021/11/26.
//

import Foundation
import Firebase

class BeliskiAppCheckProviderFactory: NSObject, AppCheckProviderFactory {
  func createProvider(with app: FirebaseApp) -> AppCheckProvider? {
    if #available(iOS 14.0, *) {
      return AppAttestProvider(app: app)
    } else {
      return DeviceCheckProvider(app: app)
    }
  }
}
