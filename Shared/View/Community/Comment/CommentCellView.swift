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
        
    
    var body: some View {
        HStack(alignment:.top) {
            KFImage(URL(string: comment.userProfileImageURL))
                .resizable()
                .placeholder({
                    ProgressView()
                })
                .aspectRatio(contentMode: .fill)
                .frame(width: 40, height: 40)
                .cornerRadius(20)
            VStack(alignment:.leading, spacing:8){
                HStack {
                    Text(comment.nickName).font(.body.bold())
                    TimestampView(time: convertFIRTimestamptoString(timestamp: comment.serverTimestamp))
                        .foregroundColor(.gray)
                        .font(.body)
                }
                
                Text(comment.content).font(.body)

            }
            
            Spacer()
            
            
        }.padding()
    }
}

struct CommentCellView_Previews: PreviewProvider {
    static var previews: some View {
        CommentCellView(comment: Comment())
    }
}
