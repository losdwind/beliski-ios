//
//  CommunityView.swift
//  Beliski-Firebase
//
//  Created by Wind Losd on 2021/9/17.
//

import SwiftUI

struct CommunityView: View {
    @ObservedObject var communityvm:CommunityViewModel
    @ObservedObject var dataLinkedManager:DataLinkedManager
    
    @State var isShowingLocationPickerView:Bool = false
    @State var isShowingNotificationView:Bool = false
    
    
    
    var body: some View {
        NavigationView{
            ScrollView(.vertical, showsIndicators: false){
                CategoryView(communityvm: communityvm, dataLinkedManager: dataLinkedManager)
                
                VStack(alignment: .leading){
                    //                CarouselView(branches: $communityvm.openBranchs)
                    
                    Text("Subscribed")
                        .font(.title3.bold())
                        .padding(.top)
                    
                    ScrollView(.horizontal, showsIndicators: false){
                        SubscribedBranchView(communityvm: communityvm, dataLinkedManager: dataLinkedManager)
                    }
                    
                    
                    Text("Trending")
                        .font(.title3.bold())
                        .padding(.top)
                    
                    PopularBranchView(communityvm: communityvm, dataLinkedManager: dataLinkedManager)
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    //                Text("Top List")
                    //                    .font(.title3.bold())
                    //                    .frame(maxWidth: .infinity,alignment: .leading)
                    
                    
                }
                .padding()
                
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            isShowingLocationPickerView.toggle()
                        } label: {
                            HStack{
                                Image(systemName: "mappin.circle")
                                Text(communityvm.selectedLocation?.m ?? "Solar System")
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
                .fullScreenCover(isPresented: $isShowingLocationPickerView) {
                    LocationPickerView(communityvm: communityvm)
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
                
                communityvm.fetchSubscribedBranches { success in
                    if success {
                        print("successfully fetched the subscribed Branchs")
                    } else {
                        print("failed to fetch the subscribed branchs")
                    }
                }
                
                //
                //                communityvm.getUserSubscribe { success in
                //                    if success {
                //                        print("successfully fetched the subscribe history")
                //                    } else {
                //                        print("failed to fetch the subscribe history")
                //                    }
                //                }
            }
            .navigationTitle("Community")
            //        .navigationViewStyle(StackNavigationViewStyle())
            
            
        }
        
    }
}

struct CommunityView_Previews: PreviewProvider {
    static var previews: some View {
        CommunityView(communityvm: CommunityViewModel(), dataLinkedManager: DataLinkedManager())
    }
}
