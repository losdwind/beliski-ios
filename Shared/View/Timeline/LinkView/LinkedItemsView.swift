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
                
                
                Text("Moments")
                    .font(.title3.bold())
                
                    ForEach(dataLinkedManager.linkedMoments){
                        moment in
                        MomentItemView(moment: moment, tagNames: moment.tagNames, OwnerItemID: moment.id)
                    }
                

                
                
                
                Text("Todos")
                    .font(.title3.bold())
                    ForEach(dataLinkedManager.linkedTodos){
                        todo in
                        TodoRowItemView(todo: todo)
                    }

                Text("Persons")
                    .font(.title3.bold())
                
                    ForEach(dataLinkedManager.linkedPersons){
                        person in
                        PersonItemView(person: person, tagNames: person.tagNames, OwnerItemID: person.id, isShowingPhtos: false, isShowingDescription: false, isShowingTags: true)
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
