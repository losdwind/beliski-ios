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
    @ObservedObject var timelineManager:TimelineManager
    @ObservedObject var branchvm:BranchViewModel
    
    @Environment(\.presentationMode) var presentationMode
    @State var isShowingSearchResultView:Bool = false
    
    var body: some View {
        NavigationView{
            ScrollView(.vertical,showsIndicators: false){
            VStack(alignment:.leading) {
                
                
                
                
                // dates
                Text("Filt by Date")
                    .font(.title3.bold())
                    .frame(maxWidth: .infinity,alignment: .leading)
                
                VStack{
                    DatePicker("Start Date", selection: $searchvm.dateStart)
                    
                    DatePicker("End Date", selection: $searchvm.dateEnd)
                }
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                
                
                
                
                
                
                // tags
                Text("Filt by Tag")
                    .font(.title3.bold())
                    .frame(maxWidth: .infinity,alignment: .leading)
                TagPanelView(tagPanelvm: tagPanelvm)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                
                
                
                
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
                
                
                // keywords
                
                Text("Keywords")
                    .font(.title3.bold())
                    .frame(maxWidth: .infinity,alignment: .leading)
                
                
                TextField("Search", text: $searchvm.keywords, prompt: Text("Put a keyword here"))
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .foregroundColor(.primary)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                
                
                
                
                // Search Confirm Button
                
                    Button {
                        searchvm.fetchIDsFromFilter { success in
                            if success {
                                print("successfully get the filtered items and assign to item list view")
                                journalvm.fetchedJournals = searchvm.filteredJournals
                                taskvm.fetchedTasks = searchvm.filteredTasks
                                personvm.fetchedPersons = searchvm.fileteredPersons
                                isShowingSearchResultView = true
                            } else {
                                print("failed to get the filtered items or assign to item list view ")
                            }
                            
                            
                        }
                        
                    } label: {
                        Text("Search")
                            .font(.title2.bold())
                            .padding()
                            .background(Color.pink)
                            .cornerRadius(10)
                    }
                
                if isShowingSearchResultView{
                    SearchResultComplexView(timelineManager: timelineManager, searchvm: searchvm, journalvm: journalvm, taskvm: taskvm, personvm: personvm, dataLinkedManger: dataLinkedManger, tagPanelvm: tagPanelvm, branchvm: branchvm)
                        
                }
                
                
                
                Spacer()
                
            }
            }
            .padding()
            .frame(maxWidth:640)
            
            
            
            
            
            .navigationTitle("Search")
            .toolbar {
                
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Close")
                            .foregroundColor(Color.primary)
                    }
                }
                
                
                
                
                
                
            }
            
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(searchvm: SearchViewModel(), journalvm: JournalViewModel(), taskvm: TaskViewModel(), personvm: PersonViewModel(), dataLinkedManger: DataLinkedManager(), tagPanelvm: TagPanelViewModel(), timelineManager: TimelineManager(), branchvm: BranchViewModel())
    }
}
