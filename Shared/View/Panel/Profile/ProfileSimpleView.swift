//
//  ProfileSimpleView.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/29.
//

import SwiftUI

struct ProfileSimpleView: View {
    
    @ObservedObject var profilevm:ProfileViewModel
    
    var body: some View {
        
        VStack{
            AsyncImage(url: URL(string: profilevm.user.profileImageUrl ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                    .padding(4)
                    .background(.white,in: Circle())
                    .background(
                        Circle()
                            .stroke(.black,lineWidth: 4)
                    )
                    
            } placeholder: {
                Image("animoji1")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                    .padding(4)
                    .background(.white,in: Circle())
                    .background(
                        Circle()
                            .stroke(.black,lineWidth: 4)
                    )
            }
            
            Text(profilevm.user.fullname ?? "Aijie Shu")
                .font(.title2)
                .foregroundColor(.primary)
            
        }
        
        
    }
}

struct ProfileSimpleView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSimpleView(profilevm: ProfileViewModel())
    }
}
