//
//  TagItemView.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/20.
//

import SwiftUI

struct TagCollectionView: View {
    
    @ObservedObject var tagvm: TagViewModel
    
    @State var tagNamesInRows:[[String]]
    
    
    
    init(tagvm:TagViewModel){
        self.tagvm = tagvm
        self._tagNamesInRows = State(initialValue: tagvm.getTagNamesByRows(tagNames: tagvm.tagNames))
    }
    var body: some View {

                VStack(alignment: .leading, spacing: 10) {
                    
                    // Displaying Tags.....
                    
                    ForEach($tagNamesInRows,id: \.self){tagNamesInRow in
                        
                        HStack(spacing: 6){
                            
                            ForEach(tagNamesInRow){ tagName in
                                
                                // Row View....
                                TagItemView(tagName: tagName.wrappedValue)

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
