//
//  JournalView.swift
//  Beliski-Firebase
//
//  Created by Wind Losd on 2021/9/17.
//

import SwiftUI

struct JournalListView: View {
    
    @ObservedObject var journalvm:JournalViewModel
    @EnvironmentObject var dataLinkedManager:DataLinkedManager
    
    @State var isUpdatingJournal = false
    @State var isLinkingItem = false
    
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false){
            LazyVStack{
                ForEach(journalvm.fetchedJournals, id:\.id){ journal in
                    
                    NavigationLink(destination: LinkedItemsView(dataLinkedManager: dataLinkedManager)){
                        JournalItemView(journal: journal)
                            .contextMenu(menuItems:{
                                
                                // Delete
                                Button(action:{
                                    journalvm.deleteJournal(journal: journal){_ in}
                                    
                                }
                                       ,label:{Label(
                                        title: { Text("Delete") },
                                        icon: { Image(systemName: "trash.circle") })})
                                
                                
                                // Edit
                                Button(action:{
                                    journalvm.journal = journal
                                    isUpdatingJournal = true
                                    
                                }
                                       ,label:{Label(
                                        title: { Text("Edit") },
                                        icon: { Image(systemName: "pencil.circle") })})
                                
                                
                                // Link
                                Button(action:{
                                    journalvm.journal = journal
                                    isLinkingItem = true
                                    
                                }
                                       ,label:{Label(
                                        title: { Text("Edit") },
                                        icon: { Image(systemName: "pencil.circle") })})
                                
                                
                            })
                            .onTapGesture(perform: {
                                dataLinkedManager.linkedIds = journal.linkedItems
                            })
                            .sheet(isPresented: $isUpdatingJournal, onDismiss: {
                                journalvm.journal = Journal()
                            }, content: {
                                JournalEditorView(journalvm: journalvm)
                            })
                        
                    }
                    .padding()
                    .frame(maxWidth: 640)
                    .background(Color.gray)
                    .cornerRadius(10)
                    
                    
                }
            }
            
            
        }
        .onAppear {
            journalvm.fetchJournals { _ in }
        }
    }
    
}

struct JournalView_Previews: PreviewProvider {
    static var previews: some View {
        JournalListView(journalvm: JournalViewModel())
    }
}
