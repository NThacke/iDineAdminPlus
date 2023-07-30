//
//  ItemRow.swift
//  iDineAdmin
//
//  Created by Nick Thacke on 7/12/23.
//

import Foundation
import SwiftUI

/**
 This View is what is used to display an Item to the client. Every Menu Item eventually gets instantiaed as an ItemRow Object, and every "Item" in any list / menu is instantiating this object.
 */
struct ItemRow : View {
    
    /**
            The item that this ItemRow will display.
     */
    var item : MenuItem
    
    var body : some View {
        HStack {
            
            Image(uiImage : restoreImageFromBase64String(string : item.image) ?? defaultImage()).resizable().frame(width: 50, height:50).cornerRadius(100)
            
            VStack(alignment : .leading) {
                if(item.description.isEmpty) {
                    Text(item.name)
                    RestrictionView(item : item)
                }
                else {
                    VStack (alignment : .leading) {
                        Text(item.name)
                        Text(item.description).foregroundColor(Color.gray).italic()
                    }
                    RestrictionView(item : item)
                }
            }
            Spacer()
            Text("$\(item.price)");
            
            Button(action : {
                
            }) {
                Image(systemName : "plus.app")
            }
            .buttonStyle(PlainButtonStyle())
            .foregroundColor(Color.blue)
            
        }
    }
    init(item: MenuItem) {
        self.item = item
    }
    
    func restoreImageFromBase64String(string : String) -> UIImage? {
        if let imageData = Data(base64Encoded: string) {
            let image = UIImage(data: imageData)
            return image
        }
        return nil
    }
    
    func defaultImage() -> UIImage {
        return UIImage(systemName : "fork.knife.circle.fill")!
    }
}

struct ItemRow_Previews: PreviewProvider {
    static var previews: some View {
        ItemRow(item : MenuItem.example())
    }
}
