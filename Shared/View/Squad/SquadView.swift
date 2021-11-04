//
//  SquadView.swift
//  Beliski-Firebase
//
//  Created by Wind Losd on 2021/9/17.
//

import SwiftUI

struct SquadView: View {
    
    @ObservedObject var squadvm: SquadViewModel
    @ObservedObject var dataLinkedManager: DataLinkedManager
    
    
    var body: some View {
        NavigationView{
            ScrollView(.vertical, showsIndicators: false){
                
                VStack{
                    
                    Text("Your Squads")
                        .font(.title3.bold())
                        .frame(maxWidth: .infinity,alignment: .leading)
                    
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack{
                            ForEach(squadvm.fetchedOnInviteBranches, id: \.self) { branch in
                                NavigationLink{
                                    ChatView(squadvm: squadvm)
                                } label: {
                                    SquadCardView(branch: branch, squadvm: squadvm)
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
                    
                    
                    
                    
                    
                }

                
            }
            .padding()
            .navigationTitle("Squad")
            .onAppear {
                squadvm.fetchOnInviteBranches { success in
                    if success {
                        print("successfully fetched the invited branches")
                        
                    } else {
                        print("failed to fetch the inivted branches")
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct SquadView_Previews: PreviewProvider {
    static var previews: some View {
        SquadView(squadvm: SquadViewModel(), dataLinkedManager: DataLinkedManager())
    }
}
