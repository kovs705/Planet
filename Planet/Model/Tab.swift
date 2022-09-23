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
    @objc dynamic var url: String = ""
    @objc dynamic var initialURL: String = ""
    @objc dynamic var title: String = ""
    
    var tabDescription: String {
        let urlDesc = "URL: \(url)\n"
        let initialURLDesc = "Initial URL: \(initialURL)\n"
        let titleDesc = "Title: \(title)\n"
        
        return "Tab information: \n\(urlDesc)\(initialURLDesc)\(titleDesc)\n"
    }
}

