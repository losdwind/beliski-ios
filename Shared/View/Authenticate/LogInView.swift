//
//  LogInView.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/7.
//

import SwiftUI

struct LogInView: View {
        
    @State private var email:String = ""
    @State private var password: String = ""
    @Environment(\.presentationMode) var mode
    
    var body: some View {
        NavigationView {
            VStack(alignment:.center, spacing: 40){
                Image("Color logo - no background")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200.0)

                
                
                VStack(alignment: .leading, spacing: 20.0) {
                    CustomTextField(text: $email, placeholder: "Email", labelImage: "envelope")
                    
                    CustomSecureTextField(text: $password, placeholder: "Password", labelImage: "lock")
                }
                .padding(.horizontal, 50.0)

                HStack {
                    Spacer()
                    
                    NavigationLink(
                        destination: ResetPasswordView(),
                        label: {
                            Text("Forgot Password?")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(.secondary)
                                .padding(.top)
                                .padding(.trailing, 28)
                        })
                }
            
                
                Button {
                    AuthViewModel.shared.login(withEmail: email, password: password, completion: {_ in})
                } label: {
                    Text("Sign In")
                        .font(.headline)
                        .foregroundColor(.primary)
                }

                
                    
                Spacer()
                
                NavigationLink(
                    destination:
                        SignUpView().navigationBarHidden(true)
                        .onDisappear(perform: {
                            mode.wrappedValue.dismiss()
                        })
                    ,
                    label: {
                        HStack {
                            Text("Don't have an account?")
                                .font(.system(size: 14))
                            
                            Text("Sign Up")
                                .font(.system(size: 14, weight: .semibold))
                        }.foregroundColor(.primary)
                    }).padding(.bottom, 16)
                
            }
            
            
        }
    }
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}
