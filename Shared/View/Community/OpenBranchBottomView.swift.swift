//
//  OpenBranchBottomView.swift.swift
//  Beliski
//
//  Created by Losd wind on 2021/11/4.
//

import SwiftUI

struct OpenBranchBottomView: View {
    
    
    let branch:Branch
    
    @ObservedObject var communityvm:CommunityViewModel
    
    @State var isShowingCommentView = false
    @State var isLiked = false
    @State var isDisliked = false


    var body: some View {
        HStack(alignment: .center, spacing: 20){
            Button {
                isLiked.toggle()
                communityvm.currentBranch = branch
                
                // iterate between 0 1
                communityvm.inputLike.like = isLiked ? 1 : 0
                communityvm.sendLike(){ success in
                    if success {
                        communityvm.inputLike = Like()
                }
                    
                    
                } }label: {
                    if isLiked{
                        Image(systemName: "hand.thumbsup.fill")
                            .foregroundColor(.pink)
                    } else {
                        Image(systemName: "hand.thumbsup")
                            .foregroundColor(.secondary)
                    }
                    
            }
            
            Text(String(communityvm.fetchedLikes.count))
                
            Button {
                isDisliked.toggle()
                communityvm.currentBranch = branch
                
                // iterate between -1, 0
                communityvm.inputDislike.like = isDisliked ? -1 : 0
                communityvm.sendLike(){ success in
                    if success {
                        communityvm.inputDislike = Like()
                }
                    
                    
                } }label: {
                    if isDisliked{
                        Image(systemName: "hand.thumbsdown.fill")
                            .foregroundColor(.pink)
                    } else {
                        Image(systemName: "hand.thumbsdown")
                            .foregroundColor(.secondary)
                    }
                    
            }
            
            Text(String(communityvm.fetchedDislikes.count))
            
            
            
            Button {
                isShowingCommentView.toggle()
                communityvm.currentBranch = branch
            } label: {
                
                if isShowingCommentView{
                    Image(systemName: "buble.right.fill")
                        .foregroundColor(.pink)
                } else {
                    Image(systemName: "bubble.righ")
                        .foregroundColor(.secondary)
                }
                
            }
            
            Text(String(communityvm.fetchedComments.count))
            
            Spacer()
        }
        .sheet(isPresented: $isShowingCommentView){
            CommentsView(communityvm: communityvm)
        }
        .onAppear{
            communityvm.currentBranch = branch
            communityvm.getlikes(branch: branch, completion: {_ in})
            communityvm.getDislikes(branch: branch, completion: {_ in})
            communityvm.getComments(branch: branch, completion: {_ in})

        }
    }
        
}

struct OpenBranchBottomView_Previews: PreviewProvider {
    static var previews: some View {
        OpenBranchBottomView(branch: Branch(), communityvm: CommunityViewModel())
    }
}
