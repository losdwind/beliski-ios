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
            formatter.unitsStyle = .abbreviated
            return formatter.string(from: timestamp!.dateValue(), to: Date()) ?? "Timestamp cannot be converted"
        } else {
            return "Timestamp is nil"
        }
    }
    
    var body: some View {
        // Profile Image
        
        
        
        VStack(alignment: .leading, spacing: 0){
            
            HStack(alignment: .center, spacing: 20){
                
                if person.avatarURL.isEmpty == true {
                    Image(systemName:"person.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 80, maxHeight: 80, alignment: .leading)
                } else{
                    
                    AsyncImage(url: URL(string:person.avatarURL)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 80, maxHeight: 80, alignment: .leading)
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
            }
            
            Text(person.description)
                .font(.footnote)
                .foregroundColor(.secondary)
            
            
            // photos
            if person.photoURLs.isEmpty == false{
                ImageGridView(imageURLs: person.photoURLs)
            }
            
            
            TagCollectionView(tagvm: personTagvm)
            
            
        }
    }
}

struct PersonItemView_Previews: PreviewProvider {
    static var previews: some View {
        PersonItemView(person: Person(), tagNames: [], OwnerItemID: "")
    }
}


