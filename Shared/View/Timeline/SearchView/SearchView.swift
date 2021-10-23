//
//  SearchJournalView.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/15.
//

import SwiftUI

struct SearchView: View {
    
    @ObservedObject var searchvm:SearchViewModel
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 20){
            
            
            HStack(alignment: .center, spacing: 20){
                TextEditor(text: $searchvm.keywords)
                    .foregroundColor(.primary)
                Button {
                    searchvm.fetchIDsFromFilter { _ in }
                } label: {
                    Image(systemName: "magnifyingglass")
                }
            }
            
            TagPanelView()
            
            SearchResultView(searchvm: searchvm)

            
            
        }
        
        
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(searchvm: SearchViewModel())
    }
}
