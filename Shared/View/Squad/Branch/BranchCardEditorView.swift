//
//  BranchCardEditingView.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/28.
//

import SwiftUI

import SwiftUI

struct BranchCardEditorView: View {
    
    @ObservedObject var branchvm: BranchViewModel
    
    @Environment(\.presentationMode) var presentationMode
    
    // Show Picker..
    @State var showDatePicker = false
    
    @State var currentBranchOpenessType = "Public"
    
    @State var isShowingAddCollaboratorView:Bool = false
    
    var body: some View {
        
        ScrollView(UIScreen.main.bounds.height < 850 ? .vertical : .init(), showsIndicators: false, content: {
            
            VStack(spacing: 20){
                
                HStack{
                    
                    Button {
                        
                        withAnimation{
                            presentationMode.wrappedValue.dismiss()
                        }
                        
                    } label: {
                        Image(systemName: "arrow.left")
                            .font(.title2)
                            .foregroundColor(.black)
                    }
                    
                    Spacer()

                    Image("Profile")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                }
                .overlay(
                
                    Text("New Branch")
                        .font(.system(size: 18))
                )
                
                VStack(alignment: .leading, spacing: 15) {
                    
                    Text("Branch Title")
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                    
                    TextField("e.g. Fishing", text: $branchvm.branch.title)
                    // Making it bold...
                        .font(.system(size: 16).bold())
                    
                    Divider()
                }
                .padding(.top,10)
                
                VStack(alignment: .leading, spacing: 15) {
                    
                    Text("Branch Description")
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                    
                    TextField("e.g. activity details", text: $branchvm.branch.description)
                    // Making it bold...
                        .font(.system(size: 16).bold())
                        .lineLimit(4)
                    
                    Divider()
                }
                .padding(.top,10)
                
                VStack(alignment: .leading, spacing: 15) {
                    
                    Text("Active Slot")
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                    
                    HStack{
                        
                        
                        TextField("e.g. Everyday 20:00-21:00", text: $branchvm.branch.timeSlot)
                            .font(.system(size: 16).bold())
                        
                        Spacer(minLength: 10)
                        
                        // Custom Date Picker...
                        Button {
                            
                            withAnimation{
                                showDatePicker.toggle()
                            }
                            
                        } label: {
                            Image(systemName: "calendar")
                                .foregroundColor(.black)
                        }

                    }
                    
                    Divider()
                }
                .padding(.top,10)
                
                VStack(alignment: .leading, spacing: 15) {
                    
                    Text("Select Colloborators")
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                    

                    HStack(spacing: 0){
                        
                        ForEach(1...3,id: \.self){index in
                            
                            Image("animoji\(index)")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20, height: 20)
                                .padding(4)
                                .background(.white,in: Circle())
                            // border...
                                .background(
                                
                                    Circle()
                                        .stroke(.black,lineWidth: 1)
                                )
                        }
                        
                        Spacer(minLength: 10)
                        
                        Button {
                            isShowingAddCollaboratorView.toggle()
                        } label: {
                            Text("Add \(branchvm.branch.memberIDs.count)/5")
                                .font(.caption)
                                .foregroundColor(.black)
                                .padding(.vertical,10)
                                .padding(.horizontal,20)
                                .background(
                                
                                    Capsule()
                                        .stroke(.black,lineWidth: 1)
                                )
                        }

                    }
                    
                    Divider()
                }
                .padding(.top,10)
                
                VStack(alignment: .leading, spacing: 18) {
                    
                    Text("Meeting Type")
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                    
                    // Simply Creating Array....
                    HStack(spacing: 15){
                        
                        ForEach(["Private","Public","On Invite"],id: \.self){tab in

                            OpenessTabButton(title: tab, currentType: $branchvm.branch.openess)
                        }
                    }
                    
                    Divider()
                }
                .padding(.top,10)
                
                Spacer(minLength: 10)
                
                // Schedule Button...
                Button {
                    branchvm.uploadBranch(completion: {success in
                        if success {
                            presentationMode.wrappedValue.dismiss()
                        }
                    })
                } label: {
                    Text("Post")
                        .padding(.vertical,6)
                        .padding(.horizontal,30)
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
                .tint(.black)
                .disabled(branchvm.branch.title == "")


            }
            .padding()
        })
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.gray.opacity(0.2))
//        .overlay(CustomDatePicker(date: $branchvm.branch.localTimestamp, showPicker: $showDatePicker))
        .transition(.move(edge: .bottom))
    }
}
// Meeting tab Button...
struct OpenessTabButton: View{
    var title: String
    @Binding var currentType: String
    
    var body: some View{
        
        Button {
            
            withAnimation{
                currentType = title
            }
            
        } label: {
            Text(title)
                .font(.footnote)
                .foregroundColor(title != currentType ? .black : .white)
                .padding(.vertical,8)
                // Max Width...
                .frame(maxWidth: .infinity)
                .background(
                
                    Capsule()
                        .stroke(.black,lineWidth: 1)
                )
                .background(
                
                    Capsule()
                        .fill(.black.opacity(title == currentType ? 1 : 0))
                )
        }

    }
}

// Custom Date Picker...
struct CustomDatePicker: View{
    
    @Binding var date: Date
    @Binding var showPicker: Bool
    
    var body: some View{
        
        ZStack{
            
            // Blur Effect...
            Rectangle()
                .fill(.ultraThinMaterial)
                .ignoresSafeArea()
            
            DatePicker("", selection: $date, displayedComponents: [.date,.hourAndMinute])
                .labelsHidden()
            
            // Close Button...
            Button {
                
                withAnimation{
                    showPicker.toggle()
                }
                
            } label: {
                Image(systemName: "xmark")
                    .foregroundColor(.white)
                    .padding()
                    .background(.gray,in: Circle())
            }
            .padding(10)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)

        }
        .opacity(showPicker ? 1 : 0)
    }
}

struct BranchCardEditorView_Previews: PreviewProvider {
    static var previews: some View {
        BranchCardEditorView(branchvm: BranchViewModel())
    }
}
