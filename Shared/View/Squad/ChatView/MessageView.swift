//
//  MessageView.swift
//  Beliski
//
//  Created by Losd wind on 2021/11/2.
//

import SwiftUI
import Kingfisher

struct MessageView: View {
    
    
    let message: Message
    

        
    var body: some View {
        HStack {
            if message.userID == AuthViewModel.shared.userID {
                Spacer()
                Text(message.content)
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
                    
                    KFImage(URL(string:message.userProfileImageURL))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                    
                    Text(message.content)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .font(.body)
                        .clipShape(ChatBubble(isFromCurrentUser: false))
                        .foregroundColor(.accentColor)
                    
                }
                .padding(.horizontal)
                .padding(.trailing, 100)
                .padding(.leading, 16)
                Spacer()
            }
            
        }
    }
}
