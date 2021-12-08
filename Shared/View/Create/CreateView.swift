//
//  CreateView.swift
//  Beliski-Firebase
//
//  Created by Wind Losd on 2021/9/17.
//

import SwiftUI


struct CreateView: View {
    
    @ObservedObject var momentvm: MomentViewModel
    @ObservedObject var todovm: TodoViewModel
    @ObservedObject var personvm: PersonViewModel
    @ObservedObject var branchvm:BranchViewModel
    
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        NavigationView {
            VStack(spacing:0){
                
                PPCarouselView(cards: PPCards)
                
                NewGridView(momentvm: momentvm, todovm: todovm, personvm: personvm, branchvm: branchvm)
                
                Spacer()
                
            }
            .padding()
            .navigationTitle("Create")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.pink)
                    }
                    
                }
            }
        }
        
    }
}

struct CreateView_Previews: PreviewProvider {
    static var previews: some View {
        CreateView(momentvm: MomentViewModel(), todovm: TodoViewModel(), personvm: PersonViewModel(), branchvm: BranchViewModel())
    }
}
