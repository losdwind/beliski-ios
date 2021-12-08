//
//  OpenBranchBottomView.swift.swift
//  Beliski
//
//  Created by Losd wind on 2021/11/4.
//

import SwiftUI

struct BranchCardFooterView: View {
    
    
    @State var branch:Branch
    
    @State var status:Dictionary<String, Bool> = ["isLiked":false, "isDisliked":false, "isSubed":false]
    
    @ObservedObject var communityvm:CommunityViewModel
    
    @State var isShowingCommentView = false
    @State var isShowingJoinButton:Bool = false
    @State var isShowingJoinView: Bool = false
    
    init(branch:Branch, communityvm:CommunityViewModel){
        self.branch = branch
        self.communityvm = communityvm
        self.status = communityvm.getStatus(branch: self.branch)
    }
    var body: some View {
        
        HStack(alignment:.center){
            
            
            // MARK: upvote
            Button {
                communityvm.sendAction(branch: branch, type:"likes"){result in
                    switch result {
                    case "added":
                        status["isliked"] = true
                        branch.likes = branch.likes + 1
                    case "cancelled":
                        status["isliked"] = false
                        branch.likes = branch.likes - 1
                    case nil: break
                    
                    case .some(_):
                        break
                    }
                }
                
            }label: {
                if status["isLiked"] == true {
                    HStack{
                        Image(systemName: "hand.thumbsup.fill")
                            .foregroundColor(.pink)
                        Text(String(branch.likes))
                    }
                } else {
                    HStack{
                        Image(systemName: "hand.thumbsup")
                            .foregroundColor(.secondary)
                        Text(String(branch.likes))
                    }
                }
                
                
            }
            
            
            
            
            // MARK: downvote
            HStack{
                Button {
                    communityvm.sendAction(branch: branch, type:"dislikes"){result in
                        switch result {
                        case "added":
                            status["isDisliked"] = true
                            branch.dislikes = branch.dislikes + 1
                        case "cancelled":
                            status["isDisliked"] = false
                            branch.dislikes = branch.dislikes - 1
                        case nil: break
                            
                        case .some(_):
                            break;
                        }
                    }
                    
                }label: {
                    if status["isDisliked"] == true {
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
            .sheet(isPresented: $isShowingCommentView){
                CommentsView(communityvm: communityvm)
            }
            
            
            // MARK: Sub
            
            Button {
                communityvm.sendAction(branch: branch, type:"subs"){result in
                    switch result {
                    case "added":
                        status["isSubed"] = true
                        branch.subs = branch.subs + 1
                    case "cancelled":
                        status["isSubed"] = false
                        branch.subs = branch.subs - 1
                    case nil: break
                    case .some(_):
                        break
                    }
                }
            }label: {
                if status["isSubed"] == true {
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
        .onChange(of: communityvm.fetchedUserGivenSubsList) { newValue in
            self.status = communityvm.getStatus(branch: branch)
        }
        
        
        
    }
    
}

struct OpenBranchBottomView_Previews: PreviewProvider {
    static var previews: some View {
        BranchCardFooterView(branch: Branch(), communityvm: CommunityViewModel())
    }
}

