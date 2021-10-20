//
//  TagItemRowView.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/20.
//

import SwiftUI

struct TagItemView: View {
    
    
    @ObservedObject var tagvm: TagViewModel
    var tag: Tag
    
    @Namespace var animation
    
    var body: some View {
        Text(tag.name)
        // applying same font size..
        // else size will vary..
            .font(.system(size: tagvm.fontSize))
        // adding capsule..
            .padding(.horizontal,14)
            .padding(.vertical,8)
            .background(
            
                Capsule()
                    .fill(Color.pink)
            )
            .foregroundColor(Color.primary)
            .lineLimit(1)
        // Delete...
            .contentShape(Capsule())
            .contextMenu{
                Button("Delete"){
                    // deleting...
                    tagvm.fetchedTags.remove(at: tagvm.getIndex(tag: tag, in :tagvm.fetchedTags))
                }
            }
            .matchedGeometryEffect(id: tag.id, in: animation)
    }
}

struct TagItemRowView_Previews: PreviewProvider {
    static var previews: some View {
        TagItemView(tag: Tag())
    }
}
