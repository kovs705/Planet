//
//  Tab.swift
//  Planet
//
//  Created by Kovs on 20.09.2022.
//

import Foundation
import RealmSwift

// MARK: - TAB MODEL

class Tab: Object { // Object - Realm object
    dynamic var url: String = ""
    dynamic var initialURL: String = ""
    dynamic var title: String = ""
    
    var tabDescription: String {
        let urlDesc = "URL: \(url)\n"
        let initialURLDesc = "Initial URL: \(initialURL)\n"
        let titleDesc = "Title: \(title)\n"
        
        return "Tab information: \n\(urlDesc)\(initialURLDesc)\(titleDesc)\n"
    }
}
