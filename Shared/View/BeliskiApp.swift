//
//  BeliskiApp.swift
//  Shared
//
//  Created by Losd wind on 2021/10/6.
//

import SwiftUI
import Firebase
import GoogleSignIn

@main
struct BeliskiApp: App {
    
    
    init(){
        
        #if targetEnvironment(simulator)
                let providerFactory = AppCheckDebugProviderFactory()
        #else
                let providerFactory = BeliskiAppCheckProviderFactory()
        #endif
        AppCheck.setAppCheckProviderFactory(providerFactory)
        
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
