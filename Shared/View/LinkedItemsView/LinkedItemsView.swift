//
//  JournalLinkedView.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/15.
//

import SwiftUI

struct LinkedItemsView: View {
    
    @EnvironmentObject var dataLinkedManager: DataLinkedManager
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false){
                GroupBox {
                    LazyVStack{
                        ForEach(dataManager.linkedJournals){
                            journal in
                            JournalItemView(journal: journal)
                        }
                    }
                } label: {
                    Text("Journals")
                        .font(.title)
                }
                .groupBoxStyle(.automatic)
                
            
            GroupBox {
                LazyVStack{
                    ForEach(dataManager.linkedTasks){
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
                    ForEach(dataManager.linkedPersons){
                        person in
                        PersonItemView(person: person)
                    }
                }
            } label: {
                Text("Persons")
                    .font(.title)
            }
            .groupBoxStyle(.automatic)
            

        }
        .onAppear {
            dataLinkedManager.fetchItems(completion: {_ in })
        }
   
    }
}

struct LinkedItemsView_Previews: PreviewProvider {
    static var previews: some View {
        LinkedItemsView()
    }
}
