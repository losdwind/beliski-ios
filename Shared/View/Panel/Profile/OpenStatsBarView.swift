//
//  StatsBarView.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/29.
//

import SwiftUI


struct OpenStatsBarView: View {
    @ObservedObject var profilevm:ProfileViewModel

    var body: some View {
        HStack(alignment: .center){
            
            // MARK: POSTS
            VStack(alignment: .center, spacing: 5, content: {
                Text("13")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Capsule()
                    .fill(Color.gray)
                    .frame(width: 20, height: 2, alignment: .center)
                
                Text("Posts")
                    .font(.callout)
                    .fontWeight(.medium)
            })
            
            // MARK: LIKES
            VStack(alignment: .center, spacing: 5, content: {
                Text("213")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Capsule()
                    .fill(Color.gray)
                    .frame(width: 20, height: 2, alignment: .center)
                
                Text("Likes")
                    .font(.callout)
                    .fontWeight(.medium)
            })
            
            // MARK: Subs
            VStack(alignment: .center, spacing: 5, content: {
                Text("7")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Capsule()
                    .fill(Color.gray)
                    .frame(width: 20, height: 2, alignment: .center)
                
                Text("Subs")
                    .font(.callout)
                    .fontWeight(.medium)
            })
            
        }
    }
}

struct StatsBarView_Previews: PreviewProvider {
    static var previews: some View {
        OpenStatsBarView(profilevm: ProfileViewModel())
    }
}
