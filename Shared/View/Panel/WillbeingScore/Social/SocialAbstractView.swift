//
//  SocialAbstract.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/30.
//

import SwiftUI

struct SocialAbstractView: View {
    private var analytics:[Analytics] = analyticsData
    var body: some View {
        VStack(alignment:.leading){
            Text("Activeness")
                .font(.title.bold())
                .foregroundColor(.black)
            
            Text("Messages in Squad")
                .font(.callout)
                .foregroundColor(.gray)
            BarGraph(analytics: analytics)
        }
    }
}

struct SocialAbstract_Previews: PreviewProvider {
    static var previews: some View {
        SocialAbstractView()
            .previewLayout(.sizeThatFits)
    }
}
