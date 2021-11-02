//
//  ChatView.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/28.
//

import SwiftUI

struct ChatView: View {
    @ObservedObject var squadvm: SquadViewModel
    
    init(squadvm:SquadViewModel, branch:Branch){
        squadvm.branch = branch
    }
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(squadvm.fetchedMessages) { message in
                        MessageView(message: message, squadvm: squadvm)
                    }
                }
            }.padding(.top)
            
            InputMessageView(squadvm: squadvm)
                .padding()
            
        }.navigationTitle(user.username)

    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
