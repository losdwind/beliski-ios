//
//  NewGridView.swift
//  Beliski
//
//  Created by Losd wind on 2021/11/19.
//

import SwiftUI
import Firebase
struct NewGridView: View {
    
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
        VStack(spacing:20) {
            HStack {
                // New Journal
                Button(action: {
                    isShowingJournalEditor = true
                    playSound(sound: "sound-ding", type: "mp3")
                    journalvm.localTimestamp = Date()
                }, label: {
                    NewButton(systemImageName: "note.text", buttonName: "Journal")
                })
                    .sheet(isPresented: $isShowingJournalEditor){
                        JournalEditorView(journalvm: journalvm, journalTagvm: TagViewModel())}
                
                
                // MARK: - here we have a bug
                
                // New  Task
                Button(action: {
                    isShowingTaskEditor = true
                    playSound(sound: "sound-ding", type: "mp3")
                    taskvm.task.localTimestamp = Timestamp(date:Date())
                }, label: {
                    NewButton(systemImageName: "checkmark", buttonName: "Task")
                    
                })

                    .sheet(isPresented: $isShowingTaskEditor) {
                        TaskEditorView(taskvm: taskvm)
                    }
            }
            
            
            HStack{
                // New Person
                Button(action: {
                    isShowingPersonEditor = true
                    playSound(sound: "sound-ding", type: "mp3")
                    personvm.person.localTimestamp = Timestamp(date:Date())
                }, label: {

                    
                    NewButton(systemImageName: "person.fill", buttonName: "Person")
                    
                })
                    .sheet(isPresented: $isShowingPersonEditor){
                        PersonEditorView(personTagvm: TagViewModel(), personvm: personvm)}
                
                
                
                // New Activity
                Button(action: {
                    isShowingPersonEditor = true
                    playSound(sound: "sound-ding", type: "mp3")
                    personvm.person.localTimestamp = Timestamp(date:Date())
                }, label: {

                    NewButton(systemImageName: "figure.walk", buttonName: "Activity")
                })
                    .sheet(isPresented: $isShowingPersonEditor){
                        PersonEditorView(personTagvm: TagViewModel(), personvm: personvm)}
                
                
            }
            
            Divider().padding()
            
            HStack{
                
                
                // New Branch
                Button(action: {
                    isShowingBranchEditor = true
                    playSound(sound: "sound-ding", type: "mp3")
                    branchvm.branch.localTimestamp = Timestamp(date:Date())
                }, label: {
                    NewButton(systemImageName: "arrow.triangle.branch", buttonName: "Branch")
                    
                })
                    .sheet(isPresented: $isShowingBranchEditor) {
                        BranchCardEditorView(branchvm: branchvm)
                        
                    }
                
                
                // New Collection
                Button(action: {
                    isShowingBranchEditor = true
                    playSound(sound: "sound-ding", type: "mp3")
                    branchvm.branch.localTimestamp = Timestamp(date:Date())
                }, label: {
                    NewButton(systemImageName: "archivebox.fill", buttonName: "Collection")
                    
                })
                    .sheet(isPresented: $isShowingBranchEditor) {
                        BranchCardEditorView(branchvm: branchvm)
                        
                    }
                
            }
            
        }
    }
}

struct NewGridView_Previews: PreviewProvider {
    static var previews: some View {
        NewGridView(journalvm: JournalViewModel(), taskvm: TaskViewModel(), personvm: PersonViewModel(), branchvm: BranchViewModel())
    }
}

struct NewButton: View {
    var systemImageName:String
    var buttonName:String
    var body: some View {
        VStack{
            Image(systemName: systemImageName)
                .font(.system(size: 30, weight: .semibold, design: .rounded))
                .frame(width:40, height:40)
            Text(buttonName)
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .frame(width: 120, alignment: .center)
        }
        .padding()
        .foregroundColor(Color.pink)
        .background(Color.gray.opacity(0.1), in: RoundedRectangle(cornerRadius: 10))
    }
}
