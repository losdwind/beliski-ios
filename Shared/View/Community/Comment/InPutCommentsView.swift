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
            .padding()
            .border(Color.gray, width: 2)

        }
        .padding()
        
    }
}

struct InputCommentView_Previews: PreviewProvider {
    static var previews: some View {
        InputCommentView(communityvm: CommunityViewModel())
    }
}
