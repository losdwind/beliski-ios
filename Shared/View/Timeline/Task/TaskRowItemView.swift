//
//  TaskRowItemView.swift
//  Beliski
//
//  Created by Wind Losd on 2021/5/8.
//

import SwiftUI

struct TaskRowItemView: View {
    
    var task:Task
    @State var completion:Bool
    
    init(task:Task){
        self.task = task
        self.completion = task.completion
    }
    var body: some View {
        withAnimation {
            Toggle(isOn: $completion){
                Text(task.content)
                    .font(.system(.body, design: .rounded))
                    .foregroundColor(completion ? Color.pink : Color.primary)
                Spacer()
        } //: Toggle
        .toggleStyle(CheckboxStyle())
        .onChange(of: completion) { newValue in
            let tempTaskvm = TaskViewModel()
            tempTaskvm.task = task
            tempTaskvm.task.completion = newValue
            tempTaskvm.uploadTask{_ in }
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(18)
        
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

