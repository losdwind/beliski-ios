//
//  CarouselView.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/30.
//

import SwiftUI

struct CarouselView: View {
    
    @Binding var branchs:[Branch]
    @State var selection: Int = 1
    let maxCount: Int = 8
    @State var timerAdded: Bool = false
    
    var body: some View {
        withAnimation(.default) {
            TabView(selection: $selection,
                    content:  {
                        ForEach(branchs) { branch in
                            BranchCardView(branch: branch)
                        }
                    })
                .tabViewStyle(PageTabViewStyle())
                .frame(height: 300)
                .onAppear(perform: {
                    if !timerAdded {
                        addTimer()
                    }
                })
        }
     
    }
    
    // MARK: FUNCTIONS
    
    func addTimer() {
        
        timerAdded = true
        let timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { (timer) in
            
            if selection == (maxCount - 1) {
                selection = 1
            } else {
                selection += 1
            }
        }
        
        timer.fire()
        
    }
}

struct CarouselView_Previews: PreviewProvider {
    @State static var branchs = [Branch]()
    static var previews: some View {
        CarouselView(branchs: $branchs)
            .previewLayout(.sizeThatFits)
    }
}
