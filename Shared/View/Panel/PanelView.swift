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
    
    var body: some View {
        NavigationView{
            ScrollView(.vertical, showsIndicators: false){
                VStack(alignment:.center){
                    
                    NavigationLink {
                        ProfileDetailView()
                    } label: {
                        ProfileCompactView(profilevm: profilevm)
                    }
                    
                    NavigationLink{
                        Text("here is the detail view of wellbeing index")
                    } label: {
                        WBScoreView()
                    }
                }
                .frame(alignment: .topLeading)
                .navigationTitle("Panel")
                .navigationBarTitleDisplayMode(.inline)
               
                
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isShowingSettingsView.toggle()
                    } label: {
                        Image(systemName: "gearshape")
                    }
                }
            }
            .sheet(isPresented: $isShowingSettingsView) {
                SettingsView()
            }

        }
        
    }
}

struct PanelView_Previews: PreviewProvider {
    static var previews: some View {
        PanelView(profilevm: ProfileViewModel())
    }
}
