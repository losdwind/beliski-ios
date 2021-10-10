//
//  CreateView.swift
//  Beliski-Firebase
//
//  Created by Wind Losd on 2021/9/17.
//

import SwiftUI

struct CreateView: View {
    
    @ObservedObject var journalvm: JournalViewModel
    @ObservedObject var taskvm: TaskViewModel
    @State var isShowingJournalEditor = false
    
    var body: some View {
        VStack {

            Button(action: {
                isShowingJournalEditor = true
                playSound(sound: "sound-ding", type: "mp3")
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
            
        
            
        }
    }
}

struct CreateView_Previews: PreviewProvider {
    static var previews: some View {
        CreateView(journalvm: JournalViewModel(), taskvm: TaskViewModel())
    }
}
