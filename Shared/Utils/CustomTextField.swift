//
//  CustomTextField.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/6.
//

import SwiftUI

struct CustomTextField: View {
    
    @Binding var text: String
    let placeholder: String
    let labelImage: String
    
    var body: some View {
        HStack(alignment:.center, spacing: 20){
            
            Image(systemName: labelImage)
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20, alignment: .center)

            
            TextField(placeholder, text: $text, prompt: Text(placeholder))
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .textFieldStyle(.roundedBorder)

        }
    }
}

struct CustomTextField_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextField(text: .constant("some text here"), placeholder: "placeholder", labelImage: "envelope")
    }
}
