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
        
        ScrollView(.horizontal, showsIndicators: false){
        // MARK: POSTS
        HStack(alignment: .center) {
            
            // MARK: - No.journals
            SingleEntryView(number: 131, text: "Journals")
            
            // MARK: - No. Completion/ Tasks
            SingleEntryView(number: 15/20, text: "Tasks")
            
            // MARK: - No. Persons
            SingleEntryView(number: 14, text: "Persons")
            
            // MARK: - No. Persons
            SingleEntryView(number: 14, text: "Persons")
        }
    }
    }
}

struct PrivateStatsBarView_Previews: PreviewProvider {
    static var previews: some View {
        PrivateStatsBarView(profilevm: ProfileViewModel())
    }
}
