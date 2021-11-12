//
//  JournalEditorView.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/8.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift
import UIKit

struct JournalEditorView: View {
    @ObservedObject var journalvm:JournalViewModel
    @ObservedObject var journalTagvm: TagViewModel
    @State var imagePickerPresented = false
    @State var isShowingImageToggle = false
    @State var alertMsg = ""
    @State var showAlert = false
    
    @Environment(\.colorScheme) var colorScheme

    @Environment(\.presentationMode) var presentationMode
    
    // new in iOS 15
    //    @Environment(\.dismiss) var dismiss
    
    
    
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            VStack(spacing:20){
            
            HStack{
                
                Button {
                    
                    withAnimation{
                        presentationMode.wrappedValue.dismiss()
                    }
                    
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .foregroundColor(.black)
                }
                
                Spacer()
            }
            .overlay(
                Text("New Journal")
                    .font(.system(size: 18))
            )
               
               
               VStack(alignment: .leading, spacing: 15) {
                   
                   Text("Description")
                       .fontWeight(.semibold)
                       .foregroundColor(.gray)
                   
                   TextEditor(text: $journalvm.journal.content)
                       .onChange(of: journalvm.journal.content) { value in
                           let words = journalvm.journal.content.split { $0 == " " || $0.isNewline }
                           journalvm.journal.wordCount = words.count
                       }
                       .font(.system(size: 16).bold())
                       .frame(maxWidth: 640, maxHeight:240)
                       .foregroundColor(.pink)
                       .padding(0)
                       .cornerRadius(10)
                   
                   Divider()
               }
               .padding(.top,10)
               
               
                
                Section {
                    
                    
                    
                } header: {
                    
                    
                }
                .padding()
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                
               
               
               VStack(alignment: .leading, spacing: 15) {
                   
                   Toggle(isOn: $isShowingImageToggle) {
                       Text("Attach Photos?")
                           .fontWeight(.semibold)
                           .foregroundColor(.gray)
                   }
                       
                   
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
                   
                   Divider()
               }
               .padding(.top,10)
                
                
                //                TimestampView(time:journalvm.journal.convertFIRTimestamptoString(timestamp: journalvm.journal.localTimestamp))
                
               
               VStack(alignment: .leading, spacing: 15) {
                   
                   Text("When happened")
                       .fontWeight(.semibold)
                       .foregroundColor(.gray)
                   
                   DatePicker("", selection: $journalvm.localTimestamp)
                       .labelsHidden()
                       .font(.system(size: 16).bold())
                   
                   Divider()
               }
               .padding(.top,10)
               
               
                
               VStack(alignment: .leading, spacing: 15) {
                   
                   Text("Tag")
                       .fontWeight(.semibold)
                       .foregroundColor(.gray)
                   
                   TagEditorView(tagNamesOfItem: $journalvm.journal.tagNames, tagvm:journalTagvm)
                       .font(.system(size: 16).bold())
                       .lineLimit(4)
                   
                   Divider()
               }
               .padding(.top,10)
               
                
                
                    
                    Button{
                        save()
                        playSound(sound: "sound-ding", type: "mp3")
                        presentationMode.wrappedValue.dismiss()

                        
                    } label: {
                        Text("Save")
                            .padding(.vertical,6)
                            .padding(.horizontal,30)
                    }
                    .modifier(SaveButtonBackground(isButtonDisabled: journalvm.journal.wordCount == 0))
                    .onTapGesture {
                        if journalvm.journal.wordCount == 0 {
                            playSound(sound: "sound-tap", type: "mp3")
                        }
                    }
                    
                    
            }
            .padding()

            } //: ScrollView
           .transition(.move(edge: .bottom))
            .alert(isPresented: $showAlert) {
                
                Alert(title: Text("Message"), message: Text(alertMsg), dismissButton: .destructive(Text("Ok")))
            }
            .sheet(isPresented: $imagePickerPresented
                   , content: {
                ImagePickers(images: $journalvm.images)
                    .preferredColorScheme(colorScheme)
                    .accentColor(colorScheme == .light ? .primary: .secondary)
                
            })
        
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
