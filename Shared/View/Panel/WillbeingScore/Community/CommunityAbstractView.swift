//
//  CommunityAbstractView.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/30.
//

import SwiftUI

struct CommunityAbstractView: View {
    
    private var analytics:[Analytics] = analyticsData
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
  
                HStack(spacing: 0){
                    
                    // Progress View...
                    UserProgressView(title: "Male", color: Color.blue, image: "person", progress: 79)
                    UserProgressView(title: "Female", color: Color.pink, image: "person", progress: 21 )

                }
                .padding()
                .background(Color.white)
                .cornerRadius(18)
            }
        }
}

struct CommunityAbstractView_Previews: PreviewProvider {
    static var previews: some View {
        CommunityAbstractView()
    }
}
