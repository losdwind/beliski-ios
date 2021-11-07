//
//  SearchJournalView.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/15.
//

import SwiftUI

struct SearchAndLinkingView<T:Item>: View {
    
    var item:T
    @ObservedObject var searchvm:SearchViewModel
    @ObservedObject var tagPanelvm:TagPanelViewModel
    
    @State private var editMode: EditMode = .inactive
    var isLinkingItem: Bool = true
    @Environment(\.presentationMode) var presentationMode
        
    private var editButton: some View {
        return Button {
            if editMode == .inactive {
                editMode = .active
            } else {
                
                searchvm.doubleLink(from: item) { success in
                    if success {
                        print("successfully double linked the items")
                    }
                }
                presentationMode.wrappedValue.dismiss()
                
                
            }
        } label: {
            Text(editMode == .inactive ? "Select" : "Link")
                .foregroundColor(editMode == .inactive ? Color.primary : Color.pink)
        }
    }
    
    
    
    
    var body: some View {
        NavigationView{
            VStack {
                Form {
                    // keywords
                    Section {
                        HStack(alignment: .center, spacing: 20){
                            TextField("Search", text: $searchvm.keywords, prompt: Text("Put a keyword here"))
                                .foregroundColor(.primary)
                            
                            Button {
                                searchvm.fetchIDsFromFilter { _ in }
                            } label: {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(Color.pink)
                            }
                        }
                    } header: {
                        Text("Keywords")
                    }
                    
                    
                    // types
                    Picker("Filter", selection:$searchvm.searchType){
                        
                        Text("Journal").tag(SearchType.journal)
                            .foregroundColor(searchvm.searchType == .journal ? .blue : .red)
                        
                        Text("Task").tag(SearchType.task)
                            .foregroundColor(searchvm.searchType == .task ? .blue : .red)
                        
                        Text("Person").tag(SearchType.person)
                            .foregroundColor(searchvm.searchType == .person ? .blue : .red)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    
                    // dates
                    Section {
                        DatePicker("Start Date", selection: $searchvm.dateStart)
                        
                        DatePicker("End Date", selection: $searchvm.dateEnd)
                    } header: {
                        Text("Filt by Date")
                    }
                    
                    
                    // tags
                    Section {
                        TagPanelView(tagPanelvm: tagPanelvm)
                    }header: {
                        Text("Filt by Tag")
                    }
                    
                    
                    
                    
                }
                
                // results list
                Text("Result")
                    .font(.title3)
                
            SearchResultView(searchvm: searchvm)
                .environment(\.editMode, $editMode)
        }
            
                
                
            
            .navigationTitle("Link to")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    editButton
                }
                
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Close")
                            .foregroundColor(Color.primary)
                    }

                }
            }
            
        }
    }
}

struct LinkingView_Previews: PreviewProvider {
    @State static var linkedIDs:[String] = []
    static var previews: some View {
        SearchAndLinkingView(item:Journal(), searchvm: SearchViewModel(), tagPanelvm: TagPanelViewModel())
    }
}
