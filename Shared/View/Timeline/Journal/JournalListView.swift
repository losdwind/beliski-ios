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
    @State var isShowingLinkedItemView = false
    @State var isShowingLinkView:Bool = false

    
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
        LazyVStack(alignment: .center, spacing: 20) {
                ForEach(journalvm.fetchedJournals, id:\.id){ journal in
                
                        JournalItemView(journal: journal, tagNames: journal.tagNames, OwnerItemID: journal.id)
                        
                    
                        .background{
                            NavigationLink(destination: LinkedItemsView(dataLinkedManager: dataLinkedManager) , isActive: $isShowingLinkedItemView) {
                                EmptyView()
                            }
                        }
                        .contextMenu{
                            // Delete
                            Button(action:{
                                journalvm.deleteJournal(journal: journal){success in
                                    if success {
                                        journalvm.fetchJournals(handler: {_ in })
                                    }
                                    
                                }
                                
                            }
                                   ,label:{Label(
                                    title: { Text("Delete") },
                                    icon: { Image(systemName: "trash.circle") })})
                            
                            
                            // Edit
                            Button(action:{
                                journalvm.journal = journal
                                journalvm.localTimestamp = journal.localTimestamp?.dateValue() ?? Date(timeIntervalSince1970: 0)
                                isUpdatingJournal = true
                                
                            }
                                   ,label:{Label(
                                    title: { Text("Edit") },
                                    icon: { Image(systemName: "pencil.circle") })})
                            
                            
                            // Link
                            Button(action:{
                                isShowingLinkView = true
                                
                            }
                                   ,label:{Label(
                                    title: { Text("Link") },
                                    icon: { Image(systemName: "link.circle") })})
                            
                        }
                        .onTapGesture(perform: {
                            isShowingLinkedItemView.toggle()
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
                            SearchAndLinkingView(item:journal, searchvm: searchvm, tagPanelvm: tagPanelvm)
                        }

                }

            }
        .padding()
        .frame(maxWidth: 640)

        }
    }
    
}

struct JournalView_Previews: PreviewProvider {
    static var previews: some View {
        JournalListView(journalvm: JournalViewModel(), dataLinkedManager: DataLinkedManager(), searchvm: SearchViewModel(), tagPanelvm: TagPanelViewModel())
    }
}
