//
//  TopicView.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/31.
//

import SwiftUI

struct TopicView: View {
    @ObservedObject var timelineManager:TimelineManager
    @ObservedObject var journalvm: JournalViewModel
    @ObservedObject var taskvm: TaskViewModel
    @ObservedObject var personvm: PersonViewModel
    @ObservedObject var dataLinkedManger:DataLinkedManager
    @ObservedObject var searchvm: SearchViewModel
    @ObservedObject var tagPanelvm:TagPanelViewModel
    @ObservedObject var branchvm: BranchViewModel
    
    var body: some View {
        VStack{
            Menu("Category") {
                ForEach(SearchType.allCases, id:\.self){ type in
                    Button {
                        timelineManager.selectedMenu = type
                    } label: {
                        Text(type.rawValue)
                            .foregroundColor(Color.pink)
                    }

                }
            }.menuStyle(.automatic)
            
            switch timelineManager.selectedMenu {
            case .person:
                PersonListView(personvm: personvm, dataLinkedManager: dataLinkedManger, searchvm: searchvm, tagPanelvm: tagPanelvm, timelineManager: timelineManager)
            case .journal:
                JournalListView(journalvm: journalvm, dataLinkedManager: dataLinkedManger, searchvm: searchvm, tagPanelvm: tagPanelvm)
            case .task:
                TaskListView(taskvm: taskvm, searchvm: searchvm, tagPanelvm: tagPanelvm, dataLinkedManager: dataLinkedManger)
            case .branch:
                BranchCardListView(branchvm: branchvm, dataLinkedManager: dataLinkedManger, searchvm: searchvm, tagPanelvm: tagPanelvm)
                
            }
        }
        
        
    }
}

struct TopicView_Previews: PreviewProvider {
    static var previews: some View {
        TopicView(timelineManager: TimelineManager(), journalvm: JournalViewModel(), taskvm: TaskViewModel(), personvm: PersonViewModel(), dataLinkedManger: DataLinkedManager(), searchvm: SearchViewModel(), tagPanelvm: TagPanelViewModel(), branchvm: BranchViewModel())
    }
}
