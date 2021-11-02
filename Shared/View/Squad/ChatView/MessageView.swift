//
//  MessageView.swift
//  Beliski
//
//  Created by Losd wind on 2021/11/2.
//

import SwiftUI
import KingfisherSwiftUI

struct MessageView: View {
    
    
    let message: Message
    
    let profileImageURL:String

    @ObservedObject var squadvm:SquadViewModel
    
    init(message:Message, squadvm:SquadViewModel){
        squadvm.getProfile(message: message){ user in
            if let user = user {
                self.profileImageURL = user.profileImageURL
            }
    }
    
        
    var body: some View {
        HStack {
            if viewModel.isFromCurrentUser {
                Spacer()
                Text(message.message)
                    .padding()
                    .background(Color.blue)
                    .clipShape(ChatBubble(isFromCurrentUser: true))
                    .foregroundColor(.white)
                    .padding(.horizontal)
                    .padding(.leading, 100)
                    .padding(.trailing, 16)
                    .font(.body)
            } else {
                HStack(alignment: .bottom) {
                    
                    KFImage(URL(string:profileImageURL
                    ) )
                        
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                    
                    Text(message.message)
                        .padding()
                        .background(Color(.systemGray5))
                        .font(.body)
                        .clipShape(ChatBubble(isFromCurrentUser: false))
                        .foregroundColor(.black)
                    
                }
                .padding(.horizontal)
                .padding(.trailing, 100)
                .padding(.leading, 16)
                Spacer()
            }
            
        }
    }
}
