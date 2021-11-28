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
    @ObservedObject var momentvm: MomentViewModel
    @ObservedObject var todovm: TodoViewModel
    @ObservedObject var personvm: PersonViewModel
    @ObservedObject var dataLinkedManger:DataLinkedManager
    @ObservedObject var tagPanelvm:TagPanelViewModel
    @ObservedObject var branchvm:BranchViewModel
    

    var body: some View {
        
        switch searchvm.searchType {
        case .moment:
            
            MomentListView(momentvm: momentvm, dataLinkedManager: dataLinkedManger, searchvm: searchvm, tagPanelvm: tagPanelvm)
                
        case .todo:
            TodoListView(todovm: todovm, searchvm: searchvm, tagPanelvm: tagPanelvm, dataLinkedManager: dataLinkedManger)
            
        case.person:
            PersonListView(personvm: personvm, dataLinkedManager: dataLinkedManger, searchvm: searchvm, tagPanelvm: tagPanelvm, timelineManager: timelineManager)
            
        case .branch:
            BranchCardListView(branchvm: branchvm, dataLinkedManager: dataLinkedManger, searchvm: searchvm, tagPanelvm: tagPanelvm)
        }
    }
}

struct SearchResultComplexView_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultComplexView(timelineManager: TimelineManager(), searchvm: SearchViewModel(), momentvm: MomentViewModel(), todovm: TodoViewModel(), personvm: PersonViewModel(), dataLinkedManger: DataLinkedManager(), tagPanelvm: TagPanelViewModel(), branchvm: BranchViewModel())
    }
}
