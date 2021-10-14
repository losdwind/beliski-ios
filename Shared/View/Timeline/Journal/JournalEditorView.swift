//
//  JournalEditorView.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/8.
//

import SwiftUI

struct JournalEditorView: View {
    @ObservedObject var journalvm:JournalViewModel
    

    @Environment(\.presentationMode) var presentationMode
    
    // new in iOS 15
    //    @Environment(\.dismiss) var dismiss
    
    @State var isUpdatingJournal = false
    
    
    

    
    var body: some View {
        
        VStack(alignment:.leading) {
            TextEditor(text: $journalvm.journal.content)
                .onChange(of: journalvm.journal.content) { value in
                    let words = journalvm.journal.content.split { $0 == " " || $0.isNewline }
                    journalvm.journal.wordCount = words.count
                }
                .frame(maxWidth: 640, maxHeight:240)
                .foregroundColor(.pink)
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .padding(0)
                .cornerRadius(10)
            
            ImageEditorView(journalvm: journalvm, journal: $journalvm.journal)
            
            
            TimestampView(time:journalvm.journal.convertFIRTimestamptoString(timestamp: journalvm.journal.localTimestamp))
            
            HStack {
                
                // SAVE BUTTON
                Button(action: {
                    journalvm.uploadJournal { _ in }
                    playSound(sound: "sound-ding", type: "mp3")
                    //                        UINotificationFeedbackGenerator().notificationOccurred(.success)
                    
                    //                        TimelineManager.shared.selectedMainTab = MainTab.timeline
                    presentationMode.wrappedValue.dismiss()
                    
                }, label: {
                    
                    HStack{
                        Spacer()
                        Text("SAVE")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                        Spacer()
                    }
                    
                })
                    .disabled(journalvm.journal.wordCount == 0)
                    .onTapGesture {
                        if journalvm.journal.wordCount == 0 {
                            playSound(sound: "sound-tap", type: "mp3")
                        }
                    }
                    .padding()
                    .foregroundColor(.secondary)
                    .background(journalvm.journal.wordCount == 0 ? Color.gray : Color.pink)
                    .cornerRadius(10)
                //                    .layoutPriority(1)
            }
            
            
            
        } //: VSTACK
        .padding(.horizontal)
        .padding(.vertical, 20)
        .cornerRadius(16)
        .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.65), radius: 24)
        .frame(maxWidth: 640)
        
        
        
        
        
    }
}

struct JournalEditorView_Previews: PreviewProvider {
    static var previews: some View {
        JournalEditorView(journalvm: JournalViewModel())
    }
}



struct ImageEditorView: View {
    
    @ObservedObject var journalvm:JournalViewModel
    
    @Binding var journal:Journal
    
    @State var imagePickerPresented = false

    
    func didDismiss(){
        
        
        print("=================================================")
        MediaUploader.uploadImages(images: journalvm.images, type: .journal)
        { urls in
            journal.imageURLs = urls
        }
    }
    
    
    var body: some View {
        
        
        if journal.imageURLs.isEmpty {
            
            
            Button(action: { imagePickerPresented.toggle() }, label: {
                Image(systemName:"plus")
                    .resizable()
                    .scaledToFit()
            }).sheet(isPresented: $imagePickerPresented, onDismiss: didDismiss
            , content: {
                ImagePickers(images: $journalvm.images)
            })
            
        } else {

            ImageGridView(imageURLs: journal.imageURLs)

            
        }
    }
    
    
}

