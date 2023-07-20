//
//  AdminAccount.swift
//  iDineAdmin
//
//  Created by Nick Thacke on 7/19/23.
//

import Foundation
import SwiftUI

class AdminAccount : Codable {
    
    //The ID of this account
    var id : String
    
    //The restaurant name associated with this account
    var restaurantName : String
    
    //The restaurant location associated with this account
    var restaurantLocation : String
    
    //The email associated with this account
    var email : String
    
    //The restaurant image associated with this account that is used throughout the app (client)
    var restaurantImage : String
    
    //The layout style of this restaurant's menu
    var layoutStyle : String
    
    var visibility : String
    
    
    init(id : String, restaurantName : String, restaurantLocation : String, email : String, restaurantImage : String, layoutStyle : String, visibility : String) {
        self.id = id
        self.restaurantName = restaurantName
        self.restaurantLocation = restaurantLocation
        self.email = email
        self.restaurantImage = restaurantImage
        self.layoutStyle = layoutStyle
        self.visibility = visibility
    }
    
    static func example() -> AdminAccount {
        return AdminAccount(
            id : "A904844B-6537-4A57-8710-EE5317B6687D",
            restaurantName : "Example",
            restaurantLocation : "Example",
            email : "example@gmail.com",
            restaurantImage : "image",
            layoutStyle : "1",
        visibility: "false");
    }
}
