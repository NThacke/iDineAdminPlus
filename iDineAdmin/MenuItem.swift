//
//  MenuItem.swift
//  iDineAdmin
//
//  Created by Nick Thacke on 7/12/23.
//

import Foundation

enum MenuType {
    case Breakfast
    case Lunch
    case Dinner
}

struct MenuItem : Identifiable, Equatable, Codable {
    
    static let classic = "classics"
    static let grilled = "grilled"
    
    static let GLUTEN_FREE = "Gluten Free"
    static let VEGETARIAN = "Vegetarian"
    static let VEGAN = "Vegan"
    
    
    var id : String
    var name : String
    var menuType : String
    var sectionType : String
    var image : String
    var price : String
    var description : String
    var restrictions : String
    
        // Equatable protocol implementation
       public static func == (lhs: MenuItem, rhs: MenuItem) -> Bool {
           return lhs.name == rhs.name
       }
    
    
    
    /**
            Name : the name of the menu item
            Type: The type of menu item (breakfast, lunch, or dinner)
            Image: the image (path) of the image that this menu item should refer to as
     */
    init(name: String, type: String, section: String, image: String, price : String, description: String, restrictions: String) {
        self.id = UUID().uuidString
        self.name = name;
        self.menuType = type;
        self.image = image;
        self.price = price;
        self.description = description;
        self.sectionType = section
        self.restrictions = restrictions
    }
    
    static func example() -> MenuItem {
        let r = GLUTEN_FREE + "," + VEGAN + "," + VEGETARIAN
        return MenuItem(name : "Pancakes", type : "breakfast", section:MenuItem.classic, image : "pancakes", price : "5.00", description: "Fluffy and our syrup comes from Maple Syrup", restrictions : r)
    }
}
