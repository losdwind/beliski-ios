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
        ScrollView{
            
        // MARK: Category Grid
            VStack(alignment: .center, spacing: 5){
                ForEach(category, id:\.self){ cate in
                    HStack(alignment: .bottom){
                        ForEach(cate, id:\.self){ c in
                            NavigationLink {
                                BranchCardPublicListView(communityvm: communityvm, dataLinkedManager: dataLinkedManager)
                            } label: {
                                Button {
                                    communityvm.selectedCategory = c
                                } label: {
                                    VStack(alignment: .center){
                                        Image(c)
                                            .renderingMode(.original)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 40.0, height: 40.0)
                                        
                                        Text(c)
                                            .font(.headline)
                                            .fontWeight(.regular)
                                            .foregroundColor(Color.primary)
                                        
                                        
                                    }
                                    .frame(width: 100.0, height: 100.0)

                                }
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
