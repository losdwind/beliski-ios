//
//  BranchCardPublicListView.swift
//  Beliski
//
//  Created by Losd wind on 2021/11/3.
//

import SwiftUI

struct BranchCardPublicListView: View {
    
    @ObservedObject var communityvm:CommunityViewModel
    @ObservedObject var dataLinkedManager:DataLinkedManager

    
    
    @State var isShowingLinkedItemView = false
    
    @State var isShowingCommentView = false
    
    @State var isShowingChatView = false
    
    @State var isLiked = false
    
    var body: some View {
        NavigationView{
            
            ScrollView(.vertical, showsIndicators: false){
                
                LazyVStack{
                    ForEach(communityvm.fetchedOpenBranches, id: \.self) { branch in
  
                        VStack{
                            BranchCardView(branch: branch)
                                .background{
                                    NavigationLink(destination: LinkedItemsView(dataLinkedManager: dataLinkedManager), isActive: $isShowingLinkedItemView) {
                                        EmptyView()
                                    }
                                    
                                } //: background
                            
                                .onTapGesture {
                                    isShowingLinkedItemView.toggle()
                                    dataLinkedManager.linkedIds = branch.linkedItems
                                    dataLinkedManager.fetchItems { success in
                                        if success {
                                            print("successfully loaded the linked Items from DataLinkedManager")
                                            
                                        } else {
                                            print("failed to loaded the linked Items from DataLinkedManager")
                                        }
                                    }
                                } //: onTapGesture
                            
                            
                            
                            HStack(alignment: .center, spacing: 40){
                                Button {
                                    communityvm.sendLike(like:Like(ownerID: "", likeorHate: 1), branch: branch) { success in
                                        if success {
                                            isLiked.toggle()
                                    }
                                    } }label: {
                                    
                                        Image(systemName: (isLiked ? "heart.fill" : "heart"))
                                         
                                    
                                    
                                }

                        
                                
                                
                                Button {
                                    isShowingCommentView.toggle()
                                } label: {
                                    
                                    
                                    Image(systemName: (isShowingCommentView ? "buble.right.fill" : "bubble.right"))
                                       
                                    
                                    
                                }
                                
                                Spacer()
                            }
                            
                                
                                
                                
                                
                        }
                        .sheet(isPresented: $isShowingCommentView){
                            CommentsView(branch: branch)
                        }
                            
                        
                        
                        
                        
                    }
                    
                    
                }
                
            }
                .padding()
                .frame(maxWidth: 640)
        }
        
    }
}

struct BranchCardPublicListView_Previews: PreviewProvider {
    static var previews: some View {
        BranchCardPublicListView(communityvm: CommunityViewModel(), dataLinkedManager: DataLinkedManager())
    }
}
