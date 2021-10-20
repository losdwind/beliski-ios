//
//  TagEditorView.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/20.
//

import SwiftUI

struct TagEditorView: View {
    
    @State var showAlert: Bool = false
    
    @ObservedObject var tagvm:TagViewModel
    
    var tagIDs: [String]
    
    var body: some View {
        
        VStack{
            
            // Custom Tag View...
            TagCollectionView(tagIDs: tagIDs)
            
            // TextField...
            TextField("apple", text: $tagvm.tag.name)
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
                
                tagvm.addTag(text: tagvm.tag.name) { alert, tag in
                    
                    if alert{
                        // Showing alert...
                        showAlert.toggle()
                    }
                    else{
                        // adding Tag...
                        // MARK: - here we need authenticate duplicate tag in cloud firestore
                        $tagvm.tags.append(tag)
                        tagvm.tag.name = ""
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
            .disabled(tagvm.tag.name == "")
            .opacity(tagvm.tag.name == "" ? 0.6 : 1)

        }
        .padding(15)
        .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .top)

        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text("Tag Limit Exceeded  try to delete some tags !!!"), dismissButton: .destructive(Text("Ok")))
        }
    }
}

struct TagEditorView_Previews: PreviewProvider {
    static var previews: some View {
        TagEditorView(tagvm: TagViewModel())
    }
}
