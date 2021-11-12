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
            ScrollView(.vertical,showsIndicators: false) {
                
            
                                            
                
                    // MARK: Wellbeing Index
                VStack{
//                    Text("Wellbeing Index")
//                        .font(.title3.bold())
//                        .frame(maxWidth: .infinity,alignment: .leading)
//
                        WBScoreView()
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(18)
                    
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
                        
                        switch selectedTab {
                        case .Career:
                            CareerAbstractView().tag(WellbeingTab.Career)
                        case .Social:
                            SocialAbstractView().tag(WellbeingTab.Social)
                        case .Physical:
                            PhysicalAbstractView().tag(WellbeingTab.Physical)
                        case .Financial:
                            FinancialAbstractView().tag(WellbeingTab.Financial)
                        case .Community:
                            CommunityAbstractView().tag(WellbeingTab.Community)
                        }
                }

                    
                    
                    // Survey Result
                    VStack{
                        Text("Survey Results")
                            .font(.title3.bold())
                            .frame(maxWidth: .infinity,alignment: .leading)
                        ScrollView(.horizontal, showsIndicators: false){
                            HStack{
                                NavigationLink {
                                    VIAView()
                                } label: {
                                    CardView(image: "VIA", title: "VIA Character \nStrength Survey", price: "Free", color: Color.white)
                                }
                                
                                NavigationLink {
                                    MBTIView()
                                } label: {
                                    CardView(image: "mbti", title: "Myers-Briggs \nType Indicator", price: "Free", color: Color.white)
                                }

                                NavigationLink {
                                    BigFiveView()
                                } label: {
                                    CardView(image: "bigfive", title: "Big Five \npersonality traits", price: "Free", color: Color.white)
                                }

                                
                            }
                            .padding()
                            
                            
                        }
                            
                        
                    }
               
                
                
            }
            .padding()
            
            .navigationTitle("Dashboard")
            
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        isShowingSettingsView.toggle()
                    } label: {
                        Image(systemName: "gear.circle")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isShowingProfileDetailView.toggle()
                    } label: {
                        ProfileAvatarView(profileImageURL: profilevm.user.profileImageURL)
                    }
                }
            }
            .sheet(isPresented: $isShowingSettingsView) {
                SettingsView(profilevm: profilevm)
            }
            .sheet(isPresented: $isShowingProfileDetailView) {
                ProfileDetailView(profilevm: profilevm)
            }
            .onAppear {
                profilevm.fetchCurrentUser { success in
                    print("successfully fetched current user profile")
                }
            }

        }
//        .navigationViewStyle(StackNavigationViewStyle())
        
    }
}

struct PanelView_Previews: PreviewProvider {
    static var previews: some View {
        PanelView(profilevm: ProfileViewModel())
            .preferredColorScheme(.light)
    }
}


struct TabButton: View{
    @Binding var currentTab: String
    var title: String
    // For bottom indicator slide Animation...
    var animationID: Namespace.ID
    
    var body: some View{
        
        Button {
            
            withAnimation(.spring()){
                currentTab = title
            }
            
        } label: {
            
            VStack{
                
                Text(title)
                    .fontWeight(.semibold)
                    .foregroundColor(currentTab == title ? .black : .gray)
                
                if currentTab == title{
                    Rectangle()
                        .fill(.black)
                        .matchedGeometryEffect(id: "TAB", in: animationID)
                        .frame(width: 50, height: 1)
                }
                else{
                    Rectangle()
                        .fill(.clear)
                        .frame(width: 50, height: 1)
                }
            }
            // Taking Available Width...
            .frame(maxWidth: .infinity)
        }

    }
}

