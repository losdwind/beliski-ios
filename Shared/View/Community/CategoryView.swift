//
//  CategoryView.swift
//  Beliski
//
//  Created by Losd wind on 2021/11/2.
//

import SwiftUI


let category = [
    ["Creation", "Competetion", "Startup"],
    ["Discussion", "Perfection", "Idol"],
    ["Hobby", "Game", "Study"]
    
]

struct CategoryView: View {
    
    @ObservedObject var communityvm:CommunityViewModel
    @ObservedObject var dataLinkedManager: DataLinkedManager
    
    var body: some View {
            
        // MARK: Category Grid
            VStack(alignment: .center, spacing: 5){
                ForEach(category, id:\.self){ cate in
                    HStack(alignment: .bottom){
                        ForEach(cate, id:\.self){ c in
                            NavigationLink {
                                PopularBranchView(communityvm: communityvm, dataLinkedManager: dataLinkedManager)
                            } label: {
                                Button {
                                    communityvm.selectedCategory = c
                                } label: {
                                    VStack(alignment: .center){
                                        Image(c)
                                            .renderingMode(.original)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 30.0, height: 30.0)
                                        
                                        Text(c)
                                            .font(.footnote)
                                            .fontWeight(.regular)
                                            .foregroundColor(Color.accentColor)
                                        
                                        
                                    }
                                    .frame(width: 100.0, height: 70.0)

                                }
                            }

                            
                        }
                        
                    }
                      
                }
                
                
                
            }
            
  
            
            
        
    }
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView(communityvm: CommunityViewModel(), dataLinkedManager: DataLinkedManager())
    }
}
