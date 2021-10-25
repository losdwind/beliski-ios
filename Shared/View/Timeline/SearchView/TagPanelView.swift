//
//  TagPanelView.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/20.
//

import SwiftUI

struct TagPanelView: View {
    @ObservedObject var tagPanelvm:TagPanelViewModel
    
    var body: some View {
        List{
            ForEach(tagPanelvm.fetchedAllTags, id: \.self){tag in
                HStack(alignment: .center, spacing: 40){
                    Text(tag.name)
                        .foregroundColor(.primary)

                    Text(String(tag.linkedID.count))
                        .foregroundColor(.primary)

                }
            }
        }
        .onAppear {
            tagPanelvm.fetchAllTags(handler: {_ in})
        }

    }
}

struct TagPanelView_Previews: PreviewProvider {
    static var previews: some View {
        TagPanelView(tagPanelvm: TagPanelViewModel())
    }
}
