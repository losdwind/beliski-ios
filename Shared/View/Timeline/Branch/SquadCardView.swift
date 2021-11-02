//
//  SquadCardView.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/31.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct SquadCardView: View {
    var branch:Branch
    
    var body: some View {
        VStack(alignment:.leading){
                HStack{
                    
                    ForEach(1...5,id: \.self){index in
                        
                        Image("animoji\(index)")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                            .padding(4)
                            .background(.white,in: Circle())
                        // border...
                            .background(
                                
                                Circle()
                                    .stroke(.black,lineWidth: 1)
                            )
                    }

            }
            
            HStack(alignment:.center, spacing: 80){
                Text("Unread (122)")
                Text("14 Mins Ago")
                    .font(.caption)

                

            }
            
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
        
        
    }
}

struct SquadCardView_Previews: PreviewProvider {
    
    @State static var branch:Branch = Branch(id: "", serverTimestamp: Timestamp(date:Date()), localTimestamp: Timestamp(date:Date()), ownerID: "", linkedItems: [], title: "This is a test for what", timeSlot: "Everyday 5~6PM", description: "In this branch we gonna test its permission issue and allow some other things. NOW STREAMING: Mark Zuckerberg and Facebook executives share their vision for the metaverse—the next…", memberIDs: [:], subIDs: [], openess: "Private")
    
    static var previews: some View {
        SquadCardView(branch: branch)
    }
}
