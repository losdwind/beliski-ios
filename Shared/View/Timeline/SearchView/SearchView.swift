//
//  SearchView.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/27.
//

import SwiftUI

struct SearchView: View {
    
    @ObservedObject var searchvm: SearchViewModel
    @ObservedObject var momentvm: MomentViewModel
    @ObservedObject var todovm: TodoViewModel
    @ObservedObject var personvm: PersonViewModel
    @ObservedObject var dataLinkedManger:DataLinkedManager
    @ObservedObject var tagPanelvm:TagPanelViewModel
    @ObservedObject var timelineManager:TimelineManager
    @ObservedObject var branchvm:BranchViewModel
    
    @Environment(\.presentationMode) var presentationMode
    @State var isShowingSearchResultView:Bool = false
    
    var body: some View {
            ScrollView(.vertical,showsIndicators: false){
                
                HStack{
                    
                    Button {
                        
                        withAnimation{
                            presentationMode.wrappedValue.dismiss()
                        }
                        
                    } label: {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .foregroundColor(.black)
                    }
                    
                    Spacer()
                
                }
                .overlay(
                    
                    Text("Search")
                        .font(.system(size: 18))
                )
                .padding(.bottom, 20)
                
                FilterView(tagPanelvm: tagPanelvm, searchvm: searchvm)

                
                Button {
                    searchvm.fetchIDsFromFilter { success in
                        if success {
                            print("successfully get the filtered items and assign to item list view")
                            momentvm.fetchedMoments = searchvm.filteredMoments
                            todovm.fetchedTodos = searchvm.filteredTodos
                            personvm.fetchedPersons = searchvm.filteredPersons
                            branchvm.fetchedAllBranches = searchvm.filteredBranches
                            isShowingSearchResultView = true
                        } else {
                            print("failed to get the filtered items or assign to item list view ")
                        }
                        
                        
                    }
                } label: {
                    Text("Search")
                        .padding(.vertical,6)
                        .padding(.horizontal,30)
                        
                    
                }
                .modifier(SaveButtonBackground(isButtonDisabled: false))
                
                
                
                if isShowingSearchResultView{
                    Text("Results")
                        .font(.title3.bold())
                        .frame(maxWidth: .infinity,alignment: .leading)
                        .padding()
                    
                    SearchResultComplexView(timelineManager: timelineManager, searchvm: searchvm, momentvm: momentvm, todovm: todovm, personvm: personvm, dataLinkedManger: dataLinkedManger, tagPanelvm: tagPanelvm, branchvm: branchvm)
                        
                }
                
                
                
                Spacer()
                
                
            }
            .padding()
            
        
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(searchvm: SearchViewModel(), momentvm: MomentViewModel(), todovm: TodoViewModel(), personvm: PersonViewModel(), dataLinkedManger: DataLinkedManager(), tagPanelvm: TagPanelViewModel(), timelineManager: TimelineManager(), branchvm: BranchViewModel())
    }
}
