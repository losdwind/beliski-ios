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
                
                TextField("Tags", text: $tagvm.tagName, prompt: Text("Put Some Tags Here").foregroundColor(.secondary))
                    .foregroundColor(.primary)
                    .lineLimit(1)
                    .font(.headline)
                    .padding(.all, 5.0)
                
                // Setting only Textfield as Dark..
                    .environment(\.colorScheme, .light)
                
                // Add Button..
                Button {
                    
                    // adding Tag...
                    // MARK: - here we need authenticate duplicate tag in cloud firestore
                    
                    let success = tagvm.tagNames.insert(tagvm.tagName)
                    if success.inserted {
                        print("no duplicate tag, can insert")
                        tagvm.tagName = ""
                    } else {
                        print("duplicate tag")
                    }
                } label: {
                    Text("Add")
                        .foregroundColor(tagvm.tagName == "" ? Color.gray.opacity(0.2) : Color.pink)
                }
                .modifier(PinkTintButtonStyle())
                .disabled(tagvm.tagName == "")
                .layoutPriority(1)
            }
            
            
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text("Tag Limit Exceeded  try to delete some tags !!!"), dismissButton: .destructive(Text("Ok")))
        }
    }
}

struct TagEditorView_Previews: PreviewProvider {
    
    @State static var tags = ["a", "b"]
    
    static var previews: some View {
        TagEditorView(tagNamesOfItem: $tags, tagvm: TagViewModel())
            .previewLayout(.sizeThatFits)
    }
}
