//
//  TimelineView.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/16.
//

import SwiftUI

struct TimelineView: View {
    
    @ObservedObject var timelineManager:TimelineManager
    @ObservedObject var journalvm: JournalViewModel
    @ObservedObject var taskvm: TaskViewModel
    @ObservedObject var personvm: PersonViewModel
    @ObservedObject var dataLinkedManger:DataLinkedManager
    @ObservedObject var searchvm: SearchViewModel
    @ObservedObject var tagPanelvm:TagPanelViewModel
    
    @State var isShowingSearchView = false
    
    
    
    init(timelineManger:TimelineManager, journalvm:JournalViewModel, taskvm:TaskViewModel, personvm:PersonViewModel, dataLinkedManager: DataLinkedManager, searchvm:SearchViewModel, tagPanelvm:TagPanelViewModel){
        self.timelineManager = timelineManger
        self.journalvm = journalvm
        self.taskvm = taskvm
        self.personvm = personvm
        self.dataLinkedManger = dataLinkedManager
        self.searchvm = searchvm
        self.tagPanelvm = tagPanelvm
        
        UIPageControl.appearance().currentPageIndicatorTintColor = .clear
        UIPageControl.appearance().pageIndicatorTintColor = .clear
    }
    
    var body: some View {
        NavigationView {
            VStack{
                HStack{
                    //                Button(action: {timelineManager.showFilterView.toggle()}, label: {Image(systemName: "line.horizontal.3.decrease.circle") })
                    //                    .layoutPriority(1)
                    //
                    Picker("Filter", selection:$timelineManager.selectedTab){
                        // Todo: - check the TimelineManager Enum
                        Text("Today").tag(TimelineTab.TODAY)
                            .foregroundColor(timelineManager.selectedTab == .TODAY ? .blue : .red)
                        
                        Text("Events").tag(TimelineTab.EVENTS)
                            .foregroundColor(timelineManager.selectedTab == .EVENTS ? .blue : .red)
                        
                        Text("Topics").tag(TimelineTab.TOPICS)
                            .foregroundColor(timelineManager.selectedTab == .TOPICS ? .blue : .red)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal, 50)
                    
                    //                //
                    //                Button(action: {timelineManager.showSearchView.toggle()}, label: {Image(systemName: "magnifyingglass.circle") })
                    //                    .layoutPriority(1)
                }
                .padding(.horizontal,20)
                
                
                //: Tabview
                TabView(selection: $timelineManager.selectedTab) {
                    
                    JournalListView(journalvm: journalvm, dataLinkedManager: dataLinkedManger, searchvm: searchvm, tagPanelvm: tagPanelvm).tag(TimelineTab.TODAY)
                    
                    TaskListView(taskvm: taskvm).tag(TimelineTab.EVENTS)
                    
                    PersonListView(personvm: personvm, dataLinkedManager: dataLinkedManger, searchvm: searchvm, tagPanelvm: tagPanelvm).tag(TimelineTab.TOPICS)
                    
                }
                .tabViewStyle(PageTabViewStyle())
                //                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
                
            } //: VStack
            .frame(maxWidth:640)
            .navigationTitle(LocalizedStringKey("Timeline"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement:.navigationBarLeading){
                    Button(
                        action: {
                            isShowingSearchView.toggle()}
                        ,label: {
                            Image(systemName: "magnifyingglass.circle")})
                    
                }
                
                ToolbarItem(placement:.navigationBarTrailing){
                    Menu {
                        Button("Compact", action: {timelineManager.theme = Theme.compact} )
                        Button("Full", action: {timelineManager.theme = Theme.full} )
                    } label: {
                        Label("Theme", systemImage: "sparkles")
                    }
                }
            }
            .sheet(isPresented: $isShowingSearchView){
                SearchView(searchvm: searchvm, tagPanelvm: tagPanelvm)
            }
            
        }
    }
}

struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        TimelineView(timelineManger: TimelineManager(), journalvm: JournalViewModel(), taskvm: TaskViewModel(), personvm: PersonViewModel(), dataLinkedManager: DataLinkedManager(), searchvm: SearchViewModel(), tagPanelvm: TagPanelViewModel())
    }
}
