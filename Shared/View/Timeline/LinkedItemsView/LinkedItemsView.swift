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
        
        ScrollView(.vertical, showsIndicators: false){
                GroupBox {
                    LazyVStack{
                        ForEach(dataLinkedManager.linkedJournals){
                            journal in
                            JournalItemView(journal: journal, tagIDs: journal.tagIDs, OwnerItemID: journal.id!)
                        }
                    }
                } label: {
                    Text("Journals")
                        .font(.title)
                }
                .groupBoxStyle(.automatic)
                
            
            GroupBox {
                LazyVStack{
                    ForEach(dataLinkedManager.linkedTasks){
                        task in
                        TaskRowItemView(task: task)
                    }
                }
            } label: {
                Text("Tasks")
                    .font(.title)
            }
            .groupBoxStyle(.automatic)
            
            GroupBox {
                LazyVStack{
                    ForEach(dataLinkedManager.linkedPersons){
                        person in
                        PersonItemView(person: person, tagIDs: person.tagIDs, OwnerItemID: person.id!)
                    }
                }
            } label: {
                Text("Persons")
                    .font(.title)
            }
            .groupBoxStyle(.automatic)
            

        }
        .onAppear {
            dataLinkedManager.fetchItems(completion: {success in
                if success {
                    print("successfully loaded the linked items on appear")
                } else {
                    print("failed to load the linked items on appear")
                }
            })
        }
        

   
    }
}

struct LinkedItemsView_Previews: PreviewProvider {
    static var previews: some View {
        LinkedItemsView(dataLinkedManager: DataLinkedManager())
    }
}
