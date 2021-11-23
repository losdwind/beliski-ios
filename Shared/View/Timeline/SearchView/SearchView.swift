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
    @ObservedObject var todovm: TodoViewModel
    @ObservedObject var personvm: PersonViewModel
    @ObservedObject var dataLinkedManger:DataLinkedManager
    @ObservedObject var tagPanelvm:TagPanelViewModel
    @ObservedObject var timelineManager:TimelineManager
    @ObservedObject var branchvm:BranchViewModel
    
    @Environment(\.presentationMode) var presentationMode
    @State var isShowingSearchResultView:Bool = false
    
    var body: some View {
            ScrollView(.vertical,showsIndicators: false){
                
                
                FilterView(tagPanelvm: tagPanelvm, searchvm: searchvm)

                if isShowingSearchResultView{
                    Text("Results")
                        .font(.title3.bold())
                        .frame(maxWidth: .infinity,alignment: .leading)
                        .padding()
                    
                    SearchResultComplexView(timelineManager: timelineManager, searchvm: searchvm, journalvm: journalvm, todovm: todovm, personvm: personvm, dataLinkedManger: dataLinkedManger, tagPanelvm: tagPanelvm, branchvm: branchvm)
                        
                }
                
                
                
                Spacer()
                
                
            }
            .frame(maxWidth:640)
            
            
            
            
            
            .navigationTitle("Search")
            .toolbar {
                
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        searchvm.fetchIDsFromFilter { success in
                            if success {
                                print("successfully get the filtered items and assign to item list view")
                                journalvm.fetchedJournals = searchvm.filteredJournals
                                todovm.fetchedTodos = searchvm.filteredTodos
                                personvm.fetchedPersons = searchvm.filteredPersons
                                branchvm.fetchedAllBranches = searchvm.filteredBranches
                                isShowingSearchResultView = true
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
            
        
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(searchvm: SearchViewModel(), journalvm: JournalViewModel(), todovm: TodoViewModel(), personvm: PersonViewModel(), dataLinkedManger: DataLinkedManager(), tagPanelvm: TagPanelViewModel(), timelineManager: TimelineManager(), branchvm: BranchViewModel())
    }
}
