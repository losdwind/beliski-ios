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
        VStack(alignment: .leading, spacing: 10){
            if tagPanelvm.fetchedAllTags == nil {
                ProgressView(value: 0)
            } else {
                List{
                    ForEach(tagPanelvm.fetchedAllTags!, id: \.self){tag in
                        HStack(alignment: .center, spacing: 40){
                            Text(tag.name)
                            Spacer()
                            Text(String(tag.linkedID.count))
                            
                        }
                        .foregroundColor(.primary)
                        .frame(maxWidth:200)
                        
                    }
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
