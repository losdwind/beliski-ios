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
                    ForEach(communityvm.fetchedCommentsAndProfiles.keys) { comment in
                        CommentCellView(comment: comment, user: communityvm.fetchedCommentsAndProfiles[comment] ?? User())
                    }
                }
            }.padding(.top)
            
            InputCommentView(communityvm: communityvm)
            
        }
    }
}

struct CommentsView_Previews: PreviewProvider {
    static var previews: some View {
        CommentsView(communityvm: CommunityViewModel())
    }
}
