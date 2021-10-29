//
//  ProfileView.swift
//  Beliski-Firebase
//
//  Created by Wind Losd on 2021/9/17.
//

import SwiftUI
import Kingfisher

struct ProfileCompactView: View {
    
    @ObservedObject var profilevm:ProfileViewModel
    
    var body: some View {
        VStack{
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
                    Text(profilevm.user.fullname ?? "Aijie Shu")
                        .font(.title2)
                        .foregroundColor(.primary)
                    
//                    Text(AuthViewModel.shared.currentUser?.email ?? "aijieshu@figurich.com" )
//                        .font(.footnote)
                    
                    Text("@\(profilevm.user.username ?? "ajshu#24156")")
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
        
            Divider().frame(width: 150, alignment: .center)
                .padding()
        
        HStack(alignment: .center, spacing: 60){
            
            // MARK: POSTS
            VStack(alignment: .center, spacing: 5, content: {
                Text("13")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Capsule()
                    .fill(Color.gray)
                    .frame(width: 20, height: 2, alignment: .center)
                
                Text("Posts")
                    .font(.callout)
                    .fontWeight(.medium)
            })
            
            // MARK: LIKES
            VStack(alignment: .center, spacing: 5, content: {
                Text("213")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Capsule()
                    .fill(Color.gray)
                    .frame(width: 20, height: 2, alignment: .center)
                
                Text("Likes")
                    .font(.callout)
                    .fontWeight(.medium)
            })
            
            // MARK: Subs
            VStack(alignment: .center, spacing: 5, content: {
                Text("7")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Capsule()
                    .fill(Color.gray)
                    .frame(width: 20, height: 2, alignment: .center)
                
                Text("Subs")
                    .font(.callout)
                    .fontWeight(.medium)
            })
            
        }
            
        }
        .padding()

            
    }
}

struct ProfileView_Previews: PreviewProvider{
    static var previews: some View {
        ProfileCompactView(profilevm: ProfileViewModel())
            .previewLayout(.sizeThatFits)
        
    }
}


