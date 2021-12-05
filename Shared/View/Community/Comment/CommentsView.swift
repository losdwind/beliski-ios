//
//  CommentView.swift
//  Beliski (iOS)
//
//  Created by Losd wind on 2021/11/2.
//

import SwiftUI

struct CommentsView: View {
    
    @ObservedObject var communityvm:CommunityViewModel
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 24) {
                    ForEach(communityvm.fetchedCurrentBranchComments) { comment in
                        CommentCellView(comment: comment)
                    }

                }
            }.padding(.top)
            
            InputCommentView(communityvm: communityvm)
            
        }
        .padding()
    }
}

struct CommentsView_Previews: PreviewProvider {
    static var previews: some View {
        CommentsView(communityvm: CommunityViewModel())
    }
}
