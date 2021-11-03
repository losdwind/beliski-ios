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
    let comment:Comment
    
    let user:User
    
    
    var body: some View {
        HStack {
            KFImage(URL(string: user.profileImageURL ?? ""))
                .resizable()
                .scaledToFill()
                .frame(width: 36, height: 36)
                .clipShape(Circle())
            
            Text(user.userName ?? "unknown").font(.system(size: 14, weight: .semibold)) +
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
        CommentCellView(comment: Comment(id: "", ownerID: "", serverTimestamp: Timestamp(date: Date()), content: "This is an awesome work"), user: User(profileImageURL: "https://www.google.com/webhp?hl=zh-TW&ictx=2&sa=X&ved=0ahUKEwjxoa-g2_zzAhWGwJQKHTNuBiYQPQgJ", userName:"Titan"))
    }
}
