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
    
    var body: some View {
        VStack {
            Image("instagram_logo_white")
                .resizable()
                .scaledToFit()
                .frame(width: 220, height: 100)
                .foregroundColor(.primary)
            
            VStack(spacing: 20) {
                CustomTextField(text: $email, placeholder:"Email", labelImage: "envelope")
                    .padding()

                    .cornerRadius(10)
                    .foregroundColor(.primary)
                    .padding(.horizontal, 32)
            }
            
            Button(action: {
                AuthViewModel.shared.resetPassword(withEmail: email)
                
            }, label: {
                Text("Send Reset Password Link")
                    .font(.headline)
                    .foregroundColor(.primary)
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
                }.foregroundColor(.primary)
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
    }
}
