//
//  CreateView.swift
//  Beliski-Firebase
//
//  Created by Wind Losd on 2021/9/17.
//

import SwiftUI
import Firebase

struct CreateView: View {
    
    @ObservedObject var journalvm: JournalViewModel
    @ObservedObject var taskvm: TaskViewModel
    @ObservedObject var personvm: PersonViewModel
    @ObservedObject var branchvm:BranchViewModel
    
    @State var isShowingJournalEditor = false
    @State var isShowingTaskEditor = false
    @State var isShowingPersonEditor = false
    @State var isShowingBranchEditor = false
    
    
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false

    
    var body: some View {
        
        ZStack {
        VStack(alignment:.center) {

            // New Journal
            Button(action: {
                isShowingJournalEditor = true
                playSound(sound: "sound-ding", type: "mp3")
                journalvm.localTimestamp = Date()
            }, label: {
                Image(systemName: "plus.circle")
                    .font(.system(size: 30, weight: .semibold, design: .rounded))
                Text("Journal")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .frame(width: 100, alignment: .leading)
            })
            .modifier(NewButtonGradientBackground())
            .sheet(isPresented: $isShowingJournalEditor){
                JournalEditorView(journalvm: journalvm, journalTagvm: TagViewModel())}
            

            // MARK: - here we have a bug
            
            
            
            // New  Task
            Button(action: {
                isShowingTaskEditor = true
                playSound(sound: "sound-ding", type: "mp3")
                taskvm.task.localTimestamp = Timestamp(date:Date())
            }, label: {
                Image(systemName: "plus.circle")
                    .font(.system(size: 30, weight: .semibold, design: .rounded))
                Text("Task")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .frame(width: 100, alignment: .leading)

            })
            .modifier(NewButtonGradientBackground())
//            .fullScreenCover(isPresented: $isShowingTaskEditor) {
//                TaskEditorView(taskvm: taskvm)
//            }
            
            // New Person
            Button(action: {
                isShowingPersonEditor = true
                playSound(sound: "sound-ding", type: "mp3")
                personvm.person.localTimestamp = Timestamp(date:Date())
            }, label: {
                Image(systemName: "plus.circle")
                    .font(.system(size: 30, weight: .semibold, design: .rounded))
                Text("Person")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .frame(width: 100, alignment: .leading)

            })
            .modifier(NewButtonGradientBackground())
            .sheet(isPresented: $isShowingPersonEditor){
                PersonEditorView(personTagvm: TagViewModel(), personvm: personvm)}
            

            
            
            // New Branch
            Button(action: {
                isShowingBranchEditor = true
                playSound(sound: "sound-ding", type: "mp3")
                branchvm.branch.localTimestamp = Timestamp(date:Date())
            }, label: {
                Image(systemName: "plus.circle")
                    .font(.system(size: 30, weight: .semibold, design: .rounded))
                Text("Branch")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .frame(width: 100, alignment: .leading)

            })
            .modifier(NewButtonGradientBackground())
            .sheet(isPresented: $isShowingBranchEditor) {
                BranchCardEditorView(branchvm: branchvm)

            }
            

            
        }
        .blur(radius: isShowingTaskEditor ? 5 : 0)
            
            
        .padding()
//        .halfSheet(isPresented: $isShowingJournalEditor) {
//        } content: {
//            JournalEditorView(journalvm: journalvm, journalTagvm: TagViewModel())
//        }
//
//        .halfSheet(isPresented: $isShowingBranchEditor) {
//
//        } content: {
//            BranchCardEditorView(branchvm: branchvm)
//        }
//
//        .halfSheet(isPresented:$isShowingPersonEditor) {
//
//        } content: {
//            PersonEditorView(personTagvm: TagViewModel(), personvm: personvm)
//        }
//
//        .halfSheet(isPresented: $isShowingTaskEditor) {
//
//        } content: {
//            TaskEditorView(taskvm: taskvm)
//        }
            
            if isShowingTaskEditor {
              BlankView(
                backgroundColor: isDarkMode ? Color.black : Color.gray,
                backgroundOpacity: isDarkMode ? 0.3 : 0.5)
                .onTapGesture {
                  withAnimation() {
                      isShowingTaskEditor = false
                  }
                }
              
                TaskEditorView(taskvm: taskvm)
            }
            
        }
    }
}

struct CreateView_Previews: PreviewProvider {
    static var previews: some View {
        CreateView(journalvm: JournalViewModel(), taskvm: TaskViewModel(), personvm: PersonViewModel(), branchvm: BranchViewModel())
    }
}
