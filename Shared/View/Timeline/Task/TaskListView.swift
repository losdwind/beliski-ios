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
    
    @State var isUpdatingTask = false
    @State var isLinkingItem = false
    
    // MARK: - FUNCTION
    
    
    
    var body: some View {
        LazyVStack(alignment:.leading){
            ForEach(taskvm.fetchedTasks, id:\.id) { task in
                TaskRowItemView(task: task)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(18)
                
                    .contextMenu{
                        Button(action:{
                            taskvm.deleteTask(task: task) { _ in }
                            taskvm.fetchTasks { _ in }
                        }
                               ,label:{Label(
                                title: { Text("Delete") },
                                icon: { Image(systemName: "trash.circle") })})
                        
                        Button(action:{
                                isUpdatingTask = true
                            taskvm.task = task
        
                        }
                               ,label:{Label(
                                title: { Text("Edit") },
                                icon: { Image(systemName: "pencil.circle") })})
                        
                        // Link
                        Button(action:{
                            taskvm.task = task
                            isLinkingItem = true
                            
                        }
                               ,label:{Label(
                                title: { Text("Link") },
                                icon: { Image(systemName: "link.circle") })})
                    }
            }
            .frame(alignment:.topLeading)
            .sheet(isPresented: $isUpdatingTask, onDismiss: {
                taskvm.task = Task()
                taskvm.reminder = Date()
            }, content: {
                TaskEditorView(taskvm: taskvm)
            })
        }
        .padding()
        .frame(maxWidth: 640)
        .onAppear(perform:{
            taskvm.fetchTasks(handler: {
                success in
                if success {
                    print("successfully fetched the tasks from firebase ")
                } else {
                    print("failed to fetched the tasks from firebase")
                }
            })
        }
        )

    }
        
}

struct TaskListView_Previews: PreviewProvider {
    
    static var taskvm:TaskViewModel {
        let taskvm = TaskViewModel()
        taskvm.fetchTasks{_ in}
        return taskvm
    }
    
    static var previews: some View {
        TaskListView(taskvm:taskvm)
            .previewLayout(.sizeThatFits)
        
    }
}
