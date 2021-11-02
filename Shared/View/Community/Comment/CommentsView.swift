//
//  CommentView.swift
//  Beliski (iOS)
//
//  Created by Losd wind on 2021/11/2.
//

import SwiftUI

struct CommentsView: View {
    
    @ObservedObject var communityvm:CommunityViewModel
    
    
    init(branch:Branch) {
        communityvm.openBranch = branch
        communityvm.getComments(branch: branch) { _ in
        }
    }
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 24) {
                    ForEach(communityvm.fetchedComments, id:\.self) { comment in
                        CommentCellView(communityvm: communityvm, comment: comment)
                    }
                }
            }.padding(.top)
            
            InputCommentView(communityvm: communityvm)
            
        }
    }
}

struct CommentsView_Previews: PreviewProvider {
    static var previews: some View {
        CommentsView(branch: Branch())
    }
}
