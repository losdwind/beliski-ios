//
//  TagViewModel.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/18.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestoreSwift

class TagViewModel: ObservableObject {
    
//
//    @DocumentID var id:String?
//    var name: String = ""
//    var linkedID:[String] = []
//    var linkedIDCount:Int {
//        linkedID.count
//    }
//    var size: CGFloat = 0
    
    init(tagNamesOfItem: [String], ownerItemID: String, completion: @escaping (_ success: Bool) -> ()){
        self.tagName = ""
        self.tagNames = Set(tagNamesOfItem)
        self.ownerItemID = ownerItemID
//        self.fetchAllTags { success in
//            if success {
//                completion(true)
//            } else{
//                completion(false)
//            }
//        }
    }
    
    init(){
        self.tagName = ""
        self.tagNames = Set([])
        self.ownerItemID = "unknown"
    }
    

    
    @Published var tagName:String
    @Published var tagNames:Set<String>
    
    
    @Published var ownerItemID: String
    @Published var fontSize:CGFloat = 16
    @Published var maxLimit:Int = 150
    
    @Published var tagsOfAll: Set<Tag> = Set<Tag>()

    
   
    // Basic Logic..
    // Splitting the array when it exceeds the screen size....
    func getTagNamesByRows(tagNames: Set<String>)->[[String]]{
        
        var rows: [[String]] = []
        var currentRow: [String] = []
        
        // caluclating text width...
        var totalWidth: CGFloat = 0
        
        // For safety extra 10....
        let screenWidth: CGFloat = UIScreen.main.bounds.width - 90
        
        tagNames.forEach { tagName in
            
            let font = UIFont.systemFont(ofSize: self.fontSize)
            
            let attributes = [NSAttributedString.Key.font: font]
            
            let size = (tagName as NSString).size(withAttributes: attributes).width
            // updating total width...
            
            // adding the capsule size into total width with spacing..
            // 14 + 14 + 6 + 6
            // extra 6 for safety...
            totalWidth += (size + 40)
            
            // checking if totalwidth is greater than size...
            if totalWidth > screenWidth{
                
                // adding row in rows...
                // clearing the data...
                // checking for long string...
                totalWidth = (!currentRow.isEmpty || rows.isEmpty ? (size + 40) : 0)
                
                rows.append(currentRow)
                currentRow.removeAll()
                currentRow.append(tagName)
                
            }else{
                currentRow.append(tagName)
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
    
    
    

    func uploadTag(tagName:String, ownerItemID:String, handler:@escaping (_ success:Bool) -> ()) {
        guard let userID = AuthViewModel.shared.currentUser?.id else {
            print("userID is not valid in uploadTag func")
            return }

        COLLECTION_USERS.document(userID).collection("tags").document(tagName).getDocument { (document, error) in
            if let document = document, document.exists {
                COLLECTION_USERS.document(userID).collection("tags").document(tagName).updateData(
                    ["linkedID": FieldValue.arrayUnion([ownerItemID])]
                ){ err in
                    if let err = err {
                        print("already have a tag in firebase but error to update the tag to firebase: \(err)")
                        handler(false)
                        return
                    } else {
                        print("already have a tag in firebase and successfully update the tag to firebase!")
                        handler(true)
                        return
                    }
                    
                }
                
                } else {
                    
                    var tempTag = Tag()
                    tempTag.name = tagName
                    tempTag.linkedID.append(ownerItemID)
                    tempTag.ownerItemID  = userID
                    
                    do {
                        try COLLECTION_USERS.document(userID).collection("tags").document(tempTag.name).setData(from: tempTag)
                        print("Tag not exist in the firebase and have created tempTag in Firestore")
                        handler(true)
                        return
                    } catch let error {
                        print("Tag not exist in the firebase but have error writing tempTag to Firestore: \(error)")
                        handler(false)
                        return
                    }
                    
                }
        }
        
    }

    
    /// delete one of the tagname of an item
    func deleteTag(tagName: String,ownerItemID:String, handler: @escaping (_ success: Bool) -> () ){
        guard let userID = AuthViewModel.shared.currentUser?.id else {
            print("userID is not valid")
            return }
        
        COLLECTION_USERS.document(userID).collection("tags").document(tagName).updateData(
            ["linkedID": FieldValue.arrayRemove([ownerItemID])]
        ){ err in
            if let err = err {
                print("already have a tag in firebase but error to update the tag to firebase: \(err)")
                handler(false)
                return
            } else {
                print("already have a tag in firebase and successfully update the tag to firebase!")
                handler(true)
                return
            }
            
        }
        
        
    }
    
    
    
    /// delete the whole tag in firebase: dangerous!
    func deleteTag(tag: Tag, handler: @escaping (_ success: Bool) -> ()){
        
        guard let userID = AuthViewModel.shared.currentUser?.id else {
            print("userID is not valid")
            return }
        
        COLLECTION_USERS.document(userID).collection("tags").document(tag.name).delete() { err in
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
   
        
    }
    
    
        func fetchAllTags(handler: @escaping (_ success: Bool) -> ()) {
            guard let userID = AuthViewModel.shared.currentUser?.id else {
                print("userID is not valid here in fetchTags function")
                return
            }
    
            COLLECTION_USERS.document(userID).collection("tags").order(by: "linkedIDCount", descending: true).getDocuments { snapshot, _ in
                guard let documents = snapshot?.documents else { return }
                self.tagsOfAll = Set(documents.compactMap({try? $0.data(as: Tag.self)}))
                handler(true)
                return
            }
        }
    

    /// fetchTags from tagNames
//    func fetchTags(from tagNames:Set<String>, handler: @escaping (_ success: Bool) -> ()) {
//        guard let userID = AuthViewModel.shared.currentUser?.id else {
//            print("userID is not valid here in fetchTags function")
//            return
//        }
//
//        if tagNames.isEmpty == true {
//            self.TagsofItem = Set<Tag>()
//            handler(true)
//            return
//        }
//
//        COLLECTION_USERS.document(userID).collection("tags").whereField("id", in: Array(tagIDs)).order(by: "linkedIDCount", descending: true).getDocuments { snapshot, _ in
//            guard let documents = snapshot?.documents else { return }
//            self.TagsofItem = Set(documents.compactMap({try? $0.data(as: Tag.self)}))
//            handler(true)
//            return
//        }
//    }
    
    
    


}
