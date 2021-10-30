//
//  SwiftUIView.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/30.
//

import SwiftUI

import SwiftUI

struct MessageView: View {
    
    @State var comment: Comment
    @State var profilePicture: UIImage = UIImage(named: "logo.loading")!
    @State var profilevm:ProfileViewModel
    
    var body: some View {
        HStack {
            
            // MARK: PROFILE IMAGE
            NavigationLink(destination: ProfileCompactView(profilevm:profilevm)) {
                Image(uiImage: profilePicture)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40, alignment: .center)
                    .cornerRadius(20)
            }
            
            VStack(alignment: .leading, spacing: 4, content: {
                
                // MARK: USER NAME
                Text(comment.username)
                    .font(.caption)
                    .foregroundColor(.gray)
                
                // MARK: CONTENT
                Text(comment.content)
                    .padding(.all, 10)
                    .foregroundColor(.primary)
                    .background(Color.gray)
                    .cornerRadius(10)
                
            })
            
            Spacer(minLength: 0)
            
        }
    }
}
  

struct MessageView_Previews: PreviewProvider {
    
    static var comment: Comment = Comment(commentID: "", userID: "", username: "Joe Green", content: "This photo is really cool. haha", dateCreated: Date())
    
    static var profilevm = ProfileViewModel()
    
    static var previews: some View {
        MessageView(comment: comment, profilevm: profilevm)
            .previewLayout(.sizeThatFits)
    }
}
