//
//  CustomSecureTextField.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/6.
//

import SwiftUI

struct CustomSecureTextField: View {
    
    @Binding var text: String
    let placeholder: String
    let labelImage: String
    
    var body: some View {
        HStack(alignment:.center, spacing: 20){
            
            Image(systemName: labelImage)
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20, alignment: .center)
            
            
            SecureField(placeholder, text: $text, prompt: Text(placeholder))
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .textFieldStyle(.roundedBorder)
        }
    }
}

struct CustomSecureTextField_Previews: PreviewProvider {
    static var previews: some View {
        CustomSecureTextField(text: .constant(""), placeholder: "placeholder", labelImage: "lock")
}
}
