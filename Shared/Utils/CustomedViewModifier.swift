//
//  CustomedViewModifier.swift
//  Beliski
//
//  Created by Wind Losd on 2021/5/23.
//

import SwiftUI

struct NewButtonGradientBackground: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
            .background(
              LinearGradient(gradient: Gradient(colors: [Color.pink, Color.blue]), startPoint: .leading, endPoint: .trailing)
                .clipShape(Capsule())
            )
            .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 8, x: 0.0, y: 4.0)
            
    }
}


struct SaveButtonBackground: ViewModifier {
    
    let isButtonDisabled: Bool
    
    
    func body(content: Content) -> some View {
        content
            .disabled(isButtonDisabled)
            .onTapGesture {
              if isButtonDisabled {
                playSound(sound: "sound-tap", type: "mp3")
              }
            }
            .padding()
            .foregroundColor(.white)
            .background(isButtonDisabled ? Color.blue : Color.pink)
            .cornerRadius(10)
        
    }
}


struct GradientButtonStyle: ButtonStyle {
    let isSelected: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            
    }
}
