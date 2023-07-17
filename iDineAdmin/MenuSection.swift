//
//  MenuSection.swift
//  iDineAdmin
//
//  Created by Nick Thacke on 7/12/23.
//
import Foundation

struct MenuSection : Identifiable {
    var id : UUID
    var name : String
    var items : [MenuItem]
    
    init(name: String) {
        self.items = [MenuItem]()
        self.name = name
        self.id = UUID()
    }
    
    init(name: String, items : [MenuItem]) {
        self.init(name:name)
        self.items = items
    }
    
    mutating func append(item : MenuItem) {
        items.append(item)
    }
}
