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
    
    
    @ObservedObject var personvm:PersonViewModel
    
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    
    
    var body: some View {
        VStack(alignment:.center, spacing: 20) {
            
            
                
                // Profile Image
                    Button(action: { avatarPickerPresented.toggle() }){
                        if personvm.person.avatarURL.isEmpty == true {
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
            
            
            
            
            Form {
                
                
                
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
                
                
                
            }
            
            
            TagAddView()
            
            
            HStack{
                
                // SAVE BUTTON
                Button(action: {
                    MediaUploader.uploadImages(images: personvm.images, type: .person)
                    { urls in
                        personvm.person.photoURLs = urls
                        personvm.uploadPerson { success in
                            if success {
                                personvm.person = Person()
                                personvm.images = [UIImage]()
                                personvm.audios = [NSData]()
                                personvm.videos = [NSData]()
                                personvm.fetchPersons{ _ in }
                            }
                        }
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
        }
    }
}

struct PersonEditorView_Previews: PreviewProvider {
    static var previews: some View {
        PersonEditorView(personvm: PersonViewModel())
    }
}
