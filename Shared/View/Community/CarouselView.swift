//
//  CarouselView.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/30.
//

import SwiftUI

struct CarouselView: View {
    
    @Binding var branches:[Branch]
    @State var selection: Int = 0
    @State var timerAdded: Bool = false
    
    var body: some View {
            if branches.count > 0 {
                withAnimation(.default) {
                TabView(selection: $selection,
                        content:  {
                    
                    ForEach(0..<branches.count, id:\.self) { i in
                        BranchCardView(branch: branches[i]).tag(i)
                            }
                        })
                    .tabViewStyle(PageTabViewStyle())
                    .frame(height: 300)
                    .onAppear(perform: {
                        if !timerAdded {
                            addTimer(maxCount: branches.count)
                        }
                    })
            }
            
        }
     
    }
    
    // MARK: FUNCTIONS
    
    func addTimer(maxCount:Int) {
        
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
        CarouselView(branches: $branchs)
            .previewLayout(.sizeThatFits)
    }
}
