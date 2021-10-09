//
//  PanelView.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/8.
//

import SwiftUI

struct PanelView: View {
    
    @StateObject var profilevm =  ProfileViewModel()
    
    var body: some View {
        NavigationView{
            
            VStack(alignment:.center){
                
                NavigationLink {
                    ProfileDetailView(profilevm: profilevm)
                } label: {
                    ProfileCompactView(profilevm: profilevm)
                }

                ScoreView()
                
                Spacer()
            }
        }

    }
}

struct PanelView_Previews: PreviewProvider {
    static var previews: some View {
        PanelView()
    }
}
