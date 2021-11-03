//
//  SquadView.swift
//  Beliski-Firebase
//
//  Created by Wind Losd on 2021/9/17.
//

import SwiftUI

struct SquadView: View {
    
    @ObservedObject var branchvm:BranchViewModel
    @ObservedObject var squadvm: SquadViewModel
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
                            ForEach(squadvm.fetchedOnInviteBranches, id: \.self) { branch in
                                NavigationLink{
                                    ChatView(squadvm: squadvm)
                                } label: {
                                    SquadCardView(branch: branch)
                                }
                                .onTapGesture {
                                    squadvm.currentBranch = branch
                                    squadvm.fetchProfilesAndMessages(branch: branch) { success in
                                        if success {
                                            print("successfully get the messages")
                                        } else{
                                            print("error to get related messages")
                                        }
                                    }
                                }
                            }
                            
                        }
                    }
                    
                    
                    Text("Subscribed")
                        .font(.title3.bold())
                        .frame(maxWidth: .infinity,alignment: .leading)
                    
                    VStack{
                        ForEach($branchvm.fetchedAllBranches, id: \.self) { branch in
                            NavigationLink{
                                LinkedItemsView(dataLinkedManager: dataLinkedManager)
                            } label: {
                                BranchCardView(branch: branch.wrappedValue)
                            }
                        }
                        
                    }
                    
                    
                }

                
            }
            .padding()
            
            .onAppear {
                branchvm.fetchAllBranchs { success in
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
        SquadView(branchvm: BranchViewModel(), squadvm: SquadViewModel(), dataLinkedManager: DataLinkedManager())
    }
}
