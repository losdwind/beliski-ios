//
//  ScoreView.swift
//  Beliski-Firebase
//
//  Created by Wind Losd on 2021/9/17.
//

import SwiftUI

struct ScoreView: View {
    
    var body: some View {
        
        VStack {
            // segement: wellbeing index
            HStack{
                VStack(alignment:.center, spacing: 20){
                    Text("726")
                        .font(.largeTitle)
                        .foregroundColor(.primary)
                    Text("Wellbeing Index")
                        .font(.headline)
                }
                
                VStack(alignment:.leading, spacing: 10){
                    HStack(alignment: .center, spacing: 40){
                        Text("Career")
                            .font(.subheadline)
                        Text("145")
                            .font(.body)
                    }
                    
                    HStack(alignment: .center, spacing: 40){
                        Text("Social")
                            .font(.subheadline)
                        Text("133")
                            .font(.body)
                    }
                    
                    HStack(alignment: .center, spacing: 40){
                        Text("Physical")
                            .font(.subheadline)
                        Text("178")
                            .font(.body)
                    }
                    
                    HStack(alignment: .center, spacing: 40){
                        Text("Financial")
                            .font(.subheadline)
                        Text("108")
                            .font(.body)
                    }
                    
                    HStack(alignment: .center, spacing: 40){
                        Text("Community")
                            .font(.subheadline)
                        Text("89")
                            .font(.body)
                    }
                }
                
            }
            

        }
    }
}

struct ScoreView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreView()
    }
}
