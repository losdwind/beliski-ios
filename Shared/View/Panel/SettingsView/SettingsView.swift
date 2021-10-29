//
//  SettingsView.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/26.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    @ObservedObject var profilevm: ProfileViewModel
    @State var showSignOutError: Bool = false
    
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false, content: {
                
                // MARK: SECTION 1: Beliski
                GroupBox(label: SettingsLabelView(labelText: "Beliski", labelImage: "dot.radiowaves.left.and.right"), content: {
                    HStack(alignment: .center, spacing: 10, content: {
                        
                        Image("Black logo - no background")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80, alignment: .center)
                            .cornerRadius(12)
                        
                        Text("Beliski is a research based human behavior analysing and mobile sensing app. It is a professional tool to extract pattern recognition result from the user's social-economic attributes, user-generated richmedia materials, health data, social acitivity as well as environment background. It is goal is to help users to achieve and keep eudaimonic wellbeing along with their lives.")
                            .font(.footnote)
                        
                    })
                })
                .padding()
                
                // MARK: SECTION 2: PROFILE
                GroupBox(label: SettingsLabelView(labelText: "Profile", labelImage: "person.fill"), content: {
                    
                    NavigationLink(
                        destination: ProfileEditorView(profilevm: profilevm),
                        label: {
                            SettingsRowView(leftIcon: "person.circle", text: "Profile Info", color: Color.pink)
                        })
                    
                    
                    Button(action: {
                        signOut()
                    }, label: {
                        SettingsRowView(leftIcon: "figure.walk", text: "Sign out", color: Color.pink)
                    })
                    .alert(isPresented: $showSignOutError, content: {
                        return Alert(title: Text("Error signing out 🥵"))
                    })

                    
                })
                .padding()
                
                // MARK: SECTION 3: APPLICATION Relevant
                GroupBox(label: SettingsLabelView(labelText: "Application", labelImage: "apps.iphone"), content: {
                    
                    Button(action: {
                        openCustomURL(urlString: "https://www.google.com")
                    }, label: {
                        SettingsRowView(leftIcon: "folder.fill", text: "Privacy Policy", color: Color.white)
                    })
                    
                    Button(action: {
                        openCustomURL(urlString: "https://www.yahoo.com")
                    }, label: {
                        SettingsRowView(leftIcon: "folder.fill", text: "Terms & Conditions", color: Color.white)
                    })
                    
                    Button(action: {
                        openCustomURL(urlString: "https://www.bing.com")
                    }, label: {
                        SettingsRowView(leftIcon: "globe", text: "DogGram's Website", color: Color.white)
                    })

                })
                .padding()
                
                // MARK: SECTION 4: SIGN OFF
                GroupBox {
                    Text("Beliski was made with love. \n All Rights Reserved \n Figurich Inc. \n Copyright 2020 ♥️")
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                    
                }
                .padding()
                .padding(.bottom, 80)
                
            })
            .navigationBarTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarItems(leading:
                                    Button(action: {
                                        presentationMode.wrappedValue.dismiss()
                                    }, label: {
                                        Image(systemName: "xmark")
                                            .font(.title)
                                    })
                                    .accentColor(.primary)
            )
        }
        .accentColor(colorScheme == .light ? Color.primary : Color.secondary)

    }
    
    // MARK: FUNCTIONS
    
    func openCustomURL(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    
    func signOut() {
        AuthViewModel.shared.signout{ (success) in
            if success {
                print("Successfully logged out")
                
                // Dimiss settings view
                self.presentationMode.wrappedValue.dismiss()
                
            } else {
                print("Error logging out")
                self.showSignOutError.toggle()
            }
        }
    }
    
}

struct SettingsView_Previews: PreviewProvider {

    
    static var previews: some View {
        SettingsView(profilevm: ProfileViewModel())
            .preferredColorScheme(.dark)
    }
}
