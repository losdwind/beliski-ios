//
//  PersonListView.swift
//  Beliski
//
//  Created by Wind Losd on 2021/5/25.
//

import SwiftUI

struct PersonListView: View {
    @ObservedObject var personvm: PersonViewModel
    @ObservedObject var dataLinkedManager: DataLinkedManager
    @ObservedObject var searchvm:SearchViewModel
    
    @State var isUpdatingPerson: Bool = false
    @State var isLinkingItem: Bool = false
    @State var isShowingPersonDetail: Bool = false
    @State var isShowingLinkView:Bool = false

    
    var body: some View {
            ScrollView(.vertical, showsIndicators: true){
                LazyVStack{
                    ForEach(personvm.fetchedPersons){ person in
                       
                        NavigationLink {
                            LinkedItemsView(dataLinkedManager: dataLinkedManager)
                        } label: {
                            PersonItemView(person: person, tagIDs: person.tagIDs, OwnerItemID: person.id!)
                                .contextMenu{
                                    
                                    
                                    Button {
                                        isShowingPersonDetail.toggle()
                                    } label: {
                                        Label(
                                         title: { Text("Detail") },
                                         icon: { Image(systemName: "trash.circle") })
                                    }

                                    // Delete
                                    Button(action:{
                                        personvm.deletePerson(person: person){_ in}
                                        
                                    }
                                           ,label:{Label(
                                            title: { Text("Delete") },
                                            icon: { Image(systemName: "trash.circle") })})
                                    
                                    
                                    // Edit
                                    Button(action:{
                                        personvm.person = person
                                        isUpdatingPerson = true
                                        
                                    }
                                           ,label:{Label(
                                            title: { Text("Edit") },
                                            icon: { Image(systemName: "pencil.circle") })})
                                    
                                    
                                    // Link
                                    Button(action:{
                                        personvm.person = person
                                        isLinkingItem = true
                                        isShowingLinkView = true
                                        
                                        
                                    }
                                           ,label:{Label(
                                            title: { Text("Link") },
                                            icon: { Image(systemName: "link.circle") })})
                                    
                                }
                                .sheet(isPresented: $isShowingPersonDetail){
                                    PersonDetailView(person: person)
                                }
                                .sheet(isPresented: $isShowingLinkView){
                                    SearchView(searchvm: searchvm)
                                }
                                .onTapGesture(perform: {
                                    dataLinkedManager.linkedIds = person.linkedItems
                                    dataLinkedManager.fetchItems { success in
                                        if success {
                                            print("successfully loaded the linked Items from DataLinkedManager")

                                        } else {
                                            print("failed to loaded the linked Items from DataLinkedManager")
                                        }
                                    }
                                })
                        }
                        

                        
                    }
                }
            }
            .onAppear {
                personvm.fetchPersons{ success in
                    if success {
                        print("successfully loaded the persons from firebase")
                    } else {
                        print("failed to load the persons from firebase")
                    }
                }
            }
        
            
    }
}

struct PersonListView_Previews: PreviewProvider {
    static var previews: some View {
        PersonListView(personvm: PersonViewModel(), dataLinkedManager: DataLinkedManager(), searchvm: SearchViewModel())
    }
}
