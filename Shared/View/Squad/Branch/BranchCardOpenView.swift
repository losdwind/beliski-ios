//
//  BranchCardOpenView.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/31.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct BranchCardOpenView: View {
    var branch:Branch
    var body: some View {
        VStack {
            BranchCardView(branch: branch)
            
        
            // Footer
            
            
        }
    }
}

struct BranchCardOpenView_Previews: PreviewProvider {
    static var branch:Branch = Branch(id: "", serverTimestamp: Timestamp(date:Date()), localTimestamp: Timestamp(date:Date()), ownerID: "", linkedItems: [], title: "This is a test for what", timeSlot: "Everyday 5~6PM", description: "In this branch we gonna test its permission issue and allow some other things. NOW STREAMING: Mark Zuckerberg and Facebook executives share their vision for the metaverse—the next…", memberIDs: [:], subIDs: [], Openess: "Private")
    static var previews: some View {
        BranchCardOpenView(branch: branch)
    }
}
