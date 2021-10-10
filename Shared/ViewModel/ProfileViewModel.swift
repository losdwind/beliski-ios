//
//  ProfileViewModel.swift
//  Beliski-Firebase
//
//  Created by Wind Losd on 2021/9/21.
//

import Foundation



class ProfileViewModel: ObservableObject{
    
    
    // MARK: - here is the issue that the use could be nil becuase the AuthViewModel may not initlize the currentUser correctly (on time)
    @Published var user: User? = AuthViewModel.shared.currentUser
    

    
    
}
