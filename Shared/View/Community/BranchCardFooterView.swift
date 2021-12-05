//
//  OpenBranchBottomView.swift.swift
//  Beliski
//
//  Created by Losd wind on 2021/11/4.
//

import SwiftUI

struct BranchCardFooterView: View {
    
    
    let branch:Branch
    
    @State var status:Dictionary<String, Bool> = [:]
    
    @ObservedObject var communityvm:CommunityViewModel
    
    @State var isShowingCommentView = false
    @State var isShowingJoinButton:Bool = false
    @State var isShowingJoinView: Bool = false
    
    
    
    var body: some View {
        
        HStack(alignment: .center){
            
            
            // MARK: upvote
            HStack{
            Button {
                communityvm.currentBranch = branch
                
                // iterate between 0 1
                if status["isLiked"]! {
                    communityvm.deleteLike()
                    self.status = communityvm.getStatus(branch: branch)
                } else {
                    communityvm.sendLike{ success in
                        if success {
                            communityvm.inputLike = Like()
                            self.status = self.communityvm.getStatus(branch: branch)
                    }
                        
                        
                    }
                }
               
                 }label: {
                    if status["isLiked"]! {
                        Image(systemName: "hand.thumbsup.fill")
                            .foregroundColor(.pink)
                    } else {
                        Image(systemName: "hand.thumbsup")
                            .foregroundColor(.secondary)
                    }
                    
            }
                            
            Text(String(branch.likes))
            }
            
            
            // MARK: downvote
            HStack{
            Button {
                communityvm.currentBranch = branch
                if status["isDisliked"]!{
                    communityvm.deleteDislike()
                    self.status = communityvm.getStatus(branch: branch)
                }
                communityvm.sendDislike{ success in
                    if success {
                        communityvm.inputDislike = Dislike()
                        self.status = communityvm.getStatus(branch: branch)
                }
                    
                    
                } }label: {
                    if status["isDisliked"]!{
                        Image(systemName: "hand.thumbsdown.fill")
                            .foregroundColor(.pink)
                    } else {
                        Image(systemName: "hand.thumbsdown")
                            .foregroundColor(.secondary)
                    }
                    
            }
        
            Text(String(branch.dislikes))
            
            }
            

            
            
            
            // MARK: Comment
            HStack{
            Button {
                isShowingCommentView.toggle()
                communityvm.currentBranch = branch
                communityvm.getComments(branch: communityvm.currentBranch){
                    success in
                    if success {
                        print("successfully get the comments")
                    } else {
                        print("failed to get the comments")
                    }
                }
            } label: {
                
                if isShowingCommentView{
                    Image(systemName: "bubble.right.fill")
                        .foregroundColor(.pink)
                } else {
                    Image(systemName: "bubble.right")
                        .foregroundColor(.secondary)
                }
                
            }
                Text(String(branch.comments))
            
            }

            
            // star
//
//            HStack{
//                StarsView(rating: branch.rating)
//                Text(String(branch.rating))
//            }

            
            
            
            // MARK: Sub
            
            Button {

                communityvm.currentBranch = branch
                if status["isSubed"]! {
                    communityvm.deleteSub()
                    self.status = communityvm.getStatus(branch: branch)
                } else {
                    communityvm.sendSub{ success in
                        if success {
                            communityvm.inputSub = Sub()
                            self.status = communityvm.getStatus(branch: branch)
                    }
                        
                    }
                }
                 }label: {
                    if status["isSubed"]!{
                        Text("Subed!")
                            .foregroundColor(.pink)
                    } else {
                        Text("Sub")
                    }
                    
                    
            }
                .modifier(PinkTintButtonStyle())
            
            
            // join
            if branch.memberIDs.count < 5 {
                Button {
                    isShowingJoinView.toggle()
                } label: {
                    
                    Text("Join")
                }
                .modifier(PinkTintButtonStyle())
                .alert(Text("Sorry"), isPresented: $isShowingJoinView
                        ) {
                            Button("OK") {
                                isShowingCommentView.toggle()
                                communityvm.currentBranch = branch
                                communityvm.getComments(branch: communityvm.currentBranch){
                                    success in
                                    if success {
                                        print("successfully get the comments")
                                    } else {
                                        print("failed to get the comments")
                                    }
                                }
                            }
                        } message: {
                            Text("This function is not available now. if you want to join this branch, leave your comment with the acount email address on the following page")
                        }
                
            }
            
            
            
            
            
            
            

            
        }
        .font(.footnote)
        
        .onAppear(perform: {
            self.status =  communityvm.getStatus(branch: branch)
        })
        
        .sheet(isPresented: $isShowingCommentView){
            CommentsView(communityvm: communityvm)
        }
    }
        
}

struct OpenBranchBottomView_Previews: PreviewProvider {
    static var previews: some View {
        BranchCardFooterView(branch: Branch(), communityvm: CommunityViewModel())
    }
}
