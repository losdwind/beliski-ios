//
//  JournalLinkedView.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/15.
//

import SwiftUI

struct LinkedItemsView: View {
    
    @ObservedObject var dataLinkedManager: DataLinkedManager
    
    var body: some View {
        
        // TODO: - add a list without segemeting
        ScrollView(.vertical, showsIndicators: false){
                GroupBox {
                    LazyVStack{
                        ForEach(dataLinkedManager.linkedJournals){
                            journal in
                            JournalItemView(journal: journal, tagNames: journal.tagNames, OwnerItemID: journal.id)
                        }
                    }
                } label: {
                    Text("Journals")
                }
                
            
            GroupBox {
                LazyVStack{
                    ForEach(dataLinkedManager.linkedTasks){
                        task in
                        TaskRowItemView(task: task)
                    }
                }
            } label: {
                Text("Tasks")
            }
            
            
            GroupBox {
                LazyVStack{
                    ForEach(dataLinkedManager.linkedPersons){
                        person in
                        PersonItemView(person: person, tagNames: person.tagNames, OwnerItemID: person.id, isShowingPhtos: false, isShowingDescription: false, isShowingTags: true)
                    }
                }
            } label: {
                Text("Persons")
            }
            

        }
        .padding()
        .navigationTitle("Linked Items")

   
    }
}

struct LinkedItemsView_Previews: PreviewProvider {
    static var previews: some View {
        LinkedItemsView(dataLinkedManager: DataLinkedManager())
    }
}
