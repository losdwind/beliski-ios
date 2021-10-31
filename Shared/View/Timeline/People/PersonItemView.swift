//
//  PersonItemView.swift
//  Beliski
//
//  Created by Wind Losd on 2021/5/25.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct PersonItemView: View {
    
    var person: Person
    @StateObject var personTagvm:TagViewModel
    var isShowingPhtos:Bool = true
    var isShowingDescription:Bool = true
    var isShowingTags:Bool = true
    
    
    init(person: Person, tagNames: [String], OwnerItemID: String){
        self.person = person
        
        _personTagvm = StateObject(wrappedValue: TagViewModel(tagNamesOfItem: tagNames, ownerItemID: OwnerItemID, completion: { success in
            if success {
                print("successfully initilized the TagCollectionView with given tagIDs and OwnerItemId")
            } else {
                print("failed to initilized the TagCollectionView with given tagIDs and OwnerItemId")
            }
        })
        )
        
    }
    
    func timeConverter(timestamp: Timestamp?) -> String {
        if timestamp != nil {
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.day, .month, .year]
            formatter.maximumUnitCount = 3
            formatter.unitsStyle = .brief
            return formatter.string(from: timestamp!.dateValue(), to: Date()) ?? "Timestamp cannot be converted"
        } else {
            return "Timestamp is nil"
        }
    }
    
    var body: some View {
        // Profile Image
        
        
        
        VStack(alignment: .leading, spacing: 20){
            
            HStack(alignment: .center, spacing: 20){
                
                if person.avatarURL == "" {
                    Image(systemName:"person.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 80, maxHeight: 80, alignment: .leading)
                } else{
                    
                    AsyncImage(url: URL(string:person.avatarURL)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: 80, maxHeight: 80, alignment: .leading)
                            .clipShape(Circle())
                    } placeholder: {
                        Image(systemName:"person.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 80, maxHeight: 80, alignment: .leading)
                    }
                }
                
                
                VStack(alignment: .leading, spacing: 10){
                    Text("\(person.firstName) \(person.lastName)")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text("\(timeConverter(timestamp: person.birthday))")
                        .font(.footnote)
                    
                    Text(person.contact)
                        .font(.footnote)
                    
                }
                Spacer()
            }
            
            if isShowingDescription {
                Text(person.description)
                    .font(.body)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.primary)
            }
            
            
            
            // photos
            if isShowingPhtos {
                if person.photoURLs.isEmpty == false{
                    ImageGridView(imageURLs: person.photoURLs)
                }
            }
            
            
            if isShowingTags{
                TagCollectionView(tagvm: personTagvm)
            }
            
            
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(18)
    }
}

struct PersonItemView_Previews: PreviewProvider {
    static var previews: some View {
        PersonItemView(person: Person(id: "", serverTimestamp: Timestamp(date: Date()), localTimestamp: Timestamp(date: Date()), ownerID: "", linkedItems: [], address: [:], birthday: Timestamp(date: Date()) , contact: "1898723918", description: "A great man with warm heart and respect to others, good at making fun art and do not like playing cards", wordCount: 21, firstName: "Adam", lastName: "Smith", avatarURL: "gs://beliski.appspot.com/person_medias/17CE632F-5946-4866-A391-6FE0420BA67C", photoURLs: [], audioURLs: [], videoURLs: [], priority: 1, tagNames: ["fun"]), tagNames: ["freat","Great"], OwnerItemID: "")
            .previewLayout(.sizeThatFits)
    }
}


