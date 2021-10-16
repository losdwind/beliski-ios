//
//  TaskRowItemView.swift
//  Beliski
//
//  Created by Wind Losd on 2021/5/8.
//

import SwiftUI

struct TaskRowItemView: View {
    
    @Binding var task:Task
    
    var body: some View {
        withAnimation {
        Toggle(isOn: $task.completion){
                Text(task.content)
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundColor(task.completion ? Color.pink : Color.primary)
                    .padding(.vertical)
                Spacer()
            }
        } //: Toggle
        .toggleStyle(CheckboxStyle())
    }
}

struct TaskRowItemView_Previews: PreviewProvider {
    
    @State var task:Task {
    
        let taskvm = TaskViewModel()
        taskvm.fetchTasks { _ in }
        return taskvm.fetchedTasks[0]
    }

    static var previews: some View {
        TaskRowItemView(task: $task)
            .previewLayout(.sizeThatFits)
        
    }
}

