//
//  AdminAccount.swift
//  iDineAdmin
//
//  Created by Nick Thacke on 7/19/23.
//

import Foundation
import SwiftUI

class AdminAccount {
    
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
    
    
    init(id : String, restaurantName : String, restaurantLocation : String, email : String, restaurantImage : String, layoutStyle : String) {
        self.id = id
        self.restaurantName = restaurantName
        self.restaurantLocation = restaurantLocation
        self.email = email
        self.restaurantImage = restaurantImage
        self.layoutStyle = layoutStyle
    }
}
