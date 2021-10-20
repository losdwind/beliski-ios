//
//  TagItemView.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/20.
//

import SwiftUI

struct TagCollectionView: View {
    
    var tagIDs: [String]
    @StateObject var tagvm: TagViewModel = TagViewModel()
    
    var body: some View {

                VStack(alignment: .leading, spacing: 10) {
                    
                    // Displaying Tags.....
                    
                    ForEach(tagvm.getTagsByRows(),id: \.self){TagsInRow in
                        
                        HStack(spacing: 6){
                            
                            ForEach(TagsInRow){ tag in
                                
                                // Row View....
                                TagItemView(tag: tag)
                            }
                        }
                    }
                }
                .frame(width: UIScreen.main.bounds.width - 80,alignment: .leading)
                .padding(.vertical)
                .padding(.bottom,20)
                .frame(maxWidth: .infinity)
                .background(
                
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(Color.red.opacity(0.15),lineWidth: 1)
                )
                .onAppear {
                    tagvm.fetchTags(from: tagIDs) { _ in }
                }

    }
}

struct TagItemView_Previews: PreviewProvider {
    static var previews: some View {
        TagCollectionView(tagIDs: [""])
    }
}
