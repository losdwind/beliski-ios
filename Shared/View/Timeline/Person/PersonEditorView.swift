//
//  PersonEditorView.swift
//  Beliski
//
//  Created by Wind Losd on 2021/5/25.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift
//import iTextField
//import iPhoneNumberField

import Kingfisher
struct PersonEditorView: View {
    @Environment(\.colorScheme) var colorScheme
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
            
            ScrollView(.vertical, showsIndicators: false) {
                
                // Profile Image
                Button(action: { avatarPickerPresented.toggle() }){
                    if personvm.avatarImage == UIImage() && personvm.person.avatarURL == "" {
                        
                        Image(systemName:"plus")
                            .font(.title2)
                            .foregroundColor(.primary)
                            .frame(width:80, height:80)
                            .background(
                                Circle()
                                    .stroke(lineWidth: 3)
                                    .foregroundColor(Color.gray)
                            )

                        
                    } else{
                        if personvm.avatarImage != UIImage(){
                            Image(uiImage: personvm.avatarImage)
                                .resizable()
                                .frame(width: 80, height: 80, alignment: .leading)
                                .clipShape(Circle())
                        } else {
                            KFImage(URL(string: personvm.person.avatarURL)) .placeholder {
                                ProgressView()
                            }
                            .resizable()
                            .frame(width: 80, height: 80, alignment: .leading)
                            .clipShape(Circle())
                            
                            
                            
                            
                        }
                        
                    }
                }
                .padding()
                
                
                GroupBox {
                    // First Name
                    CustomTextField(text:$personvm.person.firstName , placeholder: "First Name", labelImage: "person.fill")
                    .disableAutocorrection(true)

                    
                    // Last Name
                    CustomTextField(text:$personvm.person.lastName , placeholder: "Last Name", labelImage: "")
                    .disableAutocorrection(true)
                    
                    //phone
                    CustomTextField(text: $personvm.person.contact , placeholder: "Phone", labelImage: "phone.fill")

                    // Birthday
                    DatePicker("Birthday", selection: $personvm.birthday)
                    
                } label: {
                    Text("Basic Information")
                }

                
                GroupBox{
                    TextEditor(text: $personvm.person.description)
                        .cornerRadius(10)
                        .frame(minHeight: 200)
                        .onChange(of: personvm.person.description) { value in
                            let words = personvm.person.description.split { $0 == " " || $0.isNewline }
                            personvm.person.wordCount = words.count
                        }
                    
                } label: {
                    Text("Perspective Description")
                }
                
                
                GroupBox {
                    
                    if isShowingImageToggle{
                        
                        Button {
                            personvm.images = [UIImage]()
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
                    
                } label: {
                    Toggle(isOn: $isShowingImageToggle) {
                        Text("Attach Photos?")
                    }
                }
                
                
                GroupBox {
                    TagEditorView(tagNamesOfItem: $personvm.person.tagNames, tagvm: personTagvm)
                    
                } label: {
                    Text("Tags")
                }
                
                
                
            } //: ScrollView
            .padding()
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
                    .preferredColorScheme(colorScheme)
                    .accentColor(colorScheme == .light ? .primary: .secondary)
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
