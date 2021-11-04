//
//  MessageView.swift
//  Beliski
//
//  Created by Losd wind on 2021/11/2.
//

import SwiftUI
import Kingfisher

struct MessageView: View {
    
    @AppStorage(CurrentUserDefaults.userID) var userID: String?
    
    let message: Message
    
    let user:User

        
    var body: some View {
        HStack {
            if message.userID == userID {
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
                    
                    KFImage(URL(string:user.profileImageURL ?? ""))
                        
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                    
                    Text(message.content)
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
