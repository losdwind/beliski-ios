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
        VStack{
            ScrollView {
                ScrollViewReader { value in
                    LazyVStack{
                        ForEach(squadvm.fetchedMessages) { message in
                            
                            MessageView(message: message)
                                .id(message.id)
                        }
                        .padding(.top)
                
                        .onChange(of: squadvm.fetchedMessages.count) { _ in
                            value.scrollTo(squadvm.fetchedMessages.last?.id)
                        } // https://stackoverflow.com/posts/67730429/edit
                
                    }
                }
                
                
                
                }
            
        
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
