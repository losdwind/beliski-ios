//
//  BranchCardListView.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/31.
//

import SwiftUI

struct BranchCardListView: View {
    
    @ObservedObject var Branchvm:BranchViewModel
    
    @State var isShowingLinkedItemView = false
    @State var isShowingLinkView:Bool = false
    
    var body: some View {
        NavigationLink{
            
            ScrollView(.vertical, showsIndicators: false){
                
                VStack{
                    ForEach(branchvm.fetchedBranches, id: \.self) { branch in
                        NavigationLink{
                            LinkedItemsView(dataLinkedManager: dataLinkedManager)
                        } label: {
                            BranchCardView(branch: branch)
                        }
                        .onTapGesture {
                            isshowing
                        }
                    }
                    
                    
                }
                
            }
        }
        
    }
    
    struct BranchCardListView_Previews: PreviewProvider {
        static var previews: some View {
            BranchCardListView()
        }
    }
