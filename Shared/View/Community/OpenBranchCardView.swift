//
//  OpenBranchCardView.swift
//  Beliski
//
//  Created by Losd wind on 2021/11/12.
//

import SwiftUI

struct OpenBranchCardView: View {
    
    let branch:Branch
    @ObservedObject var communityvm:CommunityViewModel
    @ObservedObject var dataLinkedManager:DataLinkedManager
    
    @State var isShowingLinkedItemView = false
    @AppStorage(CurrentUserDefaults.userID) var userID:String?
    
    
    
    var body: some View {
        
        ZStack(alignment: .bottomTrailing) {
            
            
            VStack(alignment:.leading) {
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
                    .font(.caption)
                
                
            }
            

               
                
                
            
        }
        .modifier(BranchCardGradientBackground())
        
    }
}

struct OpenBranchCardView_Previews: PreviewProvider {
    static var previews: some View {
        OpenBranchCardView(branch: Branch(title:"Let us go study", timeSlot: "Everyday 9:00am~18:00pm", description: ""), communityvm: CommunityViewModel(), dataLinkedManager: DataLinkedManager())
    }
}
