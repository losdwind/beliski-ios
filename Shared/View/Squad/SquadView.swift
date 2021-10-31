//
//  SquadView.swift
//  Beliski-Firebase
//
//  Created by Wind Losd on 2021/9/17.
//

import SwiftUI

struct SquadView: View {
    
    @ObservedObject var branchvm:BranchViewModel
    @ObservedObject var dataLinkedManager: DataLinkedManager
    
    
    var body: some View {
        NavigationView{
            ScrollView(.vertical, showsIndicators: false){
                
                VStack{
                    
                    Text("Joined")
                        .font(.title3.bold())
                        .frame(maxWidth: .infinity,alignment: .leading)
                    
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack{
                            ForEach(branchvm.fetchedBranches, id: \.self) { branch in
                                NavigationLink{
                                    ChatView()
                                } label: {
                                    SquadCardView(branch: branch)
                                }
                            }
                            
                        }
                    }
                    
                    
                    Text("Subscribed")
                        .font(.title3.bold())
                        .frame(maxWidth: .infinity,alignment: .leading)
                    
                    VStack{
                        ForEach(branchvm.fetchedBranches, id: \.self) { branch in
                            NavigationLink{
                                LinkedItemsView(dataLinkedManager: dataLinkedManager)
                            } label: {
                                BranchCardView(branch: branch)
                            }
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
            .navigationTitle("Squad")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct SquadView_Previews: PreviewProvider {
    static var previews: some View {
        SquadView(branchvm: BranchViewModel(), dataLinkedManager: DataLinkedManager())
    }
}
