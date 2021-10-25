//
//  JournalView.swift
//  Beliski-Firebase
//
//  Created by Wind Losd on 2021/9/17.
//

import SwiftUI

struct JournalListView: View {
    
    @ObservedObject var journalvm:JournalViewModel
    @ObservedObject var dataLinkedManager:DataLinkedManager
    @ObservedObject var searchvm: SearchViewModel
    @ObservedObject var tagPanelvm:TagPanelViewModel

    @State var isUpdatingJournal = false
    @State var isShowingLinkView:Bool = false

    
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false){
            LazyVStack{
                ForEach(journalvm.fetchedJournals, id:\.id){ journal in
                    
                    NavigationLink(destination:
                                    LinkedItemsView(dataLinkedManager: dataLinkedManager)
                    )
                    {
                        JournalItemView(journal: journal, tagNames: journal.tagNames, OwnerItemID: journal.id)
                            .contextMenu{
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
                                    isShowingLinkView = true
                                    
                                }
                                       ,label:{Label(
                                        title: { Text("Link") },
                                        icon: { Image(systemName: "link.circle") })})
                                
                            }
                            .onTapGesture(perform: {
                                dataLinkedManager.linkedIds = journal.linkedItems
                                dataLinkedManager.fetchItems { success in
                                    if success {
                                        print("successfully loaded the linked Items from DataLinkedManager")

                                    } else {
                                        print("failed to loaded the linked Items from DataLinkedManager")
                                    }
                                }
                            })
                            .sheet(isPresented: $isUpdatingJournal){
                                // MARK: - think about the invalide id, because maybe the journal haven't yet been uploaded
                                JournalEditorView(journalvm: journalvm, journalTagvm: TagViewModel(tagNamesOfItem: journalvm.journal.tagNames, ownerItemID: journalvm.journal.id, completion: {_ in}))
                            }
                            .sheet(isPresented: $isShowingLinkView){
                                SearchView(searchvm: searchvm, tagPanelvm: tagPanelvm)
                            }
                            
                            .foregroundColor(.primary)
                            .padding()
                            .frame(maxWidth: .infinity,alignment: .leading)
                            .background(colorScheme == .dark ? Color.gray.opacity(0.6) : Color.white)
                            .cornerRadius(10)
                        
                    }
                            
                    
                }
            }
            
            
        }
        .onAppear {
            journalvm.fetchJournals { success in
                if success {
                    print("successfully loaded the journals from firebase")
                } else {
                    print("failed to load the journals from firebase")
                }
            }
        }
    }
    
}

struct JournalView_Previews: PreviewProvider {
    static var previews: some View {
        JournalListView(journalvm: JournalViewModel(), dataLinkedManager: DataLinkedManager(), searchvm: SearchViewModel(), tagPanelvm: TagPanelViewModel())
    }
}
