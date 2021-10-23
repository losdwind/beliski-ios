//
//  PersonEditorView.swift
//  Beliski
//
//  Created by Wind Losd on 2021/5/25.
//

import SwiftUI
import UIKit
//import iTextField
//import iPhoneNumberField

struct PersonEditorView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State var avatarPickerPresented = false
    @State var photosPickerPresented = false
    
    @ObservedObject var personTagvm:TagViewModel
    
    @ObservedObject var personvm:PersonViewModel
    
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    
    
    var body: some View {
        
        ScrollView {
        VStack(alignment:.center, spacing: 20) {
            
            
                // Profile Image
                    Button(action: { avatarPickerPresented.toggle() }){
                        if personvm.avatarImage == UIImage() {
                        Image(systemName:"person.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 80, maxHeight: 80, alignment: .leading)
                        } else{
                            Image(uiImage: personvm.avatarImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: 80, maxHeight: 80, alignment: .leading)
                        }
                        
                
                
            }
                    .sheet(isPresented: $avatarPickerPresented
                         , content: {
                    ImagePicker(image: $personvm.avatarImage)
                })
            
            
                
                
                // First Name
                TextField(text: $personvm.person.firstName){
                    Text("First Name")
                }
                .disableAutocorrection(true)
                .padding()
                
                
                // Last Name
                TextField(text: $personvm.person.lastName){
                    Text("Last Name")
                }
                .disableAutocorrection(true)
                .padding()
                
                // Birthday
                DatePicker("Birthday", selection: $personvm.birthday)
                
                
                //  contact
                TextField(text: $personvm.person.contact){
                    Text("Phone")
                }
                .padding()
                
                // location
                
                VStack(alignment: .leading, spacing: 0){
                    Text("Description")
                TextEditor(text: $personvm.person.description)
                .onChange(of: personvm.person.description) { value in
                    let words = personvm.person.description.split { $0 == " " || $0.isNewline }
                    personvm.person.wordCount = words.count
                }
                }
                
                // photos
                VStack(alignment:.center) {
                    
                    // Profile Image
                    
                    
                    if personvm.person.photoURLs.isEmpty == false{
                        ImageGridView(imageURLs: personvm.person.photoURLs)
                    }
                    
                    if personvm.images.isEmpty == false{
                        ImageGridDataView(images: personvm.images)
                    }
                    
                    Button(action: { photosPickerPresented.toggle() }, label: {
                        Image(systemName:"person.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 80, maxHeight: 80, alignment: .leading)
                    }).sheet(isPresented: $photosPickerPresented
                             , content: {
                        ImagePickers(images: $personvm.images)
                    })
                }
                .padding()
                
                
                
            
            
            TagEditorView(tagNamesOfItem: $personvm.person.tagNames, tagvm: personTagvm)
                .padding()
            
            
            
            
            HStack{
                
                // SAVE BUTTON
                Button(action: {
                    
                    
                    let group = DispatchGroup()
                    
                    group.enter()
                    
                    MediaUploader.uploadImage(image: personvm.avatarImage, type: .person) { imageURL in
                        personvm.person.avatarURL = imageURL
            
                    }
                    group.leave()
                    
                    group.enter()
                    MediaUploader.uploadImages(images: personvm.images, type: .person)
                    { urls in
                        personvm.person.photoURLs = urls
                    }
                    group.leave()
                    group.enter()
                    
                    personTagvm.uploadTag(handler: {_ in})
                    group.leave()
                    
                    group.enter()
                    personvm.uploadPerson { success in
                        if success {
                            personvm.person = Person()
                            personvm.images = [UIImage]()
                            personvm.audios = [NSData]()
                            personvm.videos = [NSData]()
                            personvm.fetchPersons{ _ in }
                        }
                    }
                    group.leave()
                    
                    group.notify(queue: .main){
                        print("Finished upload the person to firebase")
                    }
                    
                    
                    playSound(sound: "sound-ding", type: "mp3")
                    
                    presentationMode.wrappedValue.dismiss()
                    
                }, label: {
                    
                    HStack{
                        Spacer()
                        Text("SAVE")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                        Spacer()
                    }
                    
                })
                    .disabled(personvm.person.firstName == "")
                    .onTapGesture {
                        if personvm.person.firstName == "" {
                            playSound(sound: "sound-tap", type: "mp3")
                        }
                    }
                    .padding()
                    .foregroundColor(.secondary)
                    .background(personvm.person.firstName == "" ? Color.gray : Color.pink)
                    .cornerRadius(10)
                //                    .layoutPriority(1)
            }
        } //: VStack
        .padding()
        }//: ScrollView
    }
}

struct PersonEditorView_Previews: PreviewProvider {
    static var previews: some View {
        PersonEditorView(personTagvm: TagViewModel(), personvm: PersonViewModel())
    }
}
