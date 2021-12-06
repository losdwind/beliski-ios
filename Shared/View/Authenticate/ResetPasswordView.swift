//
//  ResetPasswordView.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/6.
//

import SwiftUI

struct ResetPasswordView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State private var email: String = ""
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            if colorScheme == .dark {
                Image("White logo - no background")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 220)


            } else {
                Image("Black logo - no background")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 220)


            }
             
            VStack(spacing: 20) {
                CustomTextField(text: $email, placeholder:"Email", labelImage: "envelope")
                    .padding()

                    .cornerRadius(10)
                    .foregroundColor(.accentColor)
                    .padding(.horizontal, 32)
            }
            
            Button(action: {
                AuthViewModel.shared.resetPassword(withEmail: email)
                
            }, label: {
                Text("Send Reset Password Link")
                    .font(.headline)
                    .foregroundColor(.accentColor)
                    .frame(width: 360, height: 50)

                    .clipShape(Capsule())
                    .padding()
            })
            
            Spacer()
            
            Button(action: { presentationMode.wrappedValue.dismiss() }, label: {
                HStack {
                    Text("Already have an account?")
                        .font(.system(size: 14))
                    
                    Text("Sign In")
                        .font(.system(size: 14, weight: .semibold))
                }.foregroundColor(.accentColor)
            })
        }
        .onReceive(AuthViewModel.shared.$didSendResetPasswordLink, perform: { _ in
            self.presentationMode.wrappedValue.dismiss()
        })
    }
}

struct ResetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ResetPasswordView()
            .preferredColorScheme(.light)
    }
}
