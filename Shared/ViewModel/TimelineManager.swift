//
//  TimelineManager.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/16.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class TimelineManager: ObservableObject {
    
    static let shared = TimelineManager()
    
    @Published var selectedMainTab:MainTab = .timeline
    
    @Published var selectedTab:TimelineTab = .MOMENTS
    @Published var selectedMenu:SearchType = .branch

    
    @Published var showFilterView: Bool = false
    
    @Published var showSearchView: Bool = false
    @Published var theme:Theme = .full
//
//
//    @Published var todayItems:[Any] = []
//
//    func fetchTodayItems(handler: @escaping (_ success: Bool) -> ()) {
//        guard let userID = AuthViewModel.shared.currentUser?.id else {
//            print("userID is not valid here in fetchMoment function")
//            return
//        }
//
//        let group = DispatchGroup()
//
//        let dayStart = Calendar.current.startOfDay(for: Date())
//
//
//        group.enter()
//        COLLECTION_USERS.document(userID).collection("moments").whereField("localTimestamp", isGreaterThanOrEqualTo: Timestamp(date: dayStart)).order(by: "localTimestamp", descending: true).getDocuments { snapshot, _ in
//            guard let documents = snapshot?.documents else { return }
//            self.todayItems.append(documents.compactMap({try? $0.data(as: Moment.self)}))
//            group.leave()
//        }
//
//        group.enter()
//        COLLECTION_USERS.document(userID).collection("todos").whereField("localTimestamp", isGreaterThanOrEqualTo: Timestamp(date: dayStart)).order(by: "localTimestamp", descending: true).getDocuments { snapshot, _ in
//            guard let documents = snapshot?.documents else { return }
//            self.todayItems.append(documents.compactMap({try? $0.data(as: Todo.self)}))
//            group.leave()
//        }
//
//        group.enter()
//        COLLECTION_USERS.document(userID).collection("persons").whereField("localTimestamp", isGreaterThanOrEqualTo: Timestamp(date: dayStart)).order(by: "localTimestamp", descending: true).getDocuments { snapshot, _ in
//            guard let documents = snapshot?.documents else { return }
//            self.todayItems.append(documents.compactMap({try? $0.data(as: Person.self)}))
//            group.leave()
//        }
//
//        group.notify(queue: .main){
////            self.todayItems.sort { (item1, item2) -> Bool in
////                item1.localTimestamp < item2.localTimestamp
////            }
//
//            // https://stackoverflow.com/questions/24130026/swift-how-to-sort-array-of-custom-objects-by-property-value
////            self.todayItems.sort(by: { $0.localTimestamp < $1.localTimestamp
////            })
//            handler(true)
//        }
//
//    }
    
}
