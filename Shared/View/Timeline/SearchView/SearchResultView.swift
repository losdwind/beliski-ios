//
//  SearchResultView.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/23.
//

import SwiftUI

struct SearchResultView: View {
    
    @ObservedObject var searchvm: SearchViewModel
    
    var body: some View {
        switch searchvm.searchType {
        case .journal:
            List(selection: $searchvm.selectedJournals){
                ForEach(searchvm.filteredJournals, id: \.self){
                    journal in
                    JournalItemView(journal: journal, tagNames: journal.tagNames, OwnerItemID: journal.id)
                        .listRowSeparator(.hidden)
                }
            }
            
            
        case .task:
            List(selection: $searchvm.selectedTasks){
                ForEach(searchvm.filteredTasks, id: \.self){
                    task in
                    TaskRowItemView(task: task)
                        .listRowSeparator(.hidden)

                }
            }
            
        case.person:
            List(selection: $searchvm.selectedPersons){
                ForEach(searchvm.fileteredPersons, id: \.self){
                    person in
                    PersonItemView(person: person, tagNames: person.tagNames, OwnerItemID: person.id)
                        .listRowSeparator(.hidden)

                }
            }
            
        }
        
        
    }
    
}

struct SearchResultView_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultView(searchvm: SearchViewModel())
    }
}
