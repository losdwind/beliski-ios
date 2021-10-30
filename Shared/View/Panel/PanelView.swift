//
//  PanelView.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/8.
//

import SwiftUI




struct PanelView: View {
    @ObservedObject var profilevm:ProfileViewModel
    @State var isShowingSettingsView:Bool = false
    @State var isShowingProfileDetailView:Bool = false
    
    @State var selectedTab:WellbeingTab = .Career
    var body: some View {
        NavigationView{
            Form {
                Section{
                    
                    
                        
                    HStack{
                        Text("Open")
                            .font(.title3.bold())
                            .foregroundColor(Color.pink)
                        
                        Spacer()
                        OpenStatsBarView(profilevm: profilevm)

                    }
                        
                    HStack{
                        Text("Private")
                            .font(.title3.bold())
                            .foregroundColor(Color.pink)
                        
                        Spacer()
                        PrivateStatsBarView(profilevm: profilevm)

                    }
                    
                        
                    
                }header: {
                    Text("Abstract")
                        .font(.title3.bold())
                        .frame(maxWidth: .infinity,alignment: .leading)

                }

                
                
                Section {
                    
                    WBScoreView()
                    
                } header: {
                    Text("Wellbeing Index")
                        .font(.title3.bold())
                        .frame(maxWidth: .infinity,alignment: .leading)

                }
                
                Picker("Filter", selection:$selectedTab){
                    // Todo: - check the WellbeingTab Enum
                    Text("Career").tag(WellbeingTab.Career)
                        .foregroundColor(selectedTab == WellbeingTab.Career ? .blue : .pink)
                    Text("Social").tag(WellbeingTab.Social)
                        .foregroundColor(selectedTab == WellbeingTab.Social ? .blue : .pink)
                    Text("Physical").tag(WellbeingTab.Physical)
                        .foregroundColor(selectedTab == WellbeingTab.Physical ? .blue : .pink)
                    Text("Financial").tag(WellbeingTab.Financial)
                        .foregroundColor(selectedTab == WellbeingTab.Financial ? .blue : .pink)
                    Text("Community").tag(WellbeingTab.Community)
                        .foregroundColor(selectedTab == WellbeingTab.Community ? .blue : .pink)
                }
                .pickerStyle(.segmented)
                
                //: Tabview
                TabView(selection: $selectedTab) {
                    
                    CareerAbstractView().tag(WellbeingTab.Career)
                    SocialAbstractView().tag(WellbeingTab.Social)
                    PhysicalAbstractView().tag(WellbeingTab.Physical)
                    FinancialAbstractView().tag(WellbeingTab.Financial)
                    CommunityAbstractView().tag(WellbeingTab.Community)
                        
                    
                }
                .tabViewStyle(PageTabViewStyle())
               
                
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        isShowingSettingsView.toggle()
                    } label: {
                        Image(systemName: "gearshape")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isShowingProfileDetailView.toggle()
                    } label: {
                        ProfileAvatarView(profileImageURL: profilevm.user.profileImageUrl)
                    }
                }
            }
            .sheet(isPresented: $isShowingSettingsView) {
                SettingsView(profilevm: profilevm)
            }
            .sheet(isPresented: $isShowingProfileDetailView) {
                ProfileDetailView(profilevm: profilevm)
            }

        }
        
    }
}

struct PanelView_Previews: PreviewProvider {
    static var previews: some View {
        PanelView(profilevm: ProfileViewModel())
    }
}
