//
//  PersonEditorView.swift
//  Beliski
//
//  Created by Wind Losd on 2021/5/25.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift
import UIKit
//import iTextField
//import iPhoneNumberField

struct PersonEditorView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State var avatarPickerPresented = false
    @State var photosPickerPresented = false
    @State var isShowingImageToggle = false
    @State var alertMsg = ""
    @State var showAlert = false
    
    @ObservedObject var personTagvm:TagViewModel
    
    @ObservedObject var personvm:PersonViewModel
    
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    
    
    var body: some View {
        
        NavigationView {
            List {
                
                // Profile Image
                Button(action: { avatarPickerPresented.toggle() }){
                    if personvm.avatarImage == UIImage() && personvm.person.avatarURL == "" {
                        Image(systemName:"person.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 80, height: 80, alignment: .leading)
                            .cornerRadius(40)
                        
                    } else{
                        if personvm.avatarImage != UIImage(){
                            Image(uiImage: personvm.avatarImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 80, height: 80, alignment: .leading)
                                .cornerRadius(40)
                        } else {
                            AsyncImage(url: URL(string: personvm.person.avatarURL)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 80, height: 80, alignment: .leading)
                                    .cornerRadius(40)
                            } placeholder: {
                                ProgressView()
                            }
                            
                        }
                        
                    }
                }
                .padding()
                
                
                
                
                Section {
                    // First Name
                    TextField(text: $personvm.person.firstName){
                        Text("First Name")
                    }
                    .disableAutocorrection(true)
                    
                    
                    // Last Name
                    TextField(text: $personvm.person.lastName){
                        Text("Last Name")
                    }
                    .disableAutocorrection(true)
                    
                    // Birthday
                    DatePicker("Birthday", selection: $personvm.birthday)
                    
                    
                    //  contact
                    TextField(text: $personvm.person.contact){
                        Text("Phone")
                    }
                    
                    // location
                    
                    
                } header: {
                    Text("Basic Information")
                }
                
                
                
                Section{
                    TextEditor(text: $personvm.person.description)
                        .onChange(of: personvm.person.description) { value in
                            let words = personvm.person.description.split { $0 == " " || $0.isNewline }
                            personvm.person.wordCount = words.count
                        }
                    
                } header: {
                    Text("Perspective Description")
                }
                
                
                Section {
                    
                    if isShowingImageToggle{
                        
                        Button {
                            
                            photosPickerPresented.toggle()
                            
                        } label: {
                            
                            ZStack{
                                
                                if personvm.person.photoURLs.isEmpty && personvm.images.isEmpty{
                                    Image(systemName: "plus")
                                        .font(.largeTitle)
                                        .foregroundColor(.primary)
                                }
                                else{
                                    
                                    if personvm.person.photoURLs.isEmpty == false{
                                        ImageGridView(imageURLs: personvm.person.photoURLs)
                                    }
                                    
                                    if personvm.images.isEmpty == false{
                                        ImageGridDataView(images: personvm.images)
                                    }
                                }
                                
                            }
                            .frame(minHeight: 200)
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
                
                
                
                
                Section {
                    TagEditorView(tagNamesOfItem: $personvm.person.tagNames, tagvm: personTagvm)
                    
                } header: {
                    Text("Tags")
                }
                
                
            }//: List
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
                        if personvm.person.firstName == "" {
                            playSound(sound: "sound-tap", type: "mp3")
                        }
                    }
                    .disabled(personvm.person.firstName == "")
                    .foregroundColor(personvm.person.firstName == "" ? Color.gray : Color.pink)
                }
            } // toolbar
            .alert(isPresented: $showAlert) {
                
                Alert(title: Text("Message"), message: Text(alertMsg), dismissButton: .destructive(Text("Ok")))
            }
            .sheet(isPresented: $avatarPickerPresented
                   , content: {
                ImagePicker(image: $personvm.avatarImage)
            })
            .sheet(isPresented: $photosPickerPresented) {
                ImagePickers(images: $personvm.images)
            }
        }
        
        
        
        
        
    }
    
    
    private func save(){
        
        let group = DispatchGroup()
        group.enter()
        // Avatar
        MediaUploader.uploadImage(image: personvm.avatarImage, type: .person) { imageURL in
            personvm.person.avatarURL = imageURL
            group.leave()
            
            
        }
        
        // Photos
        group.enter()
        MediaUploader.uploadImages(images: personvm.images, type: .person)
        { urls in
            personvm.person.photoURLs = urls
            group.leave()
        }
        
        
        
        group.enter()
        let oldNames = personvm.person.tagNames
        
        let newNames = Array(personTagvm.tagNames)
        
        let difference = newNames.difference(from: oldNames)
        group.leave()
        for change in difference {
            group.enter()
            switch change {
            case let .remove(_, oldElement, _):
                personTagvm.deleteTag(tagName: oldElement, ownerItemID: personvm.person.id, handler: {_ in
                    group.leave()
                })
            case let .insert(_, newElement, _):
                personTagvm.uploadTag(tagName: newElement, ownerItemID: personvm.person.id, handler: {_ in
                    group.leave()
                })
            }
            
        }
        
        personvm.person.birthday = Timestamp(date: personvm.birthday)
        
        personvm.person.tagNames = Array(personTagvm.tagNames)
        
        
        
        
        group.notify(queue: .main){
            personvm.uploadPerson{ success in
                if success {
                    print("Finished upload the person to firebase")
                    personvm.person = Person()
                    personvm.images = [UIImage]()
                    personvm.audios = [NSData]()
                    personvm.videos = [NSData]()
                    personvm.fetchPersons{ _ in }
                }
            }
            
        }
    }
}

struct PersonEditorView_Previews: PreviewProvider {
    static var previews: some View {
        PersonEditorView(personTagvm: TagViewModel(), personvm: PersonViewModel())
    }
}
