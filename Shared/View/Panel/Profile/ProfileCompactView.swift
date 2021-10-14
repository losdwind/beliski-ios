//
//  ProfileView.swift
//  Beliski-Firebase
//
//  Created by Wind Losd on 2021/9/17.
//

import SwiftUI
import Kingfisher

struct ProfileCompactView: View {
    
    
    
    var body: some View {
        NavigationView {
            
            HStack(alignment: .center, spacing: 20){
                
                KFImage(URL(string: AuthViewModel.shared.currentUser?.profileImageUrl ?? ""))
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
                    .frame(width: 80, height: 80, alignment: .center)
                
                VStack(alignment: .leading, spacing: 10){
                    Text(AuthViewModel.shared.currentUser?.fullname ?? "fullname")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(AuthViewModel.shared.currentUser?.email ?? "email" )
                        .font(.footnote)
                    
                    Text(AuthViewModel.shared.currentUser?.username ?? "username")
                        .font(.footnote)
                    
                    
                    
                    
                }
            }

            
        }

    }
}

struct ProfileView_Previews: PreviewProvider{
    static var previews: some View {
        ProfileCompactView()
            .previewLayout(.sizeThatFits)
        
    }
}


