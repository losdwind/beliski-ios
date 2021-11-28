//
//  TimelineView.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/16.
//

import SwiftUI

struct TimelineView: View {
    
    @ObservedObject var timelineManager:TimelineManager
    @ObservedObject var momentvm: MomentViewModel
    @ObservedObject var todovm: TodoViewModel
    @ObservedObject var personvm: PersonViewModel
    @ObservedObject var dataLinkedManger:DataLinkedManager
    @ObservedObject var searchvm: SearchViewModel
    @ObservedObject var tagPanelvm:TagPanelViewModel
    @ObservedObject var branchvm: BranchViewModel
    @ObservedObject var profilevm:ProfileViewModel
    
    @State var isShowingCreateView:Bool = false
    init(timelineManger:TimelineManager, momentvm:MomentViewModel, todovm:TodoViewModel, personvm:PersonViewModel, dataLinkedManager: DataLinkedManager, searchvm:SearchViewModel, tagPanelvm:TagPanelViewModel, branchvm:BranchViewModel, profilevm:ProfileViewModel){
        self.timelineManager = timelineManger
        self.momentvm = momentvm
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
            ZStack(alignment:.bottomTrailing) {
            VStack{
                HStack{
                    
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
                }
                .padding(.horizontal,20)
                
                
                
                // TabView
                TabView(selection: $timelineManager.selectedTab) {
                    MomentListView(momentvm: momentvm, dataLinkedManager: dataLinkedManger, searchvm: searchvm, tagPanelvm: tagPanelvm).tag(TimelineTab.TODAY)
                    TodoListView(todovm: todovm, searchvm: searchvm, tagPanelvm: tagPanelvm, dataLinkedManager: dataLinkedManger).tag(TimelineTab.EVENTS)
                    TopicView(timelineManager: timelineManager, momentvm: momentvm, todovm: todovm, personvm: personvm, dataLinkedManger: dataLinkedManger, searchvm: searchvm, tagPanelvm: tagPanelvm, branchvm: branchvm).tag(TimelineTab.TOPICS)
                    
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                
            } //: VStack
            .frame(maxWidth:640)
            .navigationTitle(LocalizedStringKey("Timeline"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement:.navigationBarLeading){
                    
                    NavigationLink {
                        SearchView(searchvm: searchvm, momentvm: momentvm, todovm: todovm, personvm: personvm, dataLinkedManger: dataLinkedManger, tagPanelvm: tagPanelvm, timelineManager: timelineManager, branchvm: branchvm)
                    } label: {
                        Image(systemName: "magnifyingglass.circle")
                    }
                    
                    
                }
                
                ToolbarItem(placement:.navigationBarTrailing){
                    
                    NavigationLink {
                        InspireView(profilevm: profilevm)
                    } label: {
                        Image(systemName: "sparkles")
                    }
                }
            }
            
            
                
                
                Button {
                    isShowingCreateView.toggle()
                } label: {
                    Image(systemName: "plus.circle")
                        .font(.title)
                        .foregroundColor(.pink)
                        .padding(.bottom, 40)
                        .padding(.trailing, 40)
                }

            
                
            
        }
            
        }
        .fullScreenCover(isPresented: $isShowingCreateView) {
            CreateView(momentvm: momentvm, todovm: todovm, personvm: personvm, branchvm: branchvm)
        }
        //        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        TimelineView(timelineManger: TimelineManager(), momentvm: MomentViewModel(), todovm: TodoViewModel(), personvm: PersonViewModel(), dataLinkedManager: DataLinkedManager(), searchvm: SearchViewModel(), tagPanelvm: TagPanelViewModel(), branchvm: BranchViewModel(), profilevm: ProfileViewModel())
            .preferredColorScheme(.light)
            .environment(\.sizeCategory, .extraSmall)
    }
}
