//
//  TagPanelViewModel.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/21.
//

import Foundation

class TagPanelViewModel:ObservableObject {
    
    @Published var fetchedTags:[Tag] = [Tag]()
    
    
    
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
    
}
