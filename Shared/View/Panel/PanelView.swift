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
                    
                    ProfileSimpleView(profilevm: profilevm)
                    
                    GroupBox{
                        WBScoreView()
                            .padding()
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
                SettingsView(profilevm: profilevm)
            }

        }
        
    }
}

struct PanelView_Previews: PreviewProvider {
    static var previews: some View {
        PanelView(profilevm: ProfileViewModel())
    }
}
