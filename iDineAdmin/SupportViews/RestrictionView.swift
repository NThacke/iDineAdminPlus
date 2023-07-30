//
//  RestrictionView.swift
//  iDineAdmin
//
//  Created by Nick Thacke on 7/15/23.
//

import Foundation
import SwiftUI

/**
 This View is waht is used to showcase the Restrictions of a particular Menu Item. This displays whether or not an item is Gluten Free, Vegan, or Vegetarian. This eventually gets invoked withiin each ItemRow struct.
 */
struct RestrictionView : View {
    
    let item : MenuItem
    
    var body : some View {
        HStack (alignment : .center) {
            if(item.restrictions.contains(MenuItem.GLUTEN_FREE)) {
                ZStack {
                    Circle().fill(Color.orange).frame(width : 20, height : 20)
                    Text("G")
                }
            }
            if(item.restrictions.contains(MenuItem.VEGAN)) {
                ZStack {
                    Circle().fill(Color.red).frame(width : 20, height : 20)
                    Text("V")
                }
            }
            if(item.restrictions.contains(MenuItem.VEGETARIAN)) {
                ZStack {
                    Circle().fill(Color.green).frame(width : 20, height : 20)
                    Text("V")
                }
            }
            Spacer()
        }
        EmptyView()
    }
    
    init(item : MenuItem) {
        self.item = item
    }
}

struct RestrictionView_Previews: PreviewProvider {
    static var previews: some View {
        RestrictionView(item : MenuItem.example())
    }
}
