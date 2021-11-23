//
//  FilterView.swift
//  Beliski
//
//  Created by Losd wind on 2021/11/10.
//

import SwiftUI



struct FilterView: View {
    @ObservedObject var tagPanelvm:TagPanelViewModel
    @ObservedObject var searchvm: SearchViewModel
    
    
    var body: some View {
        VStack(alignment:.leading) {
            
            
            
            
            // dates
            Text("Filt by Date")
                .font(.title3.bold())
                .frame(maxWidth: .infinity,alignment: .leading)
            
            VStack{
                DatePicker("Start Date", selection: $searchvm.dateStart)
                
                DatePicker("End Date", selection: $searchvm.dateEnd)
            }
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10)
            
            
            
            
            // tags
            Text("Filt by Tag")
                .font(.title3.bold())
                .frame(maxWidth: .infinity,alignment: .leading)
            TagPanelView(tagPanelvm: tagPanelvm)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .frame(maxWidth:.infinity)
            
            
            
            
            // types
            Text("Filt by Type")
                .font(.title3.bold())
                .frame(maxWidth: .infinity,alignment: .leading)
            Picker("Filter", selection:$searchvm.searchType){
                
                Text("Journal").tag(SearchType.journal)
                    .foregroundColor(searchvm.searchType == .journal ? .blue : .red)
                
                Text("Todo").tag(SearchType.todo)
                    .foregroundColor(searchvm.searchType == .todo ? .blue : .red)
                
                Text("Person").tag(SearchType.person)
                    .foregroundColor(searchvm.searchType == .person ? .blue : .red)
                
                Text("Branch").tag(SearchType.branch)
                    .foregroundColor(searchvm.searchType == .branch ? .blue : .red)
            }
            .pickerStyle(SegmentedPickerStyle())
            
            
            // keywords
            
            Text("Filt by Keywords")
                .font(.title3.bold())
                .frame(maxWidth: .infinity,alignment: .leading)
            
            
            TextField("Search", text: $searchvm.keywords, prompt: Text("Put a keyword here"))
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .foregroundColor(.primary)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
            
            
            
            
            
            
            
        } //: VStack
        .padding()
    }
}


struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView(tagPanelvm: TagPanelViewModel(), searchvm: SearchViewModel())
    }
}
