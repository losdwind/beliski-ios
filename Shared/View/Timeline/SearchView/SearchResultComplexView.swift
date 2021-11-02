//
//  SearchResultComplexView.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/27.
//

import SwiftUI

struct SearchResultComplexView: View {
    @ObservedObject var timelineManager:TimelineManager
    @ObservedObject var searchvm: SearchViewModel
    @ObservedObject var journalvm: JournalViewModel
    @ObservedObject var taskvm: TaskViewModel
    @ObservedObject var personvm: PersonViewModel
    @ObservedObject var dataLinkedManger:DataLinkedManager
    @ObservedObject var tagPanelvm:TagPanelViewModel
    @ObservedObject var branchvm:BranchViewModel

    var body: some View {
        
        switch searchvm.searchType {
        case .journal:
            
            JournalListView(journalvm: journalvm, dataLinkedManager: dataLinkedManger, searchvm: searchvm, tagPanelvm: tagPanelvm)
                
        case .task:
            TaskListView(taskvm: taskvm, searchvm: searchvm, tagPanelvm: tagPanelvm, dataLinkedManager: dataLinkedManger)
            
        case.person:
            PersonListView(personvm: personvm, dataLinkedManager: dataLinkedManger, searchvm: searchvm, tagPanelvm: tagPanelvm, timelineManager: timelineManager)
            
        case .branch:
            BranchCardListView(branchvm: branchvm, dataLinkedManager: dataLinkedManger, searchvm: searchvm, tagPanelvm: tagPanelvm)
        }
    }
}

struct SearchResultComplexView_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultComplexView(timelineManager: TimelineManager(), searchvm: SearchViewModel(), journalvm: JournalViewModel(), taskvm: TaskViewModel(), personvm: PersonViewModel(), dataLinkedManger: DataLinkedManager(), tagPanelvm: TagPanelViewModel(), branchvm: BranchViewModel())
    }
}
