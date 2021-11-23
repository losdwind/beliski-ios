//
//  SearchResultView.swift
//  Beliski
//
//  Created by Losd wind on 2021/11/10.
//

import SwiftUI
import Kingfisher

struct SearchResultView: View {
    
    @ObservedObject var searchvm: SearchViewModel
    
    
    var body: some View {
        switch searchvm.searchType {
        case .journal:
            VStack{
                ForEach(searchvm.filteredJournals, id: \.self){
                    journal in
                    
                        Button {
                            if searchvm.selectedJournals.contains(journal){
                                searchvm.selectedJournals.remove(journal)
                            } else {
                                searchvm.selectedJournals.insert(journal)
                            }
                        } label: {
                            ZStack(alignment:.center){
                                
                    
                                JournalItemView(journal: journal, tagNames: journal.tagNames, OwnerItemID: journal.id)
                                    .foregroundColor(.primary)
                                    .blur(radius:  searchvm.selectedJournals.contains(journal) ? 5 : 0)
                                
                                Image(systemName: "checkmark")
                                    .font(.largeTitle)
                                    .foregroundColor(.pink)
                                    .opacity(searchvm.selectedJournals.contains(journal) ? 1 : 0)
                            }
                            .padding()
                        }

                        
                }
            }
            
            
        case .todo:
            VStack{
                ForEach(searchvm.filteredTodos, id: \.self){
                    todo in
                    Button {
                        if searchvm.selectedTodos.contains(todo){
                            searchvm.selectedTodos.remove(todo)
                        } else {
                            searchvm.selectedTodos.insert(todo)
                        }
                    } label: {
                        ZStack(alignment:.center){
                            
                
                            TodoRowItemView(todo: todo)
                                .foregroundColor(.primary)
                                .blur(radius:  searchvm.selectedTodos.contains(todo) ? 5 : 0)
                            
                            Image(systemName: "checkmark")
                                .font(.largeTitle)
                                .foregroundColor(.pink)
                                .opacity(searchvm.selectedTodos.contains(todo) ? 1 : 0)
                        }
                        .padding()
                    }
                    
                }
            }
            
            
        case.person:
            VStack{
                ForEach(searchvm.filteredPersons, id: \.self){
                    person in
                    
                    Button {
                        if searchvm.selectedPersons.contains(person){
                            searchvm.selectedPersons.remove(person)
                        } else {
                            searchvm.selectedPersons.insert(person)
                        }
                    } label: {
                        ZStack(alignment:.center){
                            
                
                            PersonItemView(person: person, tagNames: person.tagNames, OwnerItemID: person.id, isShowingPhtos: false, isShowingDescription: false, isShowingTags: false)
                                .foregroundColor(.primary)
                                .blur(radius:  searchvm.selectedPersons.contains(person) ? 5 : 0)
                            
                            Image(systemName: "checkmark")
                                .font(.largeTitle)
                                .foregroundColor(.pink)
                                .opacity(searchvm.selectedPersons.contains(person) ? 1 : 0)
                        }
                        .padding()
                    }
                }
            }
            
            
        case .branch:
            VStack{
                ForEach(searchvm.filteredBranches, id: \.self){
                    branch in
                    Button {
                        if searchvm.selectedBranches.contains(branch){
                            searchvm.selectedBranches.remove(branch)
                        } else {
                            searchvm.selectedBranches.insert(branch)
                        }
                    } label: {
                        ZStack(alignment:.center){
                            
                
                            BranchCardView(branch: branch)
                                .foregroundColor(.primary)
                                .blur(radius:  searchvm.selectedBranches.contains(branch) ? 5 : 0)
                            
                            Image(systemName: "checkmark")
                                .font(.largeTitle)
                                .foregroundColor(.pink)
                                .opacity(searchvm.selectedBranches.contains(branch) ? 1 : 0)
                        }
                        .padding()
                    }
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
