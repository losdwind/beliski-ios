//
//  MomentEditorView.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/8.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift
import UIKit

struct MomentEditorView: View {
    @ObservedObject var momentvm:MomentViewModel
    @ObservedObject var momentTagvm: TagViewModel
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
                Text("New Moment")
                    .font(.system(size: 18))
            )
               
               
               VStack(alignment: .leading, spacing: 15) {
                   
                   Text("Description")
                       .fontWeight(.semibold)
                       .foregroundColor(.gray)
                   
                   TextEditor(text: $momentvm.moment.content)
                       .onChange(of: momentvm.moment.content) { value in
                           let words = momentvm.moment.content.split { $0 == " " || $0.isNewline }
                           momentvm.moment.wordCount = words.count
                       }
                       .disableAutocorrection(true)
                       .font(.system(size: 16).bold())
                       .frame(minHeight: 50, idealHeight: 100, maxHeight: .infinity)
                       .foregroundColor(.pink)
                       .padding(0)
                       .cornerRadius(10)
                   
                   Divider()
               }
               .padding(.top,10)
               
               
               
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
                               
                               if momentvm.images.isEmpty && momentvm.moment.imageURLs.isEmpty{
                                   Image(systemName: "plus")
                                       .font(.largeTitle)
                                       .foregroundColor(.primary)
                               }
                               else{
                                   if momentvm.moment.imageURLs.isEmpty == false{
                                       
                                       ImageGridView(imageURLs: momentvm.moment.imageURLs)
                                   }
                                   if momentvm.images.isEmpty == false{
                                       
                                       ImageGridDataView(images: momentvm.images)
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
                
                
                //                TimestampView(time:momentvm.moment.convertFIRTimestamptoString(timestamp: momentvm.moment.localTimestamp))
                
               
               VStack(alignment: .leading, spacing: 15) {
                   
                   Text("When happened")
                       .fontWeight(.semibold)
                       .foregroundColor(.gray)
                   
                   DatePicker("", selection: $momentvm.localTimestamp)
                       .labelsHidden()
                       .font(.system(size: 16).bold())
                   
                   Divider()
               }
               .padding(.top,10)
               
               
                
               VStack(alignment: .leading, spacing: 15) {
                   
                   Text("Tag")
                       .fontWeight(.semibold)
                       .foregroundColor(.gray)
                   
                   TagEditorView(tagNamesOfItem: $momentvm.moment.tagNames, tagvm:momentTagvm)
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
                    .modifier(SaveButtonBackground(isButtonDisabled: momentvm.moment.wordCount == 0))
                    .onTapGesture {
                        if momentvm.moment.wordCount == 0 {
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
                ImagePickers(images: $momentvm.images)
                    .preferredColorScheme(colorScheme)
                    .accentColor(colorScheme == .light ? .primary: .secondary)
                
            })
        
    }
    
    private func save(){
        let group = DispatchGroup()
        group.enter()
        MediaUploader.uploadImages(images: momentvm.images, type: .moment){
            urls in
            print(urls)
            momentvm.moment.imageURLs = urls
            group.leave()
        }
        
        let oldNames = momentvm.moment.tagNames
        
        let newNames = Array(momentTagvm.tagNames)
        
        let difference = newNames.difference(from: oldNames)
        
        for change in difference {
            group.enter()
            switch change {
            case let .remove(_, oldElement, _):
                momentTagvm.deleteTag(tagName: oldElement, ownerItemID: momentvm.moment.id, handler: {_ in
                    group.leave()
                    
                })
            case let .insert(_, newElement, _):
                momentTagvm.uploadTag(tagName: newElement, ownerItemID: momentvm.moment.id, handler: {_ in
                    group.leave()
                })
            }
            
        }
        momentvm.moment.tagNames = Array(momentTagvm.tagNames)
        momentvm.moment.localTimestamp = Timestamp(date: momentvm.localTimestamp)
        
        
        group.notify(queue: .main){
            momentvm.uploadMoment { success in
                if success {
                    print("Finished upload the moment to firebase")
                    momentvm.moment = Moment()
                    momentvm.images = [UIImage]()
                    momentvm.audios = [NSData]()
                    momentvm.videos = [NSData]()
                    momentvm.localTimestamp = Date()
                    momentvm.fetchMoments { _ in }
                }
            }
            
        }
        
    }
}

struct MomentEditorView_Previews: PreviewProvider {
    static var previews: some View {
        MomentEditorView(momentvm: MomentViewModel(), momentTagvm: TagViewModel())
    }
}
