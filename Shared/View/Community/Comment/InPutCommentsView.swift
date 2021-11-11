//
//  InPutCommentsView.swift
//  Beliski
//
//  Created by Losd wind on 2021/11/2.
//

import SwiftUI

struct InputCommentView: View {
    
    @ObservedObject var communityvm:CommunityViewModel
    
    var body: some View {
        VStack {
            Rectangle()
                .foregroundColor(Color(.separator))
                .frame(width: UIScreen.main.bounds.width, height: 0.75)
                .padding(.bottom, 8)
            
            HStack {
                TextField("Post your comment", text: $communityvm.inputComment.content)
                    .textFieldStyle(PlainTextFieldStyle())
                    .font(.body)
                    .frame(minHeight: 30)
                
                Button{
                   
                    communityvm.sendComment { success in
                        if success {
                            communityvm.inputComment = Comment()
                            communityvm.getComments(branch: communityvm.currentBranch) {_ in}
                        }
                    }
                } label: {
                    Text("Send")
                        .bold()
                        .foregroundColor(.black)
                }

            }
            .padding(.bottom, 8)
            .padding(.horizontal)

        }
        
    }
}

struct InputCommentView_Previews: PreviewProvider {
    static var previews: some View {
        InputCommentView(communityvm: CommunityViewModel())
    }
}
