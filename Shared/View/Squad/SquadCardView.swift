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
    
    
    @State var members: [User] = []
    
    @State var owner: User = User()
    
    
    var body: some View {
        VStack(alignment:.leading){
            
            
            
            HStack{
                KFImage(URL(string: owner.profileImageURL ?? "") )
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 40, height: 40)
                    .background(Circle()
                                    .stroke(.black,lineWidth: 1))
                
                
                ForEach(members,id: \.self){member in
                    
                    KFImage(URL(string: member.profileImageURL ?? "") )
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 30, height: 30)
                        .background(Circle()
                                        .stroke(.black,lineWidth: 1))
                
            }
                
            }
            
            HStack(alignment:.center, spacing: 80){
                Text("Unread \(12)")
                    .font(.footnote.bold())
                
                TimestampView(time: "20 mins")
                    .font(.footnote)
                
                
                
            }
            
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
        .onAppear {
            if Array(branch.memberIDs.keys).isEmpty == false {
            squadvm.fetchProfiles(ids: Array(branch.memberIDs.keys)) { users in
                if let members = users {
                    self.members = members
                }
            }
            }
            
            
            squadvm.fetchProfiles(ids: Array(arrayLiteral: branch.ownerID)) { users in
                if let owner = users?.first {
                    self.owner = owner
                }
            }
        }
        
    }
}

struct SquadCardView_Previews: PreviewProvider {
    
    @State static var branch:Branch = Branch(id: "", serverTimestamp: Timestamp(date:Date()), localTimestamp: Timestamp(date:Date()), ownerID: "", linkedItems: [], title: "This is a test for what", timeSlot: "Everyday 5~6PM", description: "In this branch we gonna test its permission issue and allow some other things. NOW STREAMING: Mark Zuckerberg and Facebook executives share their vision for the metaverse—the next…", memberIDs: [:], subIDs: [], openess: "Private")
    
    static var previews: some View {
        SquadCardView(branch: branch, squadvm: SquadViewModel())
    }
}
