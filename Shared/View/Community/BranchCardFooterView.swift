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
                communityvm.inputLike.isLike.toggle()
                
                // iterate between 0 1
               
                communityvm.sendLike{ success in
                    if success {
                        communityvm.inputLike = Like()
                        self.communityvm.getStatus(branch: branch, completion: {_ in})
                }
                    
                    
                } }label: {
                    if status["isLike"] ?? false {
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
                communityvm.inputDislike.isDislike.toggle()
                communityvm.currentBranch = branch
                
                communityvm.sendDislike{ success in
                    if success {
                        communityvm.inputDislike = Dislike()
                        communityvm.getStatus(branch: branch, completion: {_ in})
                }
                    
                    
                } }label: {
                    if status["isDislike"] ?? false {
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
                communityvm.inputSub.isSubed.toggle()

                communityvm.currentBranch = branch
                
                communityvm.sendSub{ success in
                    if success {
                        communityvm.inputSub = Sub()
                        communityvm.getStatus(branch: branch, completion: {_ in})
                        communityvm.fetchPublicBranches(completion: {_ in})
                }
                    
                    
                } }label: {
                    if status["isSubed"] ?? false{
                        Text("Subed!")
                    } else {
                        Text("Sub")
                    }
                    
                    
            }
                .buttonStyle(.bordered)
                .controlSize(.small)
                .tint(.pink)
                .shadow(radius: 1.2)
            
            
            
            if branch.memberIDs.count < 5 {
                Button {
                    isShowingJoinView.toggle()
                } label: {
                    Text("Join")
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
                .tint(.pink)
                .shadow(radius: 1.2)
            }
            
            
            
            
            
            
            

            
        }
        .font(.footnote)
        
        .onAppear(perform: {
            communityvm.getStatus(branch: branch, completion: {status in
                if let status = status {
                    self.status = status
                }else {
                    print("failed to get the user subscribe status")
                }
            })
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
