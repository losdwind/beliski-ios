//
//  JournalView.swift
//  Beliski-Firebase
//
//  Created by Wind Losd on 2021/9/17.
//

import SwiftUI

struct JournalListView: View {
    
    @StateObject var journalvm = JournalViewModel()
    
    var body: some View {
        LazyVStack {
            ForEach($journalvm.fetchedJournals, id:\.self ) { journal in
                JournalItemView(journal: journal)
                    .contextMenu(menuItems:{
                        Button(action:{
                            journalvm.deleteJournal(journal: journal)
                            
                        }
                               ,label:{Label(
                                title: { Text("Delete") },
                                icon: { Image(systemName: "trash.circle") })})
                    
                        Button(action:{
                            journalvm.isUpdatingJournal = true
                            journalvm.journalInUpdation = journal
                        }
                               ,label:{Label(
                                title: { Text("Edit") },
                                icon: { Image(systemName: "pencil.circle") })})
                        
                    })
                    .sheet(isPresented: $journalvm.isUpdatingJournal, content: {
                        JournalEditorView(journalvm: journalvm)
                    })
                    .padding(.vertical, 0)
                    .frame(maxWidth: 640)
            }
        }
    }
}

struct JournalView_Previews: PreviewProvider {
    static var previews: some View {
        JournalListView()
    }
}
