//
//  MomentLinkedView.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/15.
//

import SwiftUI

struct LinkedItemsView: View {
    
    @ObservedObject var dataLinkedManager: DataLinkedManager
    
    
    var body: some View {
        
        // TODO: - add a list without segemeting
        ScrollView(.vertical, showsIndicators: false){
            LazyVStack(alignment:.leading) {
                
                
//                Text("Moments")
//                    .font(.title3.bold())
//
//                    ForEach(dataLinkedManager.linkedMoments){
//                        moment in
//                        MomentItemView(moment: moment, tagNames: moment.tagNames, OwnerItemID: moment.id)
//                    }
//
//
//
//
//
//                Text("Todos")
//                    .font(.title3.bold())
//                    ForEach(dataLinkedManager.linkedTodos){
//                        todo in
//                        TodoRowItemView(todo: todo)
//                    }
//
//                Text("Persons")
//                    .font(.title3.bold())
//
//                    ForEach(dataLinkedManager.linkedPersons){
//                        person in
//                        PersonItemView(person: person, tagNames: person.tagNames, OwnerItemID: person.id, isShowingPhtos: false, isShowingDescription: false, isShowingTags: true)
//                    }
                
                ForEach(0..<dataLinkedManager.linkedItems.count){ i in
                    
                    if let item = dataLinkedManager.linkedItems[i] {
                        if item.keys.first == "moment" {
                            if let moment = try? Moment(dictionary: item["moment"] as! [String : Any]){
                                MomentItemView(moment: moment, tagNames: moment.tagNames, OwnerItemID: moment.id)
                            }
                            
                        }
                        
                        if item.keys.first == "todo"{
                            if let todo = try? Todo(dictionary: item["todo"] as! [String : Any]){
                                TodoRowItemView(todo: todo)
                            }
                        }
                        
                        if item.keys.first == "person"{
                            if let person = try? Person(dictionary: item["person"] as! [String : Any]){
                                PersonItemView(person: person, tagNames: person.tagNames, OwnerItemID: person.id, isShowingPhtos: false, isShowingDescription: false, isShowingTags: true)
                            }
                            
                        }
                        
                        if item.keys.first == "branch" {
                            if let branch = try? Branch(dictionary: item["branch"] as! [String: Any]){
                                BranchCardView(branch: branch)
                            }
                            
                        }
                        // https://stackoverflow.com/questions/29552399/should-a-dictionary-be-converted-to-a-class-or-struct-in-swift
                    }
                }

            }
            
        }
        .padding()
        .navigationTitle("Linked Items")
        
        
    }
}

struct LinkedItemsView_Previews: PreviewProvider {
    static var previews: some View {
        LinkedItemsView(dataLinkedManager: DataLinkedManager())
    }
}
