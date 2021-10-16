//
//  PersonListView.swift
//  Beliski
//
//  Created by Wind Losd on 2021/5/25.
//

import SwiftUI

struct PersonListView: View {
    @ObservedObject var personvm: PersonViewModel
    
    var body: some View {
        NavigationView{
            ScrollView(.vertical, showsIndicators: true){
                LazyVStack{
                    ForEach(personvm.fetchedPersons){ person in
                       
                        NavigationLink {
                            PersonDetailView(person:person)
                        } label: {
                            PersonItemView(person: person)
                        }

                        
                    }
                }
            }
        }
        
    }
}

struct PersonListView_Previews: PreviewProvider {
    static var previews: some View {
        PersonListView(personvm: PersonViewModel())
    }
}
