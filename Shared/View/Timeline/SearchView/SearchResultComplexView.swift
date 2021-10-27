//
//  SearchResultComplexView.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/27.
//

import SwiftUI

struct SearchResultComplexView: View {
    @ObservedObject var searchvm: SearchViewModel
    @ObservedObject var journalvm: JournalViewModel
    @ObservedObject var taskvm: TaskViewModel
    @ObservedObject var personvm: PersonViewModel
    @ObservedObject var dataLinkedManger:DataLinkedManager
    @ObservedObject var tagPanelvm:TagPanelViewModel

    var body: some View {
        switch searchvm.searchType {
        case .journal:
            
            JournalListView(journalvm: journalvm, dataLinkedManager: dataLinkedManger, searchvm: searchvm, tagPanelvm: tagPanelvm)
                
        case .task:
            TaskListView(taskvm: taskvm, searchvm: searchvm, tagPanelvm: tagPanelvm, dataLinkedManager: dataLinkedManger)
            
        case.person:
            PersonListView(personvm: personvm, dataLinkedManager: dataLinkedManger, searchvm: searchvm, tagPanelvm: tagPanelvm)
            
        }
    }
}

struct SearchResultComplexView_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultComplexView(searchvm: SearchViewModel(), journalvm: JournalViewModel(), taskvm: TaskViewModel(), personvm: PersonViewModel(), dataLinkedManger: DataLinkedManager(), tagPanelvm: TagPanelViewModel())
    }
}
