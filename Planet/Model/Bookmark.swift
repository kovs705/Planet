//
//  Bookmark.swift
//  Planet
//
//  Created by Kovs on 20.09.2022.
//

import Foundation
import RealmSwift

class Bookmark: Object {
    @objc dynamic var url: String = ""
    @objc dynamic var title: String = ""
    
    override static func primaryKey() -> String? {
        return "url"
    }
    
    var bookmarkDescription: String {
        let urlDesc = "URL: \(url)\n"
        let titleDesc = "Title: \(title)\n"
        
        return "Bookmark information: \n\(urlDesc)\(titleDesc)\n"
    }
}
