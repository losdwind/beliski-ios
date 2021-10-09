//
//  ProfileView.swift
//  Beliski-Firebase
//
//  Created by Wind Losd on 2021/9/17.
//

import SwiftUI
import Kingfisher

struct ProfileCompactView: View {
    
    @ObservedObject var profilevm: ProfileViewModel
    
    
    var body: some View {
        NavigationView {
            
            if profilevm.user == nil {
                NavigationLink(destination: LogInView(), label: {
                    Text("Log In")
                        .font(.headline)
                        .foregroundColor(.primary)
                })
            } else{
                

                    HStack(alignment: .center, spacing: 20){
                        
                        KFImage(URL(string: profilevm.user!.profileImageUrl))
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(10)
                            .frame(width: 80, height: 80, alignment: .center)
                        
                        VStack(alignment: .leading, spacing: 10){
                            Text(profilevm.user!.fullname)
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            Text(profilevm.user!.email)
                                .font(.footnote)
                            
                            Text(profilevm.user!.username)
                                .font(.footnote)
                            
                            
                        
                        
                    }
                }
                
                
                
                
                
                
            }
        }
        
        
    }
}

struct ProfileView_Previews: PreviewProvider{
    static var previews: some View {
        ProfileCompactView(profilevm: ProfileViewModel())
            .previewLayout(.sizeThatFits)
        
    }
}


