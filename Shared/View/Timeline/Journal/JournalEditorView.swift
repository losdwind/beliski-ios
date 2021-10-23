//
//  JournalEditorView.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/8.
//

import SwiftUI

struct JournalEditorView: View {
    @ObservedObject var journalvm:JournalViewModel
    @ObservedObject var journalTagvm: TagViewModel
    @State var imagePickerPresented = false
    
    @Environment(\.presentationMode) var presentationMode
    
    // new in iOS 15
    //    @Environment(\.dismiss) var dismiss
 
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false) {
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
            
            // MARK: - here we should add a grid image that shows the imageURLS
            
            if journalvm.journal.imageURLs.isEmpty == false {
                ImageGridView(imageURLs: journalvm.journal.imageURLs)
            }
            
            if journalvm.images.isEmpty == false {
                ImageGridDataView(images: journalvm.images)
            }

            
            
            Button(action: { imagePickerPresented.toggle() }, label: {
                Image(systemName:"plus")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 80, maxHeight: 80, alignment: .leading)
            }).sheet(isPresented: $imagePickerPresented
                     , content: {
                ImagePickers(images: $journalvm.images)
            })
            
            
            TimestampView(time:journalvm.journal.convertFIRTimestamptoString(timestamp: journalvm.journal.localTimestamp))
            
            TagEditorView(tagIDsofItem: $journalvm.journal.tagIDs, tagvm:journalTagvm)
            
            HStack {
                
                // SAVE BUTTON
                Button(action: {
                    MediaUploader.uploadImages(images: journalvm.images, type: .journal)
                    { urls in
                        journalvm.journal.imageURLs = urls
                        journalvm.uploadJournal { success in
                            if success {
                                journalvm.journal = Journal()
                                journalvm.images = [UIImage]()
                                journalvm.audios = [NSData]()
                                journalvm.videos = [NSData]()
                                journalvm.fetchJournals { _ in }
                            }
                        }
                    }
                    
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
        .frame(maxWidth: 640)
        } //: ScrollView
        }
    
}

struct JournalEditorView_Previews: PreviewProvider {
    static var previews: some View {
        JournalEditorView(journalvm: JournalViewModel(), journalTagvm: TagViewModel())
    }
}
