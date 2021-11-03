//
//  BranchCardListView.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/31.
//

import SwiftUI

struct BranchCardListView: View {
    
    @ObservedObject var branchvm:BranchViewModel
    
    @ObservedObject var dataLinkedManager:DataLinkedManager
    @ObservedObject var searchvm: SearchViewModel
    @ObservedObject var tagPanelvm:TagPanelViewModel
    
    @State var isUpdatingBranch = false
    @State var isShowingLinkedItemView = false
    @State var isShowingLinkView:Bool = false
    
    var body: some View {
        NavigationView{
            
            ScrollView(.vertical, showsIndicators: false){
                
                LazyVStack{
                    ForEach(branchvm.fetchedAllBranches, id: \.self) { branch in
                        
                        BranchCardView(branch: branch)
                            .background{
                                NavigationLink(destination: LinkedItemsView(dataLinkedManager: dataLinkedManager), isActive: $isShowingLinkedItemView) {
                                    EmptyView()
                                }
                                
                            } //: background
                        
                            .contextMenu{
                                // Delete
                                Button(action:{
                                    branchvm.deleteBranch(branch: branch){success in
                                        if success {
                                            branchvm.fetchBranchs { _ in}
                                        }
                                        
                                    }
                                    
                                }
                                       ,label:{Label(
                                        title: { Text("Delete") },
                                        icon: { Image(systemName: "trash.circle") })})
                                    .disabled(branch.openess != OpenType.Private)
                                
                                
                                
                                // Edit
                                Button(action:{
                                    branchvm.branch = branch
                                    branchvm.localTimestamp = branch.serverTimestamp?.dateValue() ?? Date(timeIntervalSince1970: 0)
                                    
                                    isUpdatingBranch = true
                                    
                                }
                                       ,label:Label(
                                        title: { Text("Edit") },
                                        icon: { Image(systemName: "pencil.circle") }))
                                    .disabled(branch.openess == OpenType.Public)
                                
                                
                                // Link
                                Button(action:{
                                    branchvm.branch = branch
                                    isShowingLinkView = true
                                    
                                }
                                       
                                       ,label:{Label(
                                        title: { Text("Link") },
                                        icon: { Image(systemName: "link.circle") })})
                                    .disabled(branch.openess == OpenType.Public)
                                
                                
                                
                                
                                
                                
                                
                            }
                        
                        
                        
                            .onTapGesture {
                                isShowingLinkedItemView.toggle()
                                dataLinkedManager.linkedIds = branch.linkedItems
                                dataLinkedManager.fetchItems { success in
                                    if success {
                                        print("successfully loaded the linked Items from DataLinkedManager")
                                        
                                    } else {
                                        print("failed to loaded the linked Items from DataLinkedManager")
                                    }
                                }
                            } //: onTapGesture
                        
                            .sheet(isPresented: $isUpdatingBranch){
                                // MARK: - think about the invalide id, because maybe the journal haven't yet been uploaded
                                
                                BranchCardEditorView(branchvm: branchvm)
                            }
                            .sheet(isPresented: $isShowingLinkView, onDismiss: {
                                branchvm.uploadBranch{ success in
                                    if success {
                                        print("successfully linked items and uploaded to firebase")
                                        journalvm.fetchJournals { _ in
                                        }
                                        branchvm.fetchAllBranchs(completion: {_ in})
                                    } else {
                                        print("Booom! failed to linke items and upload to firebase")
                                    }
                                    
                                }
                            }){
                                SearchAndLinkingView(linkedIDs: $branchvm.branch.linkedItems, searchvm: searchvm, tagPanelvm: tagPanelvm)
                                
                            }
                        
                        
                    }
                    
                }
                .padding()
                .frame(maxWidth: 640)
            }
            
        }
    }
}

struct BranchCardListView_Previews: PreviewProvider {
    static var previews: some View {
        BranchCardListView(branchvm: BranchViewModel(), dataLinkedManager: DataLinkedManager(), searchvm: SearchViewModel(), tagPanelvm: TagPanelViewModel())
    }
}
