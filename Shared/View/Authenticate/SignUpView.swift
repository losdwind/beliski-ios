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
    @State private var nickname = ""
    @State private var username = ""
    @State private var password = ""
    @State private var selectedImage: UIImage = UIImage()
    @State private var isShowingimagePicker = false
    @State private var isShowingAlert = false
    @Environment(\.presentationMode) var mode
    
    var body: some View {
        VStack{
            ZStack {
                
                    
                
                    Button(action: {
                        isShowingimagePicker.toggle() }) {
                            
                            if selectedImage != UIImage() {
                                Image(uiImage: selectedImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 140, height: 140)
                                    .clipShape(Circle())
                                    .background(.white,in: Circle())
                                    .padding()
                            } else {
                                Image(systemName:"person")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .cornerRadius(50)
                                    .background(.white,in: Circle())
                                    .padding()
                            }
                        
                    }.sheet(isPresented: $isShowingimagePicker, content: {
                        ImagePicker(image: $selectedImage)
                            .preferredColorScheme(colorScheme)
                            .accentColor(colorScheme == .light ? .primary: .secondary)
                    })
                
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
                

                CustomTextField(text: $nickname, placeholder: "Nick Name", labelImage: "person")
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
                AuthViewModel.shared.register(email: email, password: password,
                                              profileImage: selectedImage, nickName: nickname,
                                              userName: username)
                                                {success in
                                                    if success {
                                                        // MARK: - need to async?
                                                        isShowingAlert.toggle()
                                                    }
                }
                
                
                
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
        .alert("Successfully Registered", isPresented: $isShowingAlert, actions: {
            Button(action: {
                mode.wrappedValue.dismiss()
            }) {
                Text("OK")
            }
        })
    }
}


struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
