//
//  SearchJournalView.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/15.
//

import SwiftUI

struct SearchAndLinkingView<T:Item>: View {

    var item: T

    @ObservedObject var searchvm: SearchViewModel
    @ObservedObject var tagPanelvm: TagPanelViewModel

    @State private var editMode: EditMode = .inactive
    var isLinkingItem: Bool = true
    @Environment(\.presentationMode) var presentationMode
    @State var isShowingAlert: Bool = false
    @State var isShowingFalseAlert: Bool = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    FilterView(tagPanelvm: tagPanelvm, searchvm: searchvm)

                    Text("Result")
                        .font(.title3)
                    SearchResultView(searchvm: searchvm)
                }

            }
                .navigationTitle("Link to")
                .toolbar {

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        searchvm.fetchIDsFromFilter { _ in }
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(Color.pink)
                    }
                }


                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if searchvm.selectedJournals.isEmpty && searchvm.selectedTodos.isEmpty && searchvm.selectedPersons.isEmpty && searchvm.selectedBranches.isEmpty {
                            isShowingFalseAlert.toggle()
                        } else {
                            searchvm.doubleLink(from: item) { success in
                                if success {
                                    isShowingAlert.toggle()
                                } else {
                                    isShowingFalseAlert.toggle()
                                }
                            }
                        }

                    } label: {
                        Image(systemName: "link")
                            .foregroundColor(Color.pink)
                    }
                        .alert("success", isPresented: $isShowingAlert) {
                        Button("Continue") {

                        }

                        Button("Close") {
                            presentationMode.wrappedValue.dismiss()
                        }

                    } message: {
                        Text("You have successfully double linked the items")
                    }

                        .alert("failed", isPresented: $isShowingFalseAlert, actions: { Button("Retry") { } }, message: {
                        Text("Failed to double link the items, maybe you didn't select any items to link")
                    })


                }




                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(Color.primary)
                    }

                }
            }

        }

    }
}

struct SearchAndLinkingView_Previews: PreviewProvider {
    @State static var linkedIDs: [String] = []
    static var previews: some View {
        SearchAndLinkingView(item: Journal(), searchvm: SearchViewModel(), tagPanelvm: TagPanelViewModel())
    }
}
