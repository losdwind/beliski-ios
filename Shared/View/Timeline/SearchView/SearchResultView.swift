//
//  SearchResultView.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/23.
//

import SwiftUI

struct SearchResultView: View {
    @ObservedObject var searchvm:SearchViewModel
    
    var body: some View {
        
        NavigationView{
            List(selection: $searchvm.selectedItems){
            
            Section {
                ForEach(searchvm.filteredJournals, id: \.self){
                    journal in
                    JournalItemView(journal: journal, tagIDs: journal.tagIDs, OwnerItemID: journal.id!)
                }
            } header: {
                Text("Journals")
            }

            Section {
                ForEach(searchvm.filteredTasks, id: \.self){
                    task in
                    TaskRowItemView(task: task)
                }
            } header: {
                Text("Tasks")
            }
            
            
            Section {
                ForEach(searchvm.fileteredPersons, id: \.self){
                    person in
                    PersonItemView(person: person, tagIDs: person.tagIDs, OwnerItemID: person.id!)
                }
            } header: {
                Text("Person")
            }


        }
        .toolbar(content: {
            EditButton()
                .foregroundColor(.primary)
        })
}
    }
}

struct SearchResultView_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultView(searchvm: SearchViewModel())
    }
}
