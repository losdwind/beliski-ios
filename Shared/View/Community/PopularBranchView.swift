//
//  BranchCardPublicListView.swift
//  Beliski
//
//  Created by Losd wind on 2021/11/3.
//

import SwiftUI

struct PopularBranchView: View {
    
    @AppStorage(CurrentUserDefaults.userID) var userID:String?
    @ObservedObject var communityvm:CommunityViewModel
    @ObservedObject var dataLinkedManager:DataLinkedManager

    
    
    @State var isShowingLinkedItemView = false
    
  
    
    var body: some View {
        NavigationView{
            
            ScrollView(.vertical, showsIndicators: false){
                
                LazyVStack{
                    ForEach(communityvm.fetchedPublicBranches, id: \.self) { branch in
  
                        VStack(alignment:.leading){
                            
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

                            
                            BranchCardFooterView(branch: branch, communityvm: communityvm)
                                
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
        PopularBranchView(communityvm: CommunityViewModel(), dataLinkedManager: DataLinkedManager())
    }
}
