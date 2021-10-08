//
//  ProfileViewModel.swift
//  Beliski-Firebase
//
//  Created by Wind Losd on 2021/9/21.
//

import Foundation



class ProfileViewModel: ObservableObject{
    
    
    @Published var user: User
    
    init(user: User) {
        self.user = user
    }
    
    
}
