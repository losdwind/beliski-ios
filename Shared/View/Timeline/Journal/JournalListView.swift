//
//  JournalView.swift
//  Beliski-Firebase
//
//  Created by Wind Losd on 2021/9/17.
//

import SwiftUI

struct JournalListView: View {
    
    @ObservedObject var journalvm:JournalViewModel
    
    @State var isUpdatingJournal = false
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack {
                if journalvm.fetchedJournals.isEmpty == false {
                ForEach(journalvm.fetchedJournals, id:\.self ) { journal in
                    JournalItemView(journal: journal)
                        .contextMenu(menuItems:{
                            Button(action:{
                                journalvm.deleteJournal(journal: journal){_ in}
                                
                            }
                                   ,label:{Label(
                                    title: { Text("Delete") },
                                    icon: { Image(systemName: "trash.circle") })})
                        
                            Button(action:{
                                journalvm.journal = journal
                                isUpdatingJournal = true

                            }
                                   ,label:{Label(
                                    title: { Text("Edit") },
                                    icon: { Image(systemName: "pencil.circle") })})
                            
                        })
                        .sheet(isPresented: $isUpdatingJournal, onDismiss: {
                            journalvm.journal = Journal()
                        }, content: {
                            JournalEditorView(journalvm: journalvm)
                        })
                        .padding(.vertical, 0)
                        .frame(maxWidth: 640)
                }
                } else {
                    Text("fetched journals is Empty")
                }
            }
        }

    }
}

struct JournalView_Previews: PreviewProvider {
    static var previews: some View {
        JournalListView(journalvm: JournalViewModel())
    }
}
