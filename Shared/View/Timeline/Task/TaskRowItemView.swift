//
//  TaskRowItemView.swift
//  Beliski
//
//  Created by Wind Losd on 2021/5/8.
//

import SwiftUI

struct TaskRowItemView: View {
    
    @Binding var task:Task
    @ObservedObject var taskvm:TaskViewModel
    var body: some View {
        withAnimation {
            Toggle(isOn: $taskvm.task.completion){
                Text(task.content)
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundColor(task.completion ? Color.pink : Color.primary)
                    .padding(.vertical)
                Spacer()
        } //: Toggle
        .toggleStyle(CheckboxStyle())
        .onChange(of: task.completion, perform: { value in
            taskvm.task = task
            taskvm.uploadTask{_ in }
        })
        
    }
    }
}

//struct TaskRowItemView_Previews: PreviewProvider {
//    
//    init(){
//        self.taskvm = TaskViewModel()
//        taskvm.fetchTasks(handler: {_ in })
//        self.task = self.taskvm.fetchedTasks[0]
//    }
//    
//    @State var task:Task
//    @StateObject var taskvm: TaskViewModel
//    
//
//    static var previews: some View {
//        TaskRowItemView(task: $task, taskvm: TaskViewModel())
//            .previewLayout(.sizeThatFits)
//        
//    }
//}

