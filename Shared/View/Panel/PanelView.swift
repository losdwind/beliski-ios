//
//  PanelView.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/8.
//

import SwiftUI

struct PanelView: View {
        
    var body: some View {
        NavigationView{
            
            VStack(alignment:.center){
                
                NavigationLink {
                    ProfileDetailView()
                } label: {
                    ProfileCompactView()
                }
                NavigationLink{
                    Text("here is the detail view of wellbeing index")
                } label: {
                    ScoreView()
                }
            }
            

        }
        
    }
}

struct PanelView_Previews: PreviewProvider {
    static var previews: some View {
        PanelView()
    }
}
