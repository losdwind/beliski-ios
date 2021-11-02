//
//  InputMessageView.swift
//  Beliski
//
//  Created by Losd wind on 2021/11/2.
//

import SwiftUI

import SwiftUI

struct InputMessageView: View {
    
    
    @ObservedObject var squadvm:SquadViewModel
    
    
    var body: some View {
        VStack {
            Rectangle()
                .foregroundColor(Color(.separator))
                .frame(width: UIScreen.main.bounds.width, height: 0.75)
                .padding(.bottom, 8)
            
            HStack {
                TextField("Input here", text: $squadvm.message.content)
                    .textFieldStyle(PlainTextFieldStyle())
                    .font(.body)
                    .frame(minHeight: 30)
                
                Button{
                    squadvm.sendMessages(branch: squadvm.branch) { success in
                        if success {
                            squadvm.message = Message()
                        }
                    }
                } label: {
                    Text("Send")
                        .bold()
                        .foregroundColor(.black)
                }
                
                .padding(.bottom, 8)
                .padding(.horizontal)
            }
        }
    }
}


struct InputMessageView_Previews: PreviewProvider {
    static var previews: some View {
        InputMessageView(squadvm: SquadViewModel())
    }
}
