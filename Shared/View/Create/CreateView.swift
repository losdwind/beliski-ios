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
    @ObservedObject var personvm: PersonViewModel
    @ObservedObject var branchvm:BranchViewModel
    
    

    
    var body: some View {
        
        NavigationView {
            VStack(spacing:0){

                    PPCarouselView(cards: PPCards)
                  
                    NewGridView(journalvm: journalvm, taskvm: taskvm, personvm: personvm, branchvm: branchvm)
                
                Spacer()
                
                }
                                
                
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
                
            .navigationBarHidden(true)
            .navigationBarTitleDisplayMode(.inline)

        }
        
    }
}

struct CreateView_Previews: PreviewProvider {
    static var previews: some View {
        CreateView(journalvm: JournalViewModel(), taskvm: TaskViewModel(), personvm: PersonViewModel(), branchvm: BranchViewModel())
    }
}
