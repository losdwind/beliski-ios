//
//  SubscribedBranchView.swift
//  Beliski
//
//  Created by Losd wind on 2021/11/8.
//

import SwiftUI

struct SubscribedBranchView: View {
    
    @ObservedObject var communityvm:CommunityViewModel
    @ObservedObject var dataLinkedManager:DataLinkedManager
    
    var body: some View {
        VStack{
            ForEach(communityvm.fetchedSubscribedBranches, id: \.self) { branch in
                
                NavigationLink{
                    LinkedItemsView(dataLinkedManager: dataLinkedManager)
                } label: {
                    BranchCardView(branch: branch)
                }
                .onTapGesture(perform: {
                    dataLinkedManager.linkedIds = branch.linkedItems
                    dataLinkedManager.fetchItems { success in
                        if success {
                            print("successfully loaded the linked Items from DataLinkedManager")
                            
                        } else {
                            print("failed to loaded the linked Items from DataLinkedManager")
                        }
                    }
                })
            }
            
        }
    }
}

struct SubscribedBranchView_Previews: PreviewProvider {
    static var previews: some View {
        SubscribedBranchView(communityvm: CommunityViewModel(), dataLinkedManager: DataLinkedManager())
    }
}
