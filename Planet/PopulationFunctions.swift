//
//  PopulationFunctions.swift
//  Planet
//
//  Created by Kovs on 21.09.2022.
//

import Foundation
import RealmSwift

// check are there any tabs:
func isRealmPopulatedWithDefaultTab() -> Bool {
    let realm = try! Realm()
    if realm.objects(Tab.self).count < 0 {
        return true
    }
    
    return false
}

// create default tab:
func populateRealmDefaultTab() {
    let realm = try! Realm()
    let defaultTab: Tab = Tab(value: ["url": "https://google.com", "initialURL": "https://google.com", "title": "Google"])
    
    try! realm.write {
        realm.add(defaultTab)
    }
}

