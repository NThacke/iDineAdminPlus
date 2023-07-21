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
    
    //The ID of this account
    var id : String
    
    //The restaurant name associated with this account
    var restaurantName : String
    
    //The restaurant location associated with this account
    var restaurantLocation : String
    
    //The email associated with this account
    var email : String
    
    //The restaurant image associated with this account that is used throughout the app (client)
    private var restaurantImage : String
    
    //The layout style of this restaurant's menu
    var layoutStyle : String
    
    var visible : String
    
    
    init(id : String, restaurantName : String, restaurantLocation : String, email : String, restaurantImage : String, layoutStyle : String, visible : String) {
        self.id = id
        self.restaurantName = restaurantName
        self.restaurantLocation = restaurantLocation
        self.email = email
        self.restaurantImage = restaurantImage
        self.layoutStyle = layoutStyle
        self.visible = visible
    }
    
    static func example() -> AdminAccount {
        return AdminAccount(
            id : "A904844B-6537-4A57-8710-EE5317B6687D",
            restaurantName : "Example",
            restaurantLocation : "Example",
            email : "example@gmail.com",
            restaurantImage : exampleImage(),
            layoutStyle : "1",
        visible: "false");
    }
    
    func image() -> UIImage? {
        return restoreImageFromBase64String(string: restaurantImage)
    }
    
    func setImage(image : UIImage) {
        restaurantImage = AdminAccount.imageToString(image : image)!
    }
    
    static func imageToString(image: UIImage) -> String? {
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
    
    private func restoreImageFromBase64String(string : String) -> UIImage? {
        if let imageData = Data(base64Encoded: string) {
            let image = UIImage(data: imageData)
            return image
        }
        return nil
    }
    
    private static func exampleImage() -> String {
        let image = UIImage(systemName : "fork.knife.circle")!
        return imageToString(image : image)!
    }
}
