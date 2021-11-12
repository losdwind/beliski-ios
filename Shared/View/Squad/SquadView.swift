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
    @State var isShowingChatView:Bool = false
    
    var body: some View {
        NavigationView{
            ScrollView(.vertical, showsIndicators: false){
                
                
                    
                    Text("Your Squads")
                        .font(.title3.bold())
                        .frame(maxWidth: .infinity,alignment: .leading)
                    
                    
                    ForEach(squadvm.fetchedOnInviteBranches, id: \.self) { branch in
                        NavigationLink{
                            ChatView(branch:branch, squadvm: squadvm )
                        } label: {
                            SquadCardView(branch: branch, squadvm: squadvm)
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
        //        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct SquadView_Previews: PreviewProvider {
    static var previews: some View {
        SquadView(squadvm: SquadViewModel(), dataLinkedManager: DataLinkedManager())
    }
}
