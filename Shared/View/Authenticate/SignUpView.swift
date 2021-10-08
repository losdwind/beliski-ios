//
//  SignUpView.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/6.
//

import SwiftUI

struct SignUpView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @State private var email = ""
    @State private var fullname = ""
    @State private var username = ""
    @State private var password = ""
    @State private var selectedImage: UIImage?
    @State private var image: Image?
    @State private var isShowingimagePicker = false
    @Environment(\.presentationMode) var mode
    
    var body: some View {
        VStack{
            ZStack {
                if let image = image {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 140, height: 140)
                        .clipShape(Circle())
                } else {
                    Button(action: {
                        isShowingimagePicker.toggle() }, label: {
                        Image("plus_photo")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 140, height: 140)
                            .background(.primary)
                    }).sheet(isPresented: $isShowingimagePicker, onDismiss: loadImage, content: {
                        ImagePicker(image: $selectedImage)
                            .preferredColorScheme(colorScheme)
                            .accentColor(colorScheme == .light ? .primary: .secondary)
                    })
                }
            }
            
            VStack(spacing: 20) {

                CustomTextField(text: $email, placeholder: "Email", labelImage: "envelope")
                    .padding()
                    .cornerRadius(10)
                    .foregroundColor(.primary)
                    .padding(.horizontal, 32)
                
                
                CustomTextField(text: $username, placeholder: "User Name", labelImage: "person")
                    .padding()
                    .cornerRadius(10)
                    .foregroundColor(.primary)
                    .padding(.horizontal, 32)
                

                CustomTextField(text: $fullname, placeholder: "Full Name", labelImage: "person")
                    .padding()
                    .cornerRadius(10)
                    .foregroundColor(.primary)
                    .padding(.horizontal, 32)
                
                CustomSecureTextField(text: $password, placeholder: "Password", labelImage: "lock")
                    .padding()
                    .cornerRadius(10)
                    .foregroundColor(.primary)
                    .padding(.horizontal, 32)
            }
            
            Button(action: {
                AuthViewModel.shared.register(withEmail: email, password: password,
                                   image: selectedImage, fullname: fullname,
                                   username: username)
                
                // MARK: - need to async?
                mode.wrappedValue.dismiss()
                
            }, label: {
                Text("Sign Up")
                    .font(.headline)
                    .foregroundColor(.primary)
                    .frame(width: 360, height: 50)
                    .clipShape(Capsule())
                    .padding()
            })
            
            Spacer()
            
            Button(action: { mode.wrappedValue.dismiss() }, label: {
                HStack {
                    Text("Already have an account?")
                        .font(.system(size: 14))
                    
                    Text("Sign In")
                        .font(.system(size: 14, weight: .semibold))
                }.foregroundColor(.primary)
            })
        }
    }
}


extension SignUpView {
    func loadImage() {
        guard let selectedImage = selectedImage else { return }
        self.image = Image(uiImage: selectedImage)
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
