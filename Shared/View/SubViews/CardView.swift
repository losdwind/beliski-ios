//
//  CardView.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/30.
//

import SwiftUI

// Card View..
@ViewBuilder
func CardView(image: String,title: String,price: String,color: Color)->some View{
    
    VStack(spacing: 15){
        
        Image(image)
            .resizable()
            .renderingMode(.template)
            .aspectRatio(contentMode: .fit)
            .foregroundColor(.white)
            .frame(width: 35, height: 35)
            .padding()
            .background(color,in: Circle())
        
        Text(title)
            .font(.title3.bold())
        
        Text(price)
            .fontWeight(.semibold)
            .foregroundColor(.gray)
    }
    .padding(.vertical)
    .padding(.horizontal,25)
    .background(.white,in: RoundedRectangle(cornerRadius: 15))
    // shadows...
    .shadow(color: .black.opacity(0.05), radius: 5, x: 5, y: 5)
    .shadow(color: .black.opacity(0.03), radius: 5, x: -5, y: -5)
}

