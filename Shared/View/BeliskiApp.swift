//
//  BeliskiApp.swift
//  Shared
//
//  Created by Losd wind on 2021/10/6.
//

import SwiftUI
import Firebase

@main
struct BeliskiApp: App {
    
    
    init(){
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            MainView()
                .font(.system(.body ,design: .rounded))
                .font(.system(.footnote ,design: .rounded))


        }
    }
}
