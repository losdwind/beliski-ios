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
    
    init(tagIDs: [String], ownerItemID: String, completion: @escaping (_ success: Bool) -> ()){
        self.tagIDs = Set(tagIDs)
        self.ownerItemID = ownerItemID
        self.fetchTags(from: Set(tagIDs)) { success in
            if success {
                completion(true)
            } else{
                completion(false)
            }
        }
    }
    
    init(){
        self.ownerItemID = ""
    }
    
    @Published var ownerItemID: String
    
    @Published var tag: Tag = Tag() //used for update the tag in database
    
    @Published var TagsofItem:Set<Tag> = Set<Tag>()
    
    @Published var tagIDs:Set<String> = Set<String>()
    
    var size: CGFloat = 0
    @Published var fontSize:CGFloat = 16
    @Published var maxLimit:Int = 150
    
    
    // check tag if its size meet the requirement
    func checkTagLimit(text: String, completion: @escaping (Bool,Tag)->()){
        
        // getting Text Size according to different fontSize
        let font = UIFont.systemFont(ofSize: fontSize)
        
        let attributes = [NSAttributedString.Key.font: font]
        
        let size = (text as NSString).size(withAttributes: attributes)
        
//        @DocumentID var id:String?
//        @ServerTimestamp var serverTimestamp: Timestamp?
//        var localTimestamp: Timestamp?
//        var ownerID: String = "unknown"
//        var name: String = ""
//        var linkedID:[String] = []
//        var linkedIDCount:Int {
//            linkedID.count
//        }
//        var size: CGFloat = 0
        
        let tag = Tag(name: text, size: size.width)
        
        if (getSize(tags: TagsofItem) + text.count) < maxLimit{
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
    func getSize(tags: Set<Tag>)->Int{
        var count: Int = 0
        
        tags.forEach { tag in
            count += tag.name.count
        }
        
        return count
    }
    
    // Basic Logic..
    // Splitting the array when it exceeds the screen size....
    func getTagsByRows(TagsofItemSet:Set<Tag>)->[[Tag]]{
        
        var rows: [[Tag]] = []
        var currentRow: [Tag] = []
        
        // caluclating text width...
        var totalWidth: CGFloat = 0
        
        // For safety extra 10....
        let screenWidth: CGFloat = UIScreen.main.bounds.width - 90
        
        TagsofItemSet.forEach { tag in
            
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
    
    
    

    func uploadTag(handler:@escaping (_ success:Bool) -> ()) {
        guard let userID = AuthViewModel.shared.currentUser?.id else {
            print("userID is not valid in uploadTag func")
            return }

        COLLECTION_USERS.document(userID).collection("tags").whereField("name", isEqualTo: tag.name).getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else {
                let newDocument = COLLECTION_USERS.document(userID).collection("tags").document()
                self.tag.linkedID.append(self.ownerItemID)
                self.tag.ownerID  = userID
                
                do {
                    try newDocument.setData(from: self.tag)
                    handler(true)
                    return
                    
                } catch let error {
                    print("Error upload journal to Firestore: \(error)")
                    handler(false)
                    return
                }
            }
            
            let tags = documents.compactMap({try? $0.data(as: Tag.self)})
            
            if tags.count == 1 && tags[0].id != nil{
                print("there exist duplicate tags in the database")
                handler(false)
                return
            } else {
                self.tag = tags[0]
                self.tag.linkedID.append(self.ownerItemID)
                let OldDocument = COLLECTION_USERS.document(userID).collection("tags").document(self.tag.id!)
                do {
                    try OldDocument.setData(from: self.tag)
                    print("there exist one tag in the database, now merging.")
                    handler(true)
                    return
                    
                } catch let error {
                    print("Error update tag info to Firestore: \(error)")
                    handler(false)
                    return
                }
            }
            
            
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
    
    

    
    func fetchTags(from tagIDs:Set<String>, handler: @escaping (_ success: Bool) -> ()) {
        guard let userID = AuthViewModel.shared.currentUser?.id else {
            print("userID is not valid here in fetchTags function")
            return
        }
        
        if tagIDs.isEmpty == true {
            self.TagsofItem = Set<Tag>()
            handler(true)
            return
        }
        
        COLLECTION_USERS.document(userID).collection("tags").whereField("id", in: Array(tagIDs)).order(by: "linkedIDCount", descending: true).getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            self.TagsofItem = Set(documents.compactMap({try? $0.data(as: Tag.self)}))
            handler(true)
            return
        }
    }


}
