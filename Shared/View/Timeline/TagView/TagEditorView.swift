//
//  TagEditorView.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/20.
//

import SwiftUI

struct TagEditorView: View {
    
    @State var showAlert: Bool = false
    
    @Binding var tagIDsofItem:[String]
    @ObservedObject var tagvm:TagViewModel
    
    var body: some View {
        
        VStack{
            
            
            VStack(alignment: .leading, spacing: 10) {
                
                // Displaying Tags.....
                
                ForEach(tagvm.getTagsByRows(TagsofItemSet: tagvm.TagsofItem),id: \.self){TagsInRow in
                    
                    HStack(spacing: 6){
                        
                        ForEach(TagsInRow){ tag in
                            
                            // Row View....
                            TagItemView(tag: tag)
                                .contextMenu{
                                    Button("Delete"){
                                        // deleting...
                                        tagvm.TagsofItem.remove(tag)
                                        tagvm.tagIDs.remove(tag.id ?? "")
                                        tagIDsofItem = Array(tagvm.tagIDs)
                                        
                                    }
                                    
                                    Button("Rename"){
                                        print("functions to rename")
                                    }
                                }

                        }
                    }
                }
            }
            
            HStack(alignment: .center, spacing: 20) {
                // Custom Tag View...
                // TextField...
                TextField("apple", text: $tagvm.tag.name)
                    .foregroundColor(.primary)
                    .lineLimit(1)
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
                    
                    tagvm.checkTagLimit(text: tagvm.tag.name) { alert, tag in
                        
                        if alert{
                            // Showing alert...
                            showAlert.toggle()
                        }
                        else{
                            // adding Tag...
                            // MARK: - here we need authenticate duplicate tag in cloud firestore
                            
                            tagvm.TagsofItem.insert(tag)
                            
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
          

        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text("Tag Limit Exceeded  try to delete some tags !!!"), dismissButton: .destructive(Text("Ok")))
        }
    }
}

struct TagEditorView_Previews: PreviewProvider {
    @State var tagIDsofItem:[String] = [String]()
    
    static var previews: some View {
        TagEditorView(tagIDsofItem: $tagIDsofItem, tagvm: TagViewModel())
    }
}
