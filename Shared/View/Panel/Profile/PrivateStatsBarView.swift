//
//  PrivateStatsBarView.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/30.
//

import SwiftUI

struct PrivateStatsBarView: View {
    
    @ObservedObject var profilevm:ProfileViewModel
    
    var body: some View {
        // MARK: POSTS
        HStack(alignment: .center) {
            
            // MARK: - No.journals
            VStack(alignment: .center, spacing: 5, content: {
                Text("131")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Capsule()
                    .fill(Color.gray)
                    .frame(width: 20, height: 2, alignment: .center)
                
                Text("Journals")
                    .font(.callout)
                    .fontWeight(.medium)
            })
            
            
            // MARK: - No. Completion/ Tasks
            VStack(alignment: .center, spacing: 5, content: {
                Text("15/20")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Capsule()
                    .fill(Color.gray)
                    .frame(width: 20, height: 2, alignment: .center)
                
                Text("Tasks")
                    .font(.callout)
                    .fontWeight(.medium)
            })
            
            // MARK: - No. Persons
            VStack(alignment: .center, spacing: 5, content: {
                Text("14")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Capsule()
                    .fill(Color.gray)
                    .frame(width: 20, height: 2, alignment: .center)
                
                Text("Persons")
                    .font(.callout)
                    .fontWeight(.medium)
            })
        }
    }
}

struct PrivateStatsBarView_Previews: PreviewProvider {
    static var previews: some View {
        PrivateStatsBarView(profilevm: ProfileViewModel())
    }
}
