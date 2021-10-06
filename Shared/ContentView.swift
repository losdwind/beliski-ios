//
//  ContentView.swift
//  Shared
//
//  Created by Losd wind on 2021/10/6.
//

import SwiftUI

struct ContentView: View {
    
    @State var selectedTab = MainTab.timeline

    
    
    var body: some View {
        TabView(selection: $selectedTab){
            
            // Show the timeline of user journals
            JournalView()
                .tabItem{
                    Image(systemName: "text.redaction")
                }.tag(MainTab.timeline)
            
            // Show the Panel of statistics based on the journals of the user
            ScoreView()
                .tabItem {
                    Image(systemName: "chart.bar.xaxis")
                }.tag(MainTab.score)
            
            // Show the create launcher with multiple categories of journal type
            CreateView()
                .tabItem {
                    Image(systemName: "plus.circle")
                }.tag(MainTab.create)
            
            // Show community information and open journals shared by internet users
            SquadView()
                .tabItem{
                    Image(systemName: "circles.hexagongrid")
                }.tag(MainTab.squad)
            

            // Show team formed by connected users, message and personal profile
            CommunityView()
                .tabItem {
                    Image(systemName: "building.2")
                }.tag(MainTab.community)
            
        }
        .accentColor(.primary)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
