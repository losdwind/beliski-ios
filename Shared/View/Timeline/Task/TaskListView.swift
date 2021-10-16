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
    
    // MARK: - FUNCTION
    
    
    
    var body: some View {
        LazyVStack(alignment:.leading){
            ForEach(taskvm.tasks, id:\.id) { task in
                TaskRowItemView(task: $task)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.3), radius: 6)
                    .contextMenu(ContextMenu(menuItems: {
                        Button(action:{
                            taskvm.deleteTask(task: task) { _ in }
                            
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
                    }))
            }
            .frame(alignment:.leading)
            .sheet(isPresented: $isUpdatingTask, onDismiss: {
                taskvm.task = Task()
                taskvm.reminder = Date()
            }, content: {
                TaskEditorView(taskvm: taskvm)
            })
        }
        .frame(maxWidth: 640)

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
