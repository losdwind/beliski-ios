//
//  LikesView.swift
//  Beliski
//
//  Created by Losd wind on 2021/11/2.
//

import SwiftUI

struct LikesView: View {
    @ObservedObject var communityvm:CommunityViewModel
    @ObservedObject var profilevm:ProfileViewModel
    
    var body: some View {
        List(communityvm.fetchedLikes){ like in
            
            
            
        }
    }
}

struct LikesView_Previews: PreviewProvider {
    static var previews: some View {
        LikesView(communityvm: CommunityViewModel(), profilevm: ProfileViewModel())
    }
}
