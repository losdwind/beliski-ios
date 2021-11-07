//
//  CommunityView.swift
//  Beliski-Firebase
//
//  Created by Wind Losd on 2021/9/17.
//

import SwiftUI


enum Area: String, CaseIterable {
    case Beijing
    case Shanghai
    case Chongqing
}


struct CommunityView: View {
    @ObservedObject var communityvm:CommunityViewModel
    @ObservedObject var dataLinkedManager:DataLinkedManager

    
    @State var area:Area = .Beijing
    @State var isShowingNotificationView:Bool = false
    

    
    var body: some View {
        NavigationView{
            ScrollView(.vertical, showsIndicators: false){
            VStack{
//                CarouselView(branches: $communityvm.openBranchs)
                
                CategoryView(communityvm: communityvm, dataLinkedManager: dataLinkedManager)
                
                Text("Subscribed")
                    .font(.title3.bold())
                    .frame(maxWidth: .infinity,alignment: .leading)
                
                VStack{
                    ForEach(communityvm.fetchedSubscribedBranches, id: \.self) { branch in
                        
                        NavigationLink{
                            LinkedItemsView(dataLinkedManager: dataLinkedManager)
                        } label: {
                            BranchCardView(branch: branch)
                        }
                        .onTapGesture(perform: {
                            dataLinkedManager.linkedIds = branch.linkedItems
                            dataLinkedManager.fetchItems { success in
                                if success {
                                    print("successfully loaded the linked Items from DataLinkedManager")

                                } else {
                                    print("failed to loaded the linked Items from DataLinkedManager")
                                }
                            }
                        })
                    }
                    
                }

                Text("Popular Around")
                    .font(.title3.bold())
                    .frame(maxWidth: .infinity,alignment: .leading)
                PopularBranchView(communityvm: communityvm, dataLinkedManager: dataLinkedManager)
        
                
//                Text("Top List")
//                    .font(.title3.bold())
//                    .frame(maxWidth: .infinity,alignment: .leading)
                
                
            }
            .padding()
                
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Menu {
                        ForEach(Area.allCases, id:\.self){ areaName in
                            Button {
                                area = areaName
                            } label: {
                                Text(areaName.rawValue)
                            }
                        }
                        

                    } label: {
                        HStack{
                            Image(systemName: "mappin.circle")
                            Text(area.rawValue)
                        }
                    }

                }
                
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isShowingNotificationView.toggle()
                    } label: {
                        Image(systemName: "bell.badge")
                    }

                }
            }
            .sheet(isPresented: $isShowingNotificationView){
                NotificationView()
            }
        }
            .onAppear {
                communityvm.fetchPublicBranches { success in
                    if success {
                        print("successfully fetched the public Branchs")
                    } else {
                        print("failed to fetch the public branchs")
                    }
                }
                
            }
            
            .onAppear {
                communityvm.fetchSubscribedBranches { success in
                    if success {
                        print("successfully fetched the subscribed Branchs")
                    } else {
                        print("failed to fetch the subscribed branchs")
                    }
                }
            }
        }
//        .navigationViewStyle(StackNavigationViewStyle())
        
        
    }
    
}

struct CommunityView_Previews: PreviewProvider {
    static var previews: some View {
        CommunityView(communityvm: CommunityViewModel(), dataLinkedManager: DataLinkedManager())
    }
}
