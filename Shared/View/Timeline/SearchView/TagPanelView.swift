//
//  TagPanelView.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/20.
//

import SwiftUI

struct TagPanelView: View {
    @ObservedObject var tagPanelvm:TagPanelViewModel
    @State var selectedTagName:String = ""
    var body: some View {
        VStack(alignment: .leading, spacing: 10){
            if tagPanelvm.fetchedAllTags == nil {
                ProgressView(value: 0)
            } else {
                Picker("Tag:", selection: $selectedTagName) {
                    
                    // All tags
                    HStack(alignment: .center, spacing: 40){
                        Text("All")
                        Spacer()
                        Text(String("99+"))
                        
                    }
                    .tag("All")
                    .foregroundColor(.primary)
                    
                    // Single tag
                    ForEach(tagPanelvm.fetchedAllTags!, id: \.self){tag in
                        HStack(alignment: .center, spacing: 40){
                            Text(tag.name)
                            Spacer()
                            Text(String(tag.linkedID.count))
                            
                        }
                        .tag(tag.name)
                        .foregroundColor(.primary)
                        
                }
                    

                }
                .pickerStyle(.wheel)
                .frame(height:100)
                .clipped()
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
