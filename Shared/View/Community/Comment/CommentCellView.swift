//
//  CommentCellView.swift
//  Beliski (iOS)
//
//  Created by Losd wind on 2021/11/2.
//

import SwiftUI
import Kingfisher
import Firebase
import FirebaseFirestoreSwift

struct CommentCellView: View {
    let comment: Comment
    
    var user:User
    
    @ObservedObject var communityvm:CommunityViewModel
    
    init(communityvm:CommunityViewModel, comment: Comment) {
        self.communityvm = communityvm
        self.comment = comment
        communityvm.getProfile(comment: comment) { user in
            if let user = user {
                self.user = user
            }
        }
        
    }
    
    var body: some View {
        HStack {
            KFImage(URL(string: user.profileImageURL ?? ""))
                .resizable()
                .scaledToFill()
                .frame(width: 36, height: 36)
                .clipShape(Circle())
            
            Text(user.userName ?? "Anonymous").font(.system(size: 14, weight: .semibold)) +
            Text(" \(comment.content)").font(.system(size: 14))
            
            Spacer()
            
            TimestampView(time: convertFIRTimestamptoString(timestamp: comment.serverTimestamp))
                .foregroundColor(.gray)
                .font(.system(size: 12))
        }.padding(.horizontal)
    }
}

struct CommentCellView_Previews: PreviewProvider {
    static var previews: some View {
        CommentCellView(communityvm: CommunityViewModel(), comment: Comment(id: "", ownerID: "", serverTimestamp: Timestamp(date:Date()), content: "this is awesome and I cant wait to see next episode"))
    }
}
