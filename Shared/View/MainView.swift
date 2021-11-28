//
//  ContentView.swift
//  Shared
//
//  Created by Losd wind on 2021/10/6.
//

import SwiftUI
import FirebaseAuth

struct MainView: View {
    
    @State var selectedTab = MainTab.create
    @State var email:String = ""
    @State var password: String = ""
    
    @StateObject var profilevm = ProfileViewModel()
    @StateObject var journalvm = JournalViewModel()
    @StateObject var todovm = TodoViewModel()
    @StateObject var personvm = PersonViewModel()
    @StateObject var timelineManager = TimelineManager()
    @StateObject var dataLinkedManager = DataLinkedManager()
    @StateObject var searchvm = SearchViewModel()
    @StateObject var tagPanelvm = TagPanelViewModel()
    @StateObject var branchvm = BranchViewModel()
    @StateObject var communityvm = CommunityViewModel()
    @StateObject var squadvm = SquadViewModel()
    
    @AppStorage("userID") var userID: String?

    
    var body: some View {
        if userID == nil {
            SignInView()
        } else {
            TabView(selection: $selectedTab){
                
                // Show the timeline of user journals
                TimelineView(timelineManger: timelineManager, journalvm: journalvm, todovm: todovm, personvm: personvm, dataLinkedManager: dataLinkedManager, searchvm:searchvm, tagPanelvm: tagPanelvm, branchvm: branchvm, profilevm: profilevm)
                    .tabItem{
                        VStack{
                            Image(systemName: "text.redaction")
                            Text("Timeline")
                        }
                    }.tag(MainTab.timeline)
                    
                // Show the Panel of statistics based on the journals of the user
                PanelView(profilevm: ProfileViewModel())
                    .tabItem {
                        VStack{
                            Image(systemName: "chart.bar.xaxis")
                            Text("Score")
                        }
                        
                    }.tag(MainTab.score)
                
  
                
                // Show community information and open journals shared by internet users
                SquadView(squadvm: squadvm, dataLinkedManager: dataLinkedManager)
                    .tabItem{
                        VStack{
                            Image(systemName: "circles.hexagongrid")
                            Text("Squad")
                        }
                        
                    }.tag(MainTab.squad)
                
                
                // Show team formed by connected users, message and personal profile
                CommunityView(communityvm: communityvm, dataLinkedManager: dataLinkedManager)
                    .tabItem {
                        VStack{
                            Image(systemName: "building.2")
                            Text("Community")
                        }
                        
                    }.tag(MainTab.community)
                
            }
            .accentColor(.pink)
            .onAppear {
                personvm.fetchPersons{ success in
                    if success {
                        print("successfully loaded the persons from firebase")
                    } else {
                        print("failed to load the persons from firebase")
                    }
                }
            }
            .onAppear {
                journalvm.fetchJournals { success in
                    if success {
                        print("successfully loaded the journals from firebase")
                    } else {
                        print("failed to load the journals from firebase")
                    }
                }
            }
            .onAppear(perform:{
                todovm.fetchTodos(handler: {
                    success in
                    if success {
                        print("successfully fetched the todos from firebase ")
                    } else {
                        print("failed to fetched the todos from firebase")
                    }
                })
            }
            )
            

        }
        
    
        
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
