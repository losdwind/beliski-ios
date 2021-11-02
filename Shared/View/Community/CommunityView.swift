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
            VStack{
//                CarouselView(branches: $communityvm.openBranchs)
                
                CategoryView(communityvm: communityvm, dataLinkedManager: dataLinkedManager)
                
                
                
                BranchCardPublicListView(communityvm: communityvm, dataLinkedManager: dataLinkedManager)
        
                
            }
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
        .navigationViewStyle(StackNavigationViewStyle())
        
        
    }
    
}

struct CommunityView_Previews: PreviewProvider {
    static var previews: some View {
        CommunityView(communityvm: CommunityViewModel(), dataLinkedManager: DataLinkedManager())
    }
}
