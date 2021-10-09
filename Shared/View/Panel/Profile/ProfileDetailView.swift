//
//  ProfileDetailView.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/8.
//

import SwiftUI

struct ProfileDetailView: View {
    
    @ObservedObject var profilevm: ProfileViewModel
    
    
    var body: some View {
        Text("here is the form of detail user info, e.g., birthday, gender, interest")
    }
}

struct ProfileDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileDetailView(profilevm: ProfileViewModel())
    }
}
