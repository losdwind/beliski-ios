//
//  BranchView.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/28.
//

import SwiftUI

import Firebase
import FirebaseFirestoreSwift

struct BranchCardView: View {
    var branch:Branch
    
    @State var isShowingJoinButton:Bool = false
    @State var isShowingJoinView: Bool = false
    
    var body: some View {
        
        VStack{
            
            HStack(alignment: .top){
                
                VStack(alignment: .leading,spacing: 12){
                    
                    //                    Text(meeting.timing.formatted(date: .numeric, time: .omitted))
                    
                    
                    Text(branch.title)
                        .font(.title2.bold())
                        .lineLimit(1)
                    
                    Text(branch.description)
                        .font(.footnote)
                    
                    Text(branch.timeSlot)
                        .font(.caption.bold())
                        .foregroundColor(Color.pink)
                    
                }
                .frame(maxWidth:.infinity)
                                
                if isShowingJoinButton {
                    Button {
                        isShowingJoinView.toggle()
                    } label: {
                        Text("Join")
                            .foregroundColor(.secondary)
                            .padding(.horizontal,10)
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.small)
                    .tint(.pink)
                    .shadow(radius: 1.2)
                }
                
                
            }
            
            HStack(alignment:.center){
                    HStack{
                        ForEach(1...3,id: \.self){index in
                            
                            Image("animoji\(index)")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20, height: 20)
                                .padding(4)
                                .background(.white,in: Circle())
                            // border...
                                .background(
                                    
                                    Circle()
                                        .stroke(.black,lineWidth: 1)
                                )
                        }

                }
                Spacer()
                
                
                
                VStack(alignment:.leading, spacing: 0){
                    Text("\(branch.subIDs.count) Subscribers")
                        .font(.caption)
                    HStack{
                        StarsView(rating: 4.3)
                            .frame(width:60)
                        Text("4.3")
                    }
                    

                }
                
            }
        }
        .padding()
        .background(getColor(opentype: OpenType(rawValue:branch.openess)!),in: RoundedRectangle(cornerRadius: 10))
    }
    
    
    func getColor(opentype: OpenType)->Color{
        
        switch opentype {
            
        case .Public:
            return Color.green
        case .Private:
            return Color.gray.opacity(0.2)
        case .OnInvite:
            return Color.pink
        }
    }
}


struct StarsView: View {
    var rating: CGFloat
    var maxRating: Int = 5
    
    var body: some View {
        let stars = HStack(spacing: 0) {
            ForEach(0..<maxRating) { _ in
                Image(systemName: "star.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
        
        stars.overlay(
            GeometryReader { g in
                let width = rating / CGFloat(maxRating) * g.size.width
                ZStack(alignment: .leading) {
                    Rectangle()
                        .frame(width: width)
                        .foregroundColor(.pink)
                }
            }
                .mask(stars)
        )
            .foregroundColor(.gray)
    }
}

struct BranchCardView_Previews: PreviewProvider {
    @State static var branch:Branch = Branch(id: "", serverTimestamp: Timestamp(date:Date()), localTimestamp: Timestamp(date:Date()), ownerID: "", linkedItems: [], title: "This is a test for what", timeSlot: "Everyday 5~6PM", description: "In this branch we gonna test its permission issue and allow some other things. NOW STREAMING: Mark Zuckerberg and Facebook executives share their vision for the metaverse—the next…", memberIDs: [:], subIDs: [], openess: "Private")
    static var previews: some View {
        BranchCardView(branch: branch)
            .previewLayout(.sizeThatFits)
    }
}
