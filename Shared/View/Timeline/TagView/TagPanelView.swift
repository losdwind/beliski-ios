//
//  TagPanelView.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/20.
//

import SwiftUI

struct TagPanelView: View {
    @StateObject var tagpanvm:TagViewModel = TagViewModel()
    var body: some View {
        List(tagpanvm.fetchedTags){
            tag in
            TagItemView(tagvm: tagpanvm, tag: tag)
        }
    }
}

struct TagPanelView_Previews: PreviewProvider {
    static var previews: some View {
        TagPanelView()
    }
}
