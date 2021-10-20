//
//  TagViewModel.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/18.
//

import Foundation
import UIKit

class TagViewModel: ObservableObject {
    
//
//    @DocumentID var id:String?
//    var name: String = ""
//    var linkedID:[String] = []
//    var linkedIDCount:Int {
//        linkedID.count
//    }
//    var size: CGFloat = 0
    
    
    @Published var tag: Tag = Tag() //used for update the tag in database
    
    @Published var fetchedTags:[Tag] = [Tag]()
    
    @Published var fontSize:CGFloat = 16
    @Published var maxLimit:Int = 150
    
    
    // add tag into the linkedTags of a Object
    func addTag(text: String, completion: @escaping (Bool,Tag)->()){
        
        // getting Text Size according to different fontSize
        let font = UIFont.systemFont(ofSize: fontSize)
        
        let attributes = [NSAttributedString.Key.font: font]
        
        let size = (text as NSString).size(withAttributes: attributes)
        
        let tag = Tag(name: text, size: size.width)
        
        if (getSize(tags: fetchedTags) + text.count) < maxLimit{
            completion(false,tag)
        }else{
            completion(true,tag)
        }
        
        

    }
    
    
    func getIndex(tag: Tag, in tags: [Tag])->Int{
        
        let index = tags.firstIndex { currentTag in
            return tag.id == currentTag.id
        } ?? 0
        
        return index
    }
    
    // get the existing tags' size to infer it exceeds maxLimit or not
    func getSize(tags: [Tag])->Int{
        var count: Int = 0
        
        tags.forEach { tag in
            count += tag.name.count
        }
        
        return count
    }
    
    // Basic Logic..
    // Splitting the array when it exceeds the screen size....
    func getTagsByRows()->[[Tag]]{
        
        var rows: [[Tag]] = []
        var currentRow: [Tag] = []
        
        // caluclating text width...
        var totalWidth: CGFloat = 0
        
        // For safety extra 10....
        let screenWidth: CGFloat = UIScreen.main.bounds.width - 90
        
        fetchedTags.forEach { tag in
            
            // updating total width...
            
            // adding the capsule size into total width with spacing..
            // 14 + 14 + 6 + 6
            // extra 6 for safety...
            totalWidth += (tag.size + 40)
            
            // checking if totalwidth is greater than size...
            if totalWidth > screenWidth{
                
                // adding row in rows...
                // clearing the data...
                // checking for long string...
                totalWidth = (!currentRow.isEmpty || rows.isEmpty ? (tag.size + 40) : 0)
                
                rows.append(currentRow)
                currentRow.removeAll()
                currentRow.append(tag)
                
            }else{
                currentRow.append(tag)
            }
        }
        
        // Safe check...
        // if having any value storing it in rows...
        if !currentRow.isEmpty{
            rows.append(currentRow)
            currentRow.removeAll()
        }
        
        return rows
    }
    
    
    


    
    
    
    
    func uploadTag(handler: @escaping (_ success: Bool) -> ()) {
        
        guard let userID = AuthViewModel.shared.currentUser?.id else {
            print("userID is not valid in uploadTag func")
            return }
        
        var document = COLLECTION_USERS.document(userID).collection("tags").document()
        
        if tag.id != nil {
            document = COLLECTION_USERS.document(userID).collection("tags").document(tag.id!)
        } else {
            tag.ownerID = userID
        }
                
        
        
        // MARK: - here I disabled the uploadImage because i want to upload right after the imagePicker
        

        
        do {
            try document.setData(from: tag)
            handler(true)
            
        } catch let error {
            print("Error upload journal to Firestore: \(error)")
            handler(false)
        }


    }
    
    
    func deleteTag(tag: Tag, handler: @escaping (_ success: Bool) -> ()){
        
        guard let userID = AuthViewModel.shared.currentUser?.id else {
            print("userID is not valid")
            return }
        
        if tag.id != nil {
            let document = COLLECTION_USERS.document(userID).collection("tags").document(tag.id!)
            document.delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                    handler(false)
                    return
                } else {
                    print("Document successfully removed!")
                    handler(true)
                    return
                }
            }
        } else {
            print("tag id is not available, means it's not yet uploaded into the firestore")
            handler(false)
            return
        }
        
    }
    
    
    
    
    func fetchTags(handler: @escaping (_ success: Bool) -> ()) {
        guard let userID = AuthViewModel.shared.currentUser?.id else {
            print("userID is not valid here in fetchTags function")
            return
        }
        
        COLLECTION_USERS.document(userID).collection("tags").order(by: "linkedIDCount", descending: true).getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            self.fetchedTags = documents.compactMap({try? $0.data(as: Tag.self)})
            handler(true)
        }
    }
    
    
    func fetchTags(from tagIDs:[String], handler: @escaping (_ success: Bool) -> ()) {
        guard let userID = AuthViewModel.shared.currentUser?.id else {
            print("userID is not valid here in fetchTags function")
            return
        }
        if tagIDs.isEmpty == true {
            self.fetchedTags = [Tag]()
            handler(true)
        }
        
        COLLECTION_USERS.document(userID).collection("tags").whereField("id", in: tagIDs).order(by: "linkedIDCount", descending: true).getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            self.fetchedTags = documents.compactMap({try? $0.data(as: Tag.self)})
            handler(true)
        }
    }


}
