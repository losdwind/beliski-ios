//
//  ChatView.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/28.
//

import SwiftUI

struct ChatView: View {
    
    var branch:Branch
    @ObservedObject var squadvm: SquadViewModel
    
    
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(squadvm.fetchedMessages) { message in
                        
                        MessageView(message: message)
                    }
                }
            }.padding(.top)
            
            InputMessageView(squadvm: squadvm)
                .padding()
            
        }
        .onAppear {
            squadvm.currentBranch = branch
            squadvm.getMessages(branch: branch) { success in
                if success {
                    print("successfully get the messages")
                } else{
                    print("error to get related messages")
                }
            }
        }

    }
        
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(branch: Branch(), squadvm: SquadViewModel())
    }
}
