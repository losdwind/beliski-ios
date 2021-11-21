//
//  LogInView.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/7.
//

import SwiftUI
import AuthenticationServices

struct LogInView: View {
        
    @State private var email:String = ""
    @State private var password: String = ""
    
    @State private var errorMessage = ""
    @State private var isShowingAlert = false
    @State private var isShowingLogInProgressView = false
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var appleSignInService = AppleSignInService()
    
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
                    isShowingLogInProgressView.toggle()
                    connectToFirebase(email: email, password: password)
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
                    appleSignInService.nonce = randomNonceString()
                    request.requestedScopes = [.email,.fullName]
                    request.nonce = sha256(appleSignInService.nonce)
                    
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
                        appleSignInService.authenticate(credential: credential)
                    case.failure(let error):
                        print(error.localizedDescription)
                    }
                    
                })
                .signInWithAppleButtonStyle(.whiteOutline)
                .frame(width: 55,height: 55)
                .opacity(0.02)
                
            )
                
                
                
                
                

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
    
    
    func connectToFirebase(email: String, password:String) {
        
        AuthViewModel.shared.logInUserToFirebase(email:email, password:password) { (returnedProviderID, isError, isNewUser, returnedUserID)  in
            if let newUser = isNewUser {
                if newUser {
                    // NEW USER
                    if let providerID = returnedProviderID, !isError {
                        self.errorMessage = "User exists in the database,but failed to get info, retry sign in or sign up as a new user"
                        self.isShowingAlert.toggle()
                    } else {
                        // ERROR
                        self.errorMessage = "Error getting provider ID from log in user to Firebase"
                        self.isShowingAlert.toggle()
                    }
                } else {
                    // EXISTING USER
                    if let userID = returnedUserID {
                        // SUCCESS, LOG IN TO APP
                        AuthViewModel.shared.logInUserToAppStorage(userID: userID) { (success) in
                            if success {
                                print("Successful log in existing user")
                                isShowingLogInProgressView.toggle()
                                self.presentationMode.wrappedValue.dismiss()
                            } else {
                                self.errorMessage = "Error logging existing user into our app"
                                self.isShowingAlert.toggle()
                            }
                        }
                    } else {
                        // ERROR
                        self.errorMessage = "Error getting USER ID from existing user to Firebase"
                        self.isShowingAlert.toggle()

                    }
                }
            } else {
                self.errorMessage = "Login failed There is no user record corresponding"
                self.isShowingAlert.toggle()
            }
            
        }
        
    }
    
}


struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}
