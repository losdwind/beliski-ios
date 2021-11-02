//
//  CommentView.swift
//  Beliski (iOS)
//
//  Created by Losd wind on 2021/11/2.
//

import SwiftUI

struct CommentsView: View {
    
    @ObservedObject var communityvm:CommunityViewModel
    @State var commentText = ""
    init(post: Post) {
        self.viewModel = CommentViewModel(post: post)
    }
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 24) {
                    ForEach(communityvm.fetchedComments) { comment in
                        CommentCellView(comment: comment)
                    }
                }
            }.padding(.top)
            
            CustomInputView(inputText: $commentText, placeholder: "Comment...", action: uploadComment)
        }
    }
    
    func uploadComment() {
        viewModel.uploadComment(commentText: commentText)
        commentText = ""
    }
}

struct CommentsView_Previews: PreviewProvider {
    static var previews: some View {
        CommentsView()
    }
}
