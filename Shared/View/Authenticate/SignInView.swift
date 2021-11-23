//
//  LogInView.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/7.
//

import SwiftUI
import AuthenticationServices

struct SignInView: View {
        
    @State private var email:String = ""
    @State private var password: String = ""
    
    @State private var errorMessage = ""
    @State private var isShowingAlert = false
    @State private var isShowingLogInProgressView = false
    @Environment(\.presentationMode) var presentationMode
    
    
    
    var body: some View {
        NavigationView {
            VStack(alignment:.center, spacing: 40){
                Image("Color logo - no background")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200.0)

                
                // Email/Password Sign In
                VStack(alignment: .leading, spacing: 20.0) {
                    CustomTextField(text: $email, placeholder: "Email", labelImage: "envelope")
                    
                    CustomSecureTextField(text: $password, placeholder: "Password", labelImage: "lock")
                }
                .frame(width: 300)

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
                    Task {
                               do {
                                   isShowingLogInProgressView.toggle()
                                   try await AuthViewModel.shared.signInWithEmail(email: email, password: password)
                                   
                                       isShowingLogInProgressView.toggle()
                                   

                               } catch {
                                   print(error)
                               }
                    }
                       
                } label: {
                    if isShowingLogInProgressView {
                        ProgressView()
                    } else {
                        Text("Sign In")
                            .font(.headline)
                            .foregroundColor(.primary)
                    }
                }
                

                
                    
                // Apple Sign In...
                // See my Apple Sign in Video for more depth....
                SignInWithAppleButton(onRequest: { request in
                    
                    // requesting paramertes from apple login...
                    AuthViewModel.shared.nonce = AuthViewModel.shared.randomNonceString()
                    request.requestedScopes = [.email,.fullName]
                    request.nonce = AuthViewModel.shared.sha256(AuthViewModel.shared.nonce)
                    
                }, onCompletion: { result in
                    
                    // getting error or success...
                    
                    switch result{
                    case .success(let user):
                        print("success")
                        // do Login With Firebase...
                        guard let credential = user.credential as? ASAuthorizationAppleIDCredential else{
                            print("error with firebase")
                            return
                        }
                        AuthViewModel.shared.signInWithApple(credential: credential)
                    case.failure(let error):
                        print(error.localizedDescription)
                    }
                    
                })
                    .signInWithAppleButtonStyle(.black)
                    .frame(width:300, height: 40)
                
                // Google Sign In
                Button {
                    AuthViewModel.shared.signInWithGoogle()
                } label: {
                    
                    HStack(spacing: 5){
                        
                        Image("Google")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 18, height: 18)
                        
                        Text("Sign In with Google")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(Color.init(hexString: "000000"))

                    }
                    .frame(width:300, height: 40)
                    .background(Color.init(hexString: "EEEEEE"), in: RoundedRectangle(cornerRadius: 8))
                }
                
                
                Spacer()
                
                
                NavigationLink(
                    destination:
                        SignUpView()
                        .navigationBarHidden(true)
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
            .alert(errorMessage, isPresented: $isShowingAlert, actions: {})
            
            
        }
    }
    
}


struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}

