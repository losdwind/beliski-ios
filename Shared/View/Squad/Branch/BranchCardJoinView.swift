//
//  BranchCardJoinView.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/28.
//

import SwiftUI

struct BranchCardJoinView: View {
    var body: some View {
        
        
        Button {
            branchvm.isShowingJoinView.toggle()
        } label: {
            Text("Join")
                .foregroundColor(.black)
                .padding(.horizontal,10)
        }
        .buttonStyle(.bordered)
        .controlSize(.small)
        .tint(.white)
        .shadow(radius: 1.2)
    }
}

struct BranchCardJoinView_Previews: PreviewProvider {
    static var previews: some View {
        BranchCardJoinView()
    }
}
