//
//  ItemRow.swift
//  iDineAdmin
//
//  Created by Nick Thacke on 7/12/23.
//

import Foundation
import SwiftUI

struct ItemRow : View {
    var item : MenuItem
    
    var body : some View {
        HStack {
            
            Image(item.image).resizable().frame(width: 50, height:50).cornerRadius(100)
            VStack {
                Text(item.name);
                Text(item.description)
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
}

struct ItemRow_Previews: PreviewProvider {
    static var previews: some View {
        ItemRow(item : MenuItem.example())
    }
}
