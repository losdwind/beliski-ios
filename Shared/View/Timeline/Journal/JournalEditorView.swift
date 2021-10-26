//
//  JournalEditorView.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/8.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct JournalEditorView: View {
    @ObservedObject var journalvm:JournalViewModel
    @ObservedObject var journalTagvm: TagViewModel
    @State var imagePickerPresented = false
    @State var isShowingImageToggle = false
    @State var alertMsg = ""
    @State var showAlert = false
    
    
    @Environment(\.presentationMode) var presentationMode
    
    // new in iOS 15
    //    @Environment(\.dismiss) var dismiss
    
    
    
    
    var body: some View {
        NavigationView{
            List {
                Section{
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
                } header: {
                    
                    Text("Description")
                }
                
                
                Section {
                    
                    if isShowingImageToggle{
                        
                        Button {
                            
                            imagePickerPresented.toggle()
                            
                        } label: {
                            
                            ZStack{
                                
                                if journalvm.images.isEmpty && journalvm.journal.imageURLs.isEmpty{
                                    Image(systemName: "plus")
                                        .font(.largeTitle)
                                        .foregroundColor(.primary)
                                }
                                else{
                                    if journalvm.journal.imageURLs.isEmpty == false{
                                        
                                        ImageGridView(imageURLs: journalvm.journal.imageURLs)
                                    }
                                    if journalvm.images.isEmpty == false{
                                        
                                        ImageGridDataView(images: journalvm.images)
                                    }
                                }
                                
                            }
                            .frame(height: 200)
                            .cornerRadius(10)
                            .shadow(radius: 2)
                            .padding(.top,8)
                        }
                        .frame(maxWidth: .infinity,alignment: .center)
                        
                    }
                    
                } header: {
                    
                    Toggle(isOn: $isShowingImageToggle) {
                        Text("Attach Photos?")
                    }
                }
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                
                
                
                //                TimestampView(time:journalvm.journal.convertFIRTimestamptoString(timestamp: journalvm.journal.localTimestamp))
                
                
                Section {
                    
                    DatePicker("", selection: $journalvm.localTimestamp)
                        .labelsHidden()
                    
                } header: {
                    
                    Text("Journal Happened")
                }
                
                Section{
                    TagEditorView(tagNamesOfItem: $journalvm.journal.tagNames, tagvm:journalTagvm)
                    
                } header: {
                    Text("Tag")
                }
                
            } //: List
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Moments")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                
                ToolbarItem(placement: .navigationBarLeading) {
                    
                    Button("Close"){
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(Color.gray)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    Button("Store"){
                        save()
                        playSound(sound: "sound-ding", type: "mp3")
                        presentationMode.wrappedValue.dismiss()

                        
                    }
                    .onTapGesture {
                        if journalvm.journal.wordCount == 0 {
                            playSound(sound: "sound-tap", type: "mp3")
                        }
                    }
                    .disabled(journalvm.journal.wordCount == 0)
                    .foregroundColor(journalvm.journal.wordCount == 0 ? Color.gray : Color.pink)
                }
            }
            .alert(isPresented: $showAlert) {
                
                Alert(title: Text("Message"), message: Text(alertMsg), dismissButton: .destructive(Text("Ok")))
            }
            .sheet(isPresented: $imagePickerPresented
                   , content: {
                ImagePickers(images: $journalvm.images)
            })
        }
    }
    
    private func save(){
        let group = DispatchGroup()
        group.enter()
        MediaUploader.uploadImages(images: journalvm.images, type: .journal){
            urls in
            print(urls)
            journalvm.journal.imageURLs = urls
            group.leave()
        }
        
        let oldNames = journalvm.journal.tagNames
        
        let newNames = Array(journalTagvm.tagNames)
        
        let difference = newNames.difference(from: oldNames)
        
        for change in difference {
            group.enter()
            switch change {
            case let .remove(_, oldElement, _):
                journalTagvm.deleteTag(tagName: oldElement, ownerItemID: journalvm.journal.id, handler: {_ in
                    group.leave()
                    
                })
            case let .insert(_, newElement, _):
                journalTagvm.uploadTag(tagName: newElement, ownerItemID: journalvm.journal.id, handler: {_ in
                    group.leave()
                })
            }
            
        }
        journalvm.journal.tagNames = Array(journalTagvm.tagNames)
        journalvm.journal.localTimestamp = Timestamp(date: journalvm.localTimestamp)
        
        
        group.notify(queue: .main){
            journalvm.uploadJournal { success in
                if success {
                    print("Finished upload the journal to firebase")
                    journalvm.journal = Journal()
                    journalvm.images = [UIImage]()
                    journalvm.audios = [NSData]()
                    journalvm.videos = [NSData]()
                    journalvm.localTimestamp = Date()
                    journalvm.fetchJournals { _ in }
                }
            }
            
        }
        
    }
}

struct JournalEditorView_Previews: PreviewProvider {
    static var previews: some View {
        JournalEditorView(journalvm: JournalViewModel(), journalTagvm: TagViewModel())
    }
}
