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
    @ObservedObject var todovm: TodoViewModel
    @ObservedObject var personvm: PersonViewModel
    @ObservedObject var dataLinkedManger:DataLinkedManager
    @ObservedObject var searchvm: SearchViewModel
    @ObservedObject var tagPanelvm:TagPanelViewModel
    @ObservedObject var branchvm: BranchViewModel
    @ObservedObject var profilevm:ProfileViewModel

    
    init(timelineManger:TimelineManager, journalvm:JournalViewModel, todovm:TodoViewModel, personvm:PersonViewModel, dataLinkedManager: DataLinkedManager, searchvm:SearchViewModel, tagPanelvm:TagPanelViewModel, branchvm:BranchViewModel, profilevm:ProfileViewModel){
        self.timelineManager = timelineManger
        self.journalvm = journalvm
        self.todovm = todovm
        self.personvm = personvm
        self.dataLinkedManger = dataLinkedManager
        self.searchvm = searchvm
        self.tagPanelvm = tagPanelvm
        self.branchvm = branchvm
        self.profilevm = profilevm
        
//        UIPageControl.appearance().currentPageIndicatorTintColor = .clear
//        UIPageControl.appearance().pageIndicatorTintColor = .clear
        
//        UITabBar.appearance().shadowImage = UIImage()
//        UITabBar.appearance().backgroundImage = UIImage()
//        UITabBar.appearance().isTranslucent = true
//        UITabBar.appearance().backgroundColor = .white
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
                                                
                        
                        Text("Topics")
                        .tag(TimelineTab.TOPICS)
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
                switch timelineManager.selectedTab {
                case .TODAY:
                    JournalListView(journalvm: journalvm, dataLinkedManager: dataLinkedManger, searchvm: searchvm, tagPanelvm: tagPanelvm)
                case .EVENTS:
                    TodoListView(todovm: todovm, searchvm: searchvm, tagPanelvm: tagPanelvm, dataLinkedManager: dataLinkedManger)
                case .TOPICS:
                    TopicView(timelineManager: timelineManager, journalvm: journalvm, todovm: todovm, personvm: personvm, dataLinkedManger: dataLinkedManger, searchvm: searchvm, tagPanelvm: tagPanelvm, branchvm: branchvm)
                    
                    
                   
                }
                
//                Menu("something") {
//                    Picker("Filter", selection:$timelineManager.selectedTab){
//                        // Todo: - check the TimelineManager Enum
//                        Text("Today").tag(TimelineTab.TODAY)
//                            .foregroundColor(timelineManager.selectedTab == .TODAY ? .blue : .red)
//
//                        Text("Events").tag(TimelineTab.EVENTS)
//                            .foregroundColor(timelineManager.selectedTab == .EVENTS ? .blue : .red)
//
//
//                        Text("Topics")
//                        .tag(TimelineTab.TOPICS)
//                            .foregroundColor(timelineManager.selectedTab == .TOPICS ? .blue : .red)
//
//
//
//                    }
//                    .pickerStyle(MenuPickerStyle())
//                }
//                TabView(selection: $timelineManager.selectedTab) {
//
//                    JournalListView(journalvm: journalvm, dataLinkedManager: dataLinkedManger, searchvm: searchvm, tagPanelvm: tagPanelvm).tag(TimelineTab.TODAY)
//
//
//                    TodoListView(todovm: todovm, searchvm: searchvm, tagPanelvm: tagPanelvm, dataLinkedManager: dataLinkedManger).tag(TimelineTab.EVENTS)
//
//                    PersonListView(personvm: personvm, dataLinkedManager: dataLinkedManger, searchvm: searchvm, tagPanelvm: tagPanelvm).tag(TimelineTab.TOPICS)
//
//
//                }
//                .tabViewStyle(PageTabViewStyle())
                //                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
                
            } //: VStack
            .frame(maxWidth:640)
            .navigationTitle(LocalizedStringKey("Timeline"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement:.navigationBarLeading){

                    NavigationLink {
                        SearchView(searchvm: searchvm, journalvm: journalvm, todovm: todovm, personvm: personvm, dataLinkedManger: dataLinkedManger, tagPanelvm: tagPanelvm, timelineManager: timelineManager, branchvm: branchvm)
                    } label: {
                        Image(systemName: "magnifyingglass.circle")
                    }

                    
                }
                
                ToolbarItem(placement:.navigationBarTrailing){
//                    Menu {
//                        Button("Compact", action: {timelineManager.theme = Theme.compact} )
//                        Button("Full", action: {timelineManager.theme = Theme.full} )
//                    } label: {
//                        Label("Theme", systemImage: "sparkles")
//                    }
//
                    
                    NavigationLink {
                        InspireView(profilevm: profilevm)
                    } label: {
                        Image(systemName: "sparkles")
                    }
                }
            }
          

            
        }
//        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        TimelineView(timelineManger: TimelineManager(), journalvm: JournalViewModel(), todovm: TodoViewModel(), personvm: PersonViewModel(), dataLinkedManager: DataLinkedManager(), searchvm: SearchViewModel(), tagPanelvm: TagPanelViewModel(), branchvm: BranchViewModel(), profilevm: ProfileViewModel())
            .preferredColorScheme(.light)
            .environment(\.sizeCategory, .extraSmall)
    }
}
