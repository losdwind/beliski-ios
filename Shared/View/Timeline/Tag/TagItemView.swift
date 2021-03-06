//
//  TagItemRowView.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/20.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct TagItemView: View {
    
    var tagName: String
    
    @Namespace var animation
    
    var body: some View {
        Text("#" + tagName)
        // applying same font size..
        // else size will vary..
            .font(.footnote.bold())
        // adding capsule..
//            .background(
//
//                Capsule()
//                    .fill(Color.pink)
//            )
            .foregroundColor(Color.pink)
            .lineLimit(1)
        // Delete...
//            .contentShape(Capsule())
            .matchedGeometryEffect(id: UUID(uuidString: tagName), in: animation)
    }
}

struct TagItemRowView_Previews: PreviewProvider {
    static var tagName = "great"
    static var previews: some View {
        TagItemView(tagName: tagName)
    }
}
