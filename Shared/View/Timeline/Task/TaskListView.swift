//
//  TaskListView.swift
//  Beliski
//
//  Created by Wind Losd on 2021/5/8.
//

import SwiftUI

struct TaskListView: View {
    
    // FETCHING DATA
    @ObservedObject var taskvm: TaskViewModel
    @ObservedObject var searchvm: SearchViewModel
    @ObservedObject var tagPanelvm: TagPanelViewModel
    @ObservedObject var dataLinkedManager: DataLinkedManager
    
    
    @State var isUpdatingTask = false
    @State var isLinkingItem = false
    @State var isShowingLinkedItemView: Bool = false
    
    
    // MARK: - FUNCTION
    
    
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(alignment: .leading) {
                ForEach(taskvm.fetchedTasks, id: \.id) { task in
                    TaskRowItemView(task: task)
                        
                    
                        .background {
                            NavigationLink(destination: LinkedItemsView(dataLinkedManager: dataLinkedManager), isActive: $isShowingLinkedItemView) {
                                EmptyView()
                            }
                        }
                    
                    
                        .contextMenu {
                            
                            // Delete
                            Button(action: {
                                taskvm.deleteTask(task: task) { success in
                                    if success {
                                        taskvm.fetchTasks { _ in }
                                    }
                                }
                                
                            }
                                   , label: { Label(
                                    title: { Text("Delete") },
                                    icon: { Image(systemName: "trash.circle") }) })
                            
                            // Edit
                            Button(action: {
                                isUpdatingTask = true
                                taskvm.task = task
                                
                            }
                                   , label: { Label(
                                    title: { Text("Edit") },
                                    icon: { Image(systemName: "pencil.circle") }) })
                            
                            // Link
                            Button(action: {
                                isLinkingItem = true
                                
                            }
                                   , label: { Label(
                                    title: { Text("Link") },
                                    icon: { Image(systemName: "link.circle") }) })
                        }
                        .frame(alignment: .topLeading)
                        .sheet(isPresented: $isUpdatingTask) {
                            taskvm.task = Task()
                            
                        } content: {
                            TaskEditorView(taskvm: taskvm)
                        }
                    
                    
                    
                        .sheet(isPresented: $isLinkingItem) {
                            SearchAndLinkingView(item: task, searchvm: searchvm, tagPanelvm: tagPanelvm)
                            
                            
                            
                        }
                        .onTapGesture(perform: {
                            isShowingLinkedItemView.toggle()
                            dataLinkedManager.linkedIds = task.linkedItems
                            dataLinkedManager.fetchItems { success in
                                if success {
                                    print("successfully loaded the linked Items from DataLinkedManager")
                                    
                                } else {
                                    print("failed to loaded the linked Items from DataLinkedManager")
                                }
                            }
                        })
                }
                
                
            }
            .padding()
            .frame(maxWidth: 640)
        }
        
        
        
    }
    
}

struct TaskListView_Previews: PreviewProvider {
    
    static var taskvm: TaskViewModel {
        let taskvm = TaskViewModel()
        taskvm.fetchTasks { _ in }
        return taskvm
    }
    
    static var previews: some View {
        TaskListView(taskvm: TaskViewModel(), searchvm: SearchViewModel(), tagPanelvm: TagPanelViewModel(), dataLinkedManager: DataLinkedManager())
            .previewLayout(.sizeThatFits)
        
    }
}
