//
//  TagEditorView.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/20.
//

import SwiftUI

struct TagEditorView: View {
    
    @State var showAlert: Bool = false
    
    @Binding var tagNamesOfItem:[String]
    @ObservedObject var tagvm:TagViewModel
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10){
            
            
            VStack(alignment: .leading, spacing: 10) {
                
                // Displaying Tags.....
                
                ForEach(tagvm.getTagNamesByRows(tagNames: tagvm.tagNames),id: \.self){tagNamesInRow in
                    
                    HStack(spacing: 6){
                        
                        ForEach(tagNamesInRow, id: \.self){ tagName in
                            
                            // Row View....
                            TagItemView(tagName:tagName)
                                .contextMenu{
                                    Button("Delete"){
                                        // deleting...
                                        tagvm.tagNames.remove(tagName)
                                    }

                                }
                            
                        }
                    }
                }
            }
            
            HStack(alignment: .center, spacing: 20) {
                // Custom Tag View...
                // TextField...
                
                Text(tagvm.tagName)
                TextField("Tags", text: $tagvm.tagName, prompt: Text("Put Some Tags Here"))
                    .foregroundColor(.primary)
                    .lineLimit(1)
                    .font(.title3)
                    .padding(.vertical,10)
                    .padding(.horizontal)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .strokeBorder(Color.pink.opacity(0.2),lineWidth: 1)
                    )
                
                // Setting only Textfield as Dark..
                    .environment(\.colorScheme, .dark)
                    .padding(.vertical,18)
                
                // Add Button..
                Button {
                    
                    // adding Tag...
                    // MARK: - here we need authenticate duplicate tag in cloud firestore
                    
                    let success = tagvm.tagNames.insert(tagvm.tagName)
                    if success.inserted {
                        print("no duplicate tag, can insert")
                    } else {
                        print("duplicate tag")
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
                .disabled(tagvm.tagName == "")
                .opacity(tagvm.tagName == "" ? 0.6 : 1)
            }
            
            
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text("Tag Limit Exceeded  try to delete some tags !!!"), dismissButton: .destructive(Text("Ok")))
        }
    }
}

//struct TagEditorView_Previews: PreviewProvider {
//    @Binding var a = [String]()
//    static var previews: some View {
//        TagEditorView(tagNamesOfItem: a, tagvm: TagViewModel())
//    }
//}
