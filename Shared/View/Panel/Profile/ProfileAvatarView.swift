//
//  ProfileSimpleView.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/29.
//

import SwiftUI

struct ProfileAvatarView: View {
    
    var profileImageURL:String?
    
    
    var body: some View {
        
            
            if let profileImageURL = profileImageURL {
                AsyncImage(url: URL(string: profileImageURL)) { image in
                    image
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
                        
                 placeholder: {
                    ProgressView()
                }
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
