//
//  JournalItemView.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/8.
//

import SwiftUI
import VideoPlayer
import Kingfisher
import FirebaseFirestoreSwift
import Firebase

struct JournalItemView: View {
    
    var journal:Journal
    
    @StateObject var journalTagvm:TagViewModel
    
    
    
    init(journal: Journal, tagIDs: [String], OwnerItemID: String){
        self.journal = journal
        
        self._journalTagvm = StateObject(wrappedValue: TagViewModel(tagIDs: tagIDs, ownerItemID: OwnerItemID, completion: { success in
            if success {
                print("successfully initilized the TagCollectionView with given tagIDs and OwnerItemId")
            } else {
                print("failed to initilized the TagCollectionView with given tagIDs and OwnerItemId")
            }
        })
        )
        
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            
            
            TextContentView(text: journal.content.isEmpty ? "You didn't put any words here" : journal.content )
                .font(.title3)
            
            if journal.imageURLs.isEmpty == false {
                if journal.imageURLs.count == 1 {
                    SingleImageView(imageURL: journal.imageURLs[0])
                } else {
                    ImageGridView(imageURLs: journal.imageURLs)
                }
            }
            
            if journal.videoURLs.isEmpty == false {
                LazyVStack{
                    ForEach(journal.videoURLs, id: \.self){
                        videoURL in
                        SingleVideoView(videoURL: videoURL)
                    }
                }
            }
            
            TimestampView(time:journal.convertFIRTimestamptoString(timestamp: journal.localTimestamp))
            
            
            TagCollectionView(tagvm:journalTagvm)
        }

        
    }
    
    
    
}

struct JournalItemView_Previews: PreviewProvider {
    static var previews: some View {
        JournalItemView(journal: Journal(localTimestamp: Timestamp(date: Date()), ownerID: "coco", linkedItems: [], content: "Visit objects contain as much information about the visit as possible but may not always include both the arrival and departure times. For example, when the user arrives at a location, the system may send an event with only an arrival time. When the user departs a location, the event can contain both the arrival time (if your app was monitoring visits prior to the user’s arrival) and the departure time.", imageURLs: ["https://www.google.com/imgres?imgurl=https%3A%2F%2Fwww.iata.org%2Fcontentassets%2Fd7c512eb9a704ba2a8056e3186a31921%2Fcargo_live_animals_parrot.jpg%3Fw%3D330%26h%3D200%26mode%3Dcrop%26scale%3Dboth%26v%3D20191213012337&imgrefurl=https%3A%2F%2Fwww.iata.org%2Fen%2Fprograms%2Fcargo%2Flive-animals%2F&tbnid=ilY26rApA1AOxM&vet=12ahUKEwjl_4nH073zAhUK95QKHVspA7EQMygBegUIARCtAQ..i&docid=3sOJ-W6KCtkyaM&w=330&h=200&q=animals&client=safari&ved=2ahUKEwjl_4nH073zAhUK95QKHVspA7EQMygBegUIARCtAQ", "https://www.google.com/imgres?imgurl=https%3A%2F%2Fmedia.wired.com%2Fphotos%2F593261cab8eb31692072f129%2Fmaster%2Fpass%2F85120553.jpg&imgrefurl=https%3A%2F%2Fwww.wired.com%2F2015%2F04%2Ffind-mesmerizing-creatures-web%2F&tbnid=MC58JkPjkBGe-M&vet=12ahUKEwjl_4nH073zAhUK95QKHVspA7EQMygCegUIARCvAQ..i&docid=IsrSCgSE5j0TeM&w=2500&h=1674&q=animals&client=safari&ved=2ahUKEwjl_4nH073zAhUK95QKHVspA7EQMygCegUIARCvAQ", "https://www.google.com/imgres?imgurl=https%3A%2F%2Fthumbor.forbes.com%2Fthumbor%2F711x533%2Fhttps%3A%2F%2Fspecials-images.forbesimg.com%2Fimageserve%2F5faad4255239c9448d6c7bcd%2FBest-Animal-Photos-Contest--Close-Up-Of-baby-monkey%2F960x0.jpg%3Ffit%3Dscale&imgrefurl=https%3A%2F%2Fwww.forbes.com%2Fsites%2Fceciliarodriguez%2F2020%2F11%2F12%2Fworld-best-photos-of-animals-20-winning-images-by-agora%2F&tbnid=H7mwn18vYLqRsM&vet=12ahUKEwjl_4nH073zAhUK95QKHVspA7EQMygTegUIARDUAQ..i&docid=aLQX8wLl3PugWM&w=711&h=533&q=animals&client=safari&ved=2ahUKEwjl_4nH073zAhUK95QKHVspA7EQMygTegUIARDUAQ", "https://www.google.com/imgres?imgurl=https%3A%2F%2Fi.natgeofe.com%2Fk%2Fc02b35d2-bfd7-4ed9-aad4-8e25627cd481%2Fkomodo-dragon-head-on_2x1.jpg&imgrefurl=https%3A%2F%2Fkids.nationalgeographic.com%2Fanimals%2Fmammals&tbnid=FfkJShUorg2mlM&vet=12ahUKEwjl_4nH073zAhUK95QKHVspA7EQMygZegUIARDmAQ..i&docid=tUMedksl1KU1tM&w=3072&h=1536&q=animals&client=safari&ved=2ahUKEwjl_4nH073zAhUK95QKHVspA7EQMygZegUIARDmAQ"], audioURLs: [], videoURLs: ["https://www.youtube.com/watch?v=GLPjP3hjhMM"]), tagIDs: [""],OwnerItemID: "")
    }
}

