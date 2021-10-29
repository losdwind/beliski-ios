//
//  SquadView.swift
//  Beliski-Firebase
//
//  Created by Wind Losd on 2021/9/17.
//

import SwiftUI

struct SquadView: View {
    
    @ObservedObject var branchvm:BranchViewModel
    
    
    
    var body: some View {
        NavigationView{
            ScrollView(.vertical, showsIndicators: false){
                
                
                LazyVStack{
                    ForEach(branchvm.fetchedBranches, id: \.self) { branch in
                        NavigationLink{
                            ChatView()
                        } label: {
                            BranchCardView(branch: branch)
                        }
                    }
                    
                }
                
            }
            .padding()
            
            .onAppear {
                branchvm.fetchBranchs { success in
                    if success {
                        print("successfully fetched the branches")
                    }
                }
            }
        }
    }
}

struct SquadView_Previews: PreviewProvider {
    static var previews: some View {
        SquadView(branchvm: BranchViewModel())
    }
}
