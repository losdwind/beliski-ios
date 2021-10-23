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
        self.tagNames = Set(tagNamesOfItem)
//        self.ownerItemID = ownerItemID
        self.fetchAllTags { success in
            if success {
                completion(true)
            } else{
                completion(false)
            }
        }
    }
    
    init(){
    }
    
    
   
    

    @Published var tempTag: Tag = Tag() //used for update the tag in database
    
    @Published var tagNames:Set<String> = Set<String>()
    
    
    @Published var ownerItemID: String = ""
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
    
    
    

    func uploadTag(handler:@escaping (_ success:Bool) -> ()) {
        guard let userID = AuthViewModel.shared.currentUser?.id else {
            print("userID is not valid in uploadTag func")
            return }

        COLLECTION_USERS.document(userID).collection("tags").whereField("name", isEqualTo: tempTag.name).getDocuments { snapshot, _ in
            
            guard let documents = snapshot?.documents else {
                
                let newDocument = COLLECTION_USERS.document(userID).collection("tags").document()
                
                self.tempTag.linkedID.append(self.ownerItemID)

                self.tempTag.ownerID  = userID
                
                try newDocument.setData(from: self.tempTag){ err in
                    if let err = err {
                        print("unable to set new tag data to firebase \(err)")
                        handler(false)
                        return
                    } else {
                        print("successfully to set new tag data to firebase")
                        handler(true)
                        return
                    }
                }
                    
                
            }
            
            let tags = documents.compactMap({try? $0.data(as: Tag.self)})
            
            if tags.count == 1 && tags[0].id != nil{
                print("there exist duplicate tags in the database")
                
                let OldDocument = COLLECTION_USERS.document(userID).collection("tags").document(tags[0].id!)
                
                OldDocument.updateData(
                        ["linkedID": FieldValue.arrayUnion([self.ownerItemID]),
                         "serverTimestamp": FieldValue.serverTimestamp()
                        ]
                    ){ err in
                        if let err = err {
                            print("Error upload the tag to firebase: \(err)")
                            handler(false)
                            return
                        } else {
                            print("successfully uploaded the tag to firebase!")
                            handler(true)
                            return
                        }
                        
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
