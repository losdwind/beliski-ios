//
//  Created by Robert Petras
//  SwiftUI Masterclass ♥ Better Apps. Less Code.
//  https://swiftuimasterclass.com 
//

import SwiftUI



struct TaskEditorView: View {
    // MARK: - PROPERTY
    
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    
    @ObservedObject var taskvm:TaskViewModel
    
    
    @Environment(\.presentationMode) var presentationMode
    
    
    // MARK: - FUNCTION
    
    
    
    // MARK: - BODY
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 16) {
                TextField("Add Task", text: $taskvm.task.content, prompt: Text("What do you plan to do"))
                    .foregroundColor(.pink)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .padding()
                    .background(
                        isDarkMode ? Color(UIColor.tertiarySystemBackground) : Color(UIColor.secondarySystemBackground)
                    )
                    .cornerRadius(10)

                
                DatePicker("Reminder", selection: $taskvm.reminder, in: Date()...)
                    .foregroundColor(.pink)
                    .font(.system(size: 16, weight: .bold, design: .rounded))

                
                Button(action: {
                    
                    taskvm.uploadTask { success in
                        if success {
                            taskvm.task = Task()
                            taskvm.fetchTasks{_ in}
                        }
                    }
                    playSound(sound: "sound-ding", type: "mp3")
//                    feedback.notificationOccurred(.success)
                    presentationMode.wrappedValue.dismiss()
                    
                }, label: {
                    Spacer()
                    Text("SAVE")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(taskvm.task.content.count == 0 ? Color.gray : Color.pink)
                    Spacer()
                })
                    .disabled(taskvm.task.content.count == 0)
                    .onTapGesture {
                        if taskvm.task.content.count == 0 {
                            playSound(sound: "sound-tap", type: "mp3")
                        }
                    }
            } //: VSTACK
            .padding(.horizontal)
            .padding(.vertical, 20)
            .background(
                isDarkMode ? Color(UIColor.secondarySystemBackground) : Color.white
            )
            .cornerRadius(16)
            .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.65), radius: 24)
            .frame(maxWidth: 640)
        } //: VSTACK
        .padding()
    }
}

// MARK: - PREVIEW

struct TaskEditorView_Previews: PreviewProvider {
    

    static var previews: some View {
        TaskEditorView(taskvm: TaskViewModel())
            .preferredColorScheme(.light)
            .previewDevice("iPhone 13 Pro")
            .background(Color.gray.edgesIgnoringSafeArea(.all))
    }
}
