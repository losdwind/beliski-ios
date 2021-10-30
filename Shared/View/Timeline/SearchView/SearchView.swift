//
//  SearchView.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/27.
//

import SwiftUI

struct SearchView: View {
    
    @ObservedObject var searchvm: SearchViewModel
    @ObservedObject var journalvm: JournalViewModel
    @ObservedObject var taskvm: TaskViewModel
    @ObservedObject var personvm: PersonViewModel
    @ObservedObject var dataLinkedManger:DataLinkedManager
    @ObservedObject var tagPanelvm:TagPanelViewModel
    
    @Environment(\.presentationMode) var presentationMode

    
    var body: some View {
        NavigationView{
            VStack {
                Form {
                    // keywords
                    Section {
                        HStack(alignment: .center, spacing: 20){
                            TextField("Search", text: $searchvm.keywords, prompt: Text("Put a keyword here"))
                                .foregroundColor(.primary)
                            
                            NavigationLink(destination: SearchResultComplexView(searchvm: searchvm, journalvm: journalvm, taskvm: taskvm, personvm: personvm, dataLinkedManger: dataLinkedManger, tagPanelvm: tagPanelvm) ) {
                                Button {
                                    searchvm.fetchIDsFromFilter { success in
                                        if success {
                                            print("successfully get the filtered items and assign to item list view")
                                            journalvm.fetchedJournals = searchvm.filteredJournals
                                            taskvm.fetchedTasks = searchvm.filteredTasks
                                            personvm.fetchedPersons = searchvm.fileteredPersons
                                        } else {
                                            print("failed to get the filtered items or assign to item list view ")
                                        }
                                        
                                        
                                    }
                                    
                                } label: {
                                    Image(systemName: "magnifyingglass")
                                        .foregroundColor(Color.pink)
                                }
                            }
                            
                        }
                    } header: {
                        Text("Keywords")
                    }
                    
                    
                    // types
                    Picker("Filter", selection:$searchvm.searchType){
                        
                        Text("Journal").tag(SearchType.journal)
                            .foregroundColor(searchvm.searchType == .journal ? .blue : .red)
                        
                        Text("Task").tag(SearchType.task)
                            .foregroundColor(searchvm.searchType == .task ? .blue : .red)
                        
                        Text("Person").tag(SearchType.person)
                            .foregroundColor(searchvm.searchType == .person ? .blue : .red)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    
                    // dates
                    Section {
                        DatePicker("Start Date", selection: $searchvm.dateStart)
                        
                        DatePicker("End Date", selection: $searchvm.dateEnd)
                    } header: {
                        Text("Filt by Date")
                    }
                    
                    
                    // tags
                    Section {
                        TagPanelView(tagPanelvm: tagPanelvm)
                    }header: {
                        Text("Filt by Tag")
                    }
                    
                    
                    
                    
                }
        }
            
                
                
            
            .navigationTitle("Search")
            .toolbar {
                
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Done")
                            .foregroundColor(Color.primary)
                    }

                }
            }
            
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(searchvm: SearchViewModel(), journalvm: JournalViewModel(), taskvm: TaskViewModel(), personvm: PersonViewModel(), dataLinkedManger: DataLinkedManager(), tagPanelvm: TagPanelViewModel())
    }
}
