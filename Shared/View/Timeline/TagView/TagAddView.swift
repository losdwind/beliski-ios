//
//  TagAddView.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/15.
//

import SwiftUI

struct TagAddView: View {
    
    @State var text: String = ""
    
    // Tags..
    @State var tags: [Tag] = []
    @State var showAlert: Bool = false
    
    var body: some View {
        
        VStack{
            
            // Custom Tag View...
            TagView(maxLimit: 150, tags: $tags,fontSize: 16)
            
            // TextField...
            TextField("apple", text: $text)
                .font(.title3)
                .padding(.vertical,10)
                .padding(.horizontal)
                .background(
                
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(Color.pink.opacity(0.2),lineWidth: 1)
                )
                .foregroundColor(.primary)

            // Setting only Textfield as Dark..
                .environment(\.colorScheme, .dark)
                .padding(.vertical,18)
            
            // Add Button..
            Button {
                
                // Use same Font size and limit here used in TagView....
                addTag(tags: tags, text: text, fontSize: 16, maxLimit: 150) { alert, tag in
                    
                    if alert{
                        // Showing alert...
                        showAlert.toggle()
                    }
                    else{
                        // adding Tag...
                        tags.append(tag)
                        text = ""
                    }
                }
                
            } label: {
                Text("Add Tag")
                    .fontWeight(.semibold)
                    .foregroundColor(Color.primary)
                    .padding(.vertical,12)
                    .padding(.horizontal,45)
                    .background(Color.pink)
                    .cornerRadius(10)
            }
            // Disabling Button...
            .disabled(text == "")
            .opacity(text == "" ? 0.6 : 1)

        }
        .padding(15)
        .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .top)

        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text("Tag Limit Exceeded  try to delete some tags !!!"), dismissButton: .destructive(Text("Ok")))
        }
    }
}

struct TagAddView_Previews: PreviewProvider {
    static var previews: some View {
        TagAddView()
    }
}
