//
//  ProfileSimpleView.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/29.
//

import SwiftUI
import Kingfisher
struct ProfileAvatarView: View {
    
    var profileImageURL:String?
    
    
    var body: some View {
        
            
            if let profileImageURL = profileImageURL {
                KFImage(URL(string: profileImageURL))
                    .placeholder {
                        // Placeholder while downloading.
                        Image(systemName: "arrow.2.circlepath.circle")
                            .font(.largeTitle)
                            .opacity(0.3)
                    }
                 .resizable()
                 .aspectRatio(contentMode: .fit)
                 .frame(width: 20, height: 20)
                 .padding(4)
                 .background(.white,in: Circle())
             // border...
                 .background(
                     
                     Circle()
                         .stroke(.black,lineWidth: 1)
                 )
                 
                 
            } else {
                Image("animoji1")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .padding(4)
                    .background(.white,in: Circle())
                // border...
                    .background(
                        
                        Circle()
                            .stroke(.black,lineWidth: 1)
                    )
            }
            
            
        }
    
}

struct ProfileSimpleView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileAvatarView(profileImageURL: nil)
    }
}
