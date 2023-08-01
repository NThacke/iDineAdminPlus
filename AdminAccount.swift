//
//  AdminAccount.swift
//  iDineAdmin
//
//  Created by Nick Thacke on 7/19/23.
//

import Foundation
import SwiftUI

class AdminAccount : Codable {
    
    static let visible : String = "true"
    static let invisible : String = "false"
    
    var details : AccountDetails
    
    //The restaurant location associated with this account
    var address : AccountAddress
    
    
    init(details : AccountDetails, address : AccountAddress) {
        self.address = address
        self.details = details
    }
    
    static func example() -> AdminAccount {
        return AdminAccount(
            details : AccountDetails(id: "12345", restaurantName: "Example Name", email: "exmaple@gmail.com", restaurantImage: exampleImage(), layoutStyle: "1", visible: "false"),
            address : AccountAddress(region: "US", locality: "NJ", administrativeArea: "Eatontown", postalCode: "07724", line: "24 Redwood Dr")
            )
    }
    
    static func imageToString(image: UIImage) -> String? {
        print("Inside imageToString")
        if let imageData = image.jpegData(compressionQuality: 1.0) {
            return imageData.base64EncodedString()
        }
        return nil
    }
    
    /**
     This functon resized the given image into the given scaled size and returns the resized image back.
     */
    static func reiszeImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.draw(in: CGRectMake(0, 0, newSize.width, newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    private static func exampleImage() -> String {
        let image = UIImage(systemName : "fork.knife.circle")!
        return imageToString(image : image)!
    }
}

class AccountAddress : Codable {
    var region : String = ""
    var locality : String = ""
    var administrativeArea : String = ""
    var postalCode : String = ""
    var line : String = ""
    
    init(region : String, locality : String, administrativeArea : String, postalCode : String, line : String) {
        self.region = region
        self.locality = locality
        self.administrativeArea = administrativeArea
        self.postalCode = postalCode
        self.line = line
    }
}

class AccountDetails : Codable {
    //The id of this account
    var id : String
    //the name of this account
    var restaurantName : String
    
    //the email of this account
    
    var email : String
    //The restaurant image associated with this account that is used throughout the app (client)
    private var restaurantImage : String
    
    //The layout style of this restaurant's menu
    var layoutStyle : String
    
    var visible : String
    
    
    func image() -> UIImage? {
        return restoreImageFromBase64String(string: restaurantImage)
    }
    
    func setImage(image : UIImage) {
        restaurantImage = AdminAccount.imageToString(image : image)!
    }
    
    private func restoreImageFromBase64String(string : String) -> UIImage? {
        if let imageData = Data(base64Encoded: string) {
            let image = UIImage(data: imageData)
            return image
        }
        return nil
    }
    
    func visibility() -> Bool {
        if(visible == "true") {
            return true
        }
        return false
    }
    
    init(id : String, restaurantName : String, email : String, restaurantImage : String, layoutStyle : String, visible : String) {
        self.id = id
        self.restaurantName = restaurantName
        self.email = email
        self.restaurantImage = restaurantImage
        self.layoutStyle = layoutStyle
        self.visible = visible
    }
    
}
