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
    @State var isShowingJournalEditor = false
    @State var isShowingTaskEditor = false
    @State var isShowingPersonEditor = false

    
    var body: some View {
        VStack {

            Button(action: {
                isShowingJournalEditor = true
                playSound(sound: "sound-ding", type: "mp3")
                journalvm.journal.localTimestamp = Timestamp(date:Date())
            }, label: {
                Image(systemName: "plus.circle")
                    .font(.system(size: 30, weight: .semibold, design: .rounded))
                Text("New Diary")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
            })
            .modifier(NewButtonGradientBackground())
            .sheet(isPresented: $isShowingJournalEditor, onDismiss: {journalvm.fetchJournals(handler: { _ in
            })}) {
                JournalEditorView(journalvm: journalvm)}
            
            
            Button(action: {
                isShowingTaskEditor = true
                playSound(sound: "sound-ding", type: "mp3")
                taskvm.task.localTimestamp = Timestamp(date:Date())
            }, label: {
                Image(systemName: "plus.circle")
                    .font(.system(size: 30, weight: .semibold, design: .rounded))
                Text("New Task")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
            })
            .modifier(NewButtonGradientBackground())
            .sheet(isPresented: $isShowingTaskEditor, onDismiss: {taskvm.fetchTasks(handler: { _ in
            })}) {
                TaskEditorView(taskvm: taskvm)}
            
            Button(action: {
                isShowingPersonEditor = true
                playSound(sound: "sound-ding", type: "mp3")
                personvm.person.localTimestamp = Timestamp(date:Date())
            }, label: {
                Image(systemName: "plus.circle")
                    .font(.system(size: 30, weight: .semibold, design: .rounded))
                Text("New Task")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
            })
            .modifier(NewButtonGradientBackground())
            .sheet(isPresented: $isShowingPersonEditor, onDismiss: {personvm.fetchPersons(handler: { _ in
            })}) {
                PersonEditorView(personvm: personvm)}
            
        
            
        }
        .padding()
    }
}

struct CreateView_Previews: PreviewProvider {
    static var previews: some View {
        CreateView(journalvm: JournalViewModel(), taskvm: TaskViewModel(), personvm: PersonViewModel())
    }
}
