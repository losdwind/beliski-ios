//
//  Created by Robert Petras
//  SwiftUI Masterclass ♥ Better Apps. Less Code.
//  https://swiftuimasterclass.com 
//

import SwiftUI



struct TodoEditorView: View {
    // MARK: - PROPERTY
    
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    
    @ObservedObject var todovm:TodoViewModel
    
    
    @Environment(\.presentationMode) var presentationMode
    
    
    // MARK: - FUNCTION
    
    
    
    // MARK: - BODY
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 16) {
                TextField("Add Todo", text: $todovm.todo.content, prompt: Text("What do you plan to do"))
                    .foregroundColor(.pink)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .padding()
                    .background(
                        isDarkMode ? Color(UIColor.tertiarySystemBackground) : Color(UIColor.secondarySystemBackground)
                    )
                    .cornerRadius(10)

                

                    DatePicker(selection: $todovm.reminder, in: Date()...) {
                        
                        Image(systemName: "bell")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                            .foregroundColor(.pink)
                    }
                
                

                
                Button(action: {
                    
                    todovm.uploadTodo { success in
                        if success {
                            todovm.todo = Todo()
                            todovm.fetchTodos{_ in}
                        }
                    }
                    playSound(sound: "sound-ding", type: "mp3")
//                    feedback.notificationOccurred(.success)
                    presentationMode.wrappedValue.dismiss()
                    
                }, label: {
                    Spacer()
                    Text("SAVE")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .padding()
//                        .foregroundColor(todovm.todo.content.count == 0 ? Color.gray : Color.pink)
                    Spacer()
                })
                    .modifier(SaveButtonBackground(isButtonDisabled: todovm.todo.content.count == 0))
                    .onTapGesture {
                        if todovm.todo.content.count == 0 {
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

struct TodoEditorView_Previews: PreviewProvider {
    

    static var previews: some View {
        TodoEditorView(todovm: TodoViewModel())
            .preferredColorScheme(.light)
            .previewDevice("iPhone 13 Pro")
            .background(Color.gray.edgesIgnoringSafeArea(.all))
    }
}
