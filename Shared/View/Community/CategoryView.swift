//
//  CategoryView.swift
//  Beliski
//
//  Created by Losd wind on 2021/11/2.
//

import SwiftUI




struct CategoryView: View {
    
    @ObservedObject var communityvm:CommunityViewModel
    @ObservedObject var dataLinkedManager: DataLinkedManager
    var columns: [GridItem] =
             Array(repeating: .init(.flexible()), count: 3)
    var body: some View {
            
        // MARK: Category Grid

        LazyVGrid(columns: columns) {
            ForEach(categoryOfBranch.allCases, id:\.self){
                cate in
                NavigationLink {
                    PopularBranchView(communityvm: communityvm, dataLinkedManager: dataLinkedManager)
                } label: {
                    Button {
                        communityvm.selectedCategory = cate
                    } label: {
                        VStack(alignment: .center){
                            Image(cate.rawValue)
                                .renderingMode(.original)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30.0, height: 30.0)
                            
                            Text(cate.rawValue)
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

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView(communityvm: CommunityViewModel(), dataLinkedManager: DataLinkedManager())
    }
}
