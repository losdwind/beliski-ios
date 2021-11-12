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

    
        
  
    
    var body: some View {
            
                VStack{
                    
                    
                    ForEach(communityvm.fetchedPublicBranches, id: \.self) { branch in
  
                        OpenBranchCardView(branch: branch,communityvm: communityvm, dataLinkedManager: dataLinkedManager)
                        
                        
                    }
                    
                    
                }
                
            
                .frame(maxWidth: 640)
        
        
    }
}

struct BranchCardPublicListView_Previews: PreviewProvider {
    static var previews: some View {
        PopularBranchView(communityvm: CommunityViewModel(), dataLinkedManager: DataLinkedManager())
    }
}
