//
//  ProfileStandardView.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/29.
//

import SwiftUI



struct ProfileStandardView: View {
    @ObservedObject var profilevm:ProfileViewModel
    
    var body: some View {
        HStack(alignment: .center, spacing: 30){
            
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
            
            
            VStack(alignment: .leading, spacing: 10){
                Text(profilevm.user.nickName ?? "Aijie Shu")
                    .font(.title2)
                    .foregroundColor(.primary)
                
                //                    Text(AuthViewModel.shared.currentUser?.email ?? "aijieshu@figurich.com" )
                //                        .font(.footnote)
                
                Text("@\(profilevm.user.userName ?? "ajshu#24156")")
                    .font(.caption)
                
                
                HStack(alignment: .center, spacing: 20){
                    Image("score")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .padding(4)
                        .background(.white,in: Circle())
                    Text("537")
                        .font(.footnote)
                        .foregroundColor(Color.pink)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(
                    Capsule()
                        .stroke(.pink,lineWidth: 1)
                )
                
                
                
                
            }
        }
    }
}


struct ProfileStandardView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileStandardView(profilevm: ProfileViewModel())
    }
}
