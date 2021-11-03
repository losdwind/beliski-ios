//
//  ChatView.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/28.
//

import SwiftUI

struct ChatView: View {
    @ObservedObject var squadvm: SquadViewModel
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(squadvm.fetchedMessagesAndProfiles.keys) { message in
                        
                        MessageView(message: message , user: squadvm.fetchedMessagesAndProfiles[message] ?? User())
                    }
                }
            }.padding(.top)
            
            InputMessageView(squadvm: squadvm)
                .padding()
            
        }

    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(squadvm: SquadViewModel())
    }
}
