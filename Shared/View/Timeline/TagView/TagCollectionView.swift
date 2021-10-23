//
//  TagItemView.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/20.
//

import SwiftUI

struct TagCollectionView: View {
    
    @ObservedObject var tagvm: TagViewModel
     
    var body: some View {

                VStack(alignment: .leading, spacing: 10) {
                    
                    // Displaying Tags.....
                    
                    ForEach(tagvm.getTagsByRows(TagsofItemSet: tagvm.TagsofItem),id: \.self){TagsInRow in
                        
                        HStack(spacing: 6){
                            
                            ForEach(TagsInRow){ tag in
                                
                                // Row View....
                                TagItemView(tag: tag)

                            }
                        }
                    }
                }

    }
}

struct TagItemView_Previews: PreviewProvider {
    static var previews: some View {
        TagCollectionView(tagvm: TagViewModel())
    }
}
