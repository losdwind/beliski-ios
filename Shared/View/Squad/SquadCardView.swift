//
//  SquadCardView.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/31.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift
import Kingfisher

struct SquadCardView: View {
    var branch:Branch
    @ObservedObject var squadvm:SquadViewModel
    
    
    var body: some View {
        VStack(alignment:.leading){
            
            
            
            HStack{
                
                ForEach(branch.memberIDsAvatar,id: \.self){avatar in
                    
                    KFImage(URL(string: avatar ))
                        .resizable()
                        .placeholder({ progress in
                            ProgressView(progress)
                        })
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 60, height: 60)
                        .cornerRadius(30)
                    
                
            }
                
            }
            .frame(maxWidth:.infinity)
            
            HStack(alignment:.center, spacing: 80){
                Text("Unread \(12)")
                    .font(.footnote.bold())
                
                TimestampView(time: "20 mins")
                    .font(.footnote)
                
                
                
            }
            
        }
        .modifier(BranchCardGradientBackground())
        
    }
}

struct SquadCardView_Previews: PreviewProvider {
    
    @State static var branch:Branch = Branch(id: "", serverTimestamp: Timestamp(date:Date()), localTimestamp: Timestamp(date:Date()), ownerID: "", linkedItems: [], title: "This is a test for what", timeSlot: "Everyday 5~6PM", description: "In this branch we gonna test its permission issue and allow some other things. NOW STREAMING: Mark Zuckerberg and Facebook executives share their vision for the metaverse—the next…", openess: "Private")
    
    static var previews: some View {
        SquadCardView(branch: branch, squadvm: SquadViewModel())
    }
}
