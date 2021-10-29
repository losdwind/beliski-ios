//
//  ScoreView.swift
//  Beliski-Firebase
//
//  Created by Wind Losd on 2021/9/17.
//

import SwiftUI

struct WBScoreView: View {
    
    var body: some View {
        
        VStack {
            // segement: wellbeing index
            HStack(alignment: .center, spacing: 30){
                VStack(alignment:.center, spacing: 20){
                    Text("726")
                        .font(.largeTitle)
                        .foregroundColor(.primary)
                    Text("Wellbeing Index")
                        .font(.headline.bold())
                        .foregroundColor(Color.pink)
                        
                }
                
                
                VStack(alignment:.leading, spacing: 5){
                    HStack(alignment: .center){
                        Text("Career")
                            .font(.subheadline)
                        Spacer()
                        Text("145")
                            .font(.body)
                    }
                    
                    HStack(alignment: .center){
                        Text("Social")
                            .font(.subheadline)
                        Spacer()
                        Text("133")
                            .font(.body)
                    }
                    
                    HStack(alignment: .center){
                        Text("Physical")
                            .font(.subheadline)
                        Spacer()
                        Text("178")
                            .font(.body)
                    }
                    
                    HStack(alignment: .center){
                        Text("Financial")
                            .font(.subheadline)
                        Spacer()
                        Text("108")
                            .font(.body)
                    }
                    
                    HStack(alignment: .center){
                        Text("Community")
                            .font(.subheadline)
                        Spacer()
                        Text("89")
                            .font(.body)
                    }
                }
                .frame(width: 150, height: 100)
                            
            }
            

        }
        .padding()
    }
}

struct WBScoreView_Previews: PreviewProvider {
    static var previews: some View {
        WBScoreView()
    }
}
