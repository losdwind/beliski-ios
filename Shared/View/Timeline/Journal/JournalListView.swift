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
    @State var isShowingJournalSearchView = false
    @State var isShowingJournalFilterView = false
    
    
    var body: some View {
        
        NavigationView() {
            List(journalvm.fetchedJournals){
                journal in
                
                
                NavigationLink(destination: JournalLinkedView()){
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
                        .background(Color.gray)
                        .cornerRadius(10)
                    
                    
                }
                .listRowSeparator(.hidden)
                
                
            }
            .listStyle(.inset)
            .refreshable {
                journalvm.fetchJournals { _ in }
            }
            .navigationTitle(LocalizedStringKey("Timeline"))
            .toolbar {
                ToolbarItem(placement:.navigationBarLeading){
                    Button(
                        action: {
                            isShowingJournalSearchView.toggle()
                        },
                        label: {
                            Image(systemName: "line.3.horizontal.decrease.circle")})
                    
                }
                
                ToolbarItem(placement:.navigationBarTrailing){
                    Button(
                        action: {
                            isShowingJournalFilterView.toggle()
                        },
                        label: {
                            Image(systemName: "magnifyingglass.circle")})
                    
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
