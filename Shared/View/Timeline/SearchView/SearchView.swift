//
//  SearchJournalView.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/15.
//

import SwiftUI

struct SearchView: View {
    
    @ObservedObject var searchvm:SearchViewModel
    @ObservedObject var tagPanelvm:TagPanelViewModel
    
    var body: some View {
        ScrollView{
        VStack(alignment: .center, spacing: 20){
            
            
            HStack(alignment: .center, spacing: 20){
                TextField("Search", text: $searchvm.keywords, prompt: Text("Put a keyword here"))
                    .foregroundColor(.primary)
                    
                Button {
                    searchvm.fetchIDsFromFilter { _ in }
                } label: {
                    Image(systemName: "magnifyingglass")
                }
            }
            
            DatePicker("Start Date", selection: $searchvm.dateStart)
            DatePicker("End Date", selection: $searchvm.dateEnd)

            
            
            TagPanelView(tagPanelvm: tagPanelvm)
                .background(Color.pink)
            
            SearchResultView(searchvm: searchvm)
                .background(Color.blue)

            
        }
        .padding()
        .foregroundColor(.primary)
        
        
    }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(searchvm: SearchViewModel(), tagPanelvm: TagPanelViewModel())
    }
}
