//
//  SearchViewModel.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/15.
//

import Foundation

//enum SearchItemConfig {
//    case followers(String)
//    case following(String)
//    case likes(String)
//    case search
//    case newMessage
//}

class SearchViewModel: ObservableObject {
    
    @Published var items: [Any] = [Any]()
    
    
}
