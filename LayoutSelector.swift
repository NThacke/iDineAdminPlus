//  LayoutSelector.swift
//  iDine
//
//  Created by Nick Thacke on 7/19/23.
//

import Foundation
import SwiftUI


class LayoutSelector : ObservableObject {
    
    let name1 : Int = 0;
    let name2 : Int = 2;
    let name3 : Int = 3;
    let undefined : Int = -1;
    
    @Published var selection : Int
    
    func select(selection : Int) {
        self.selection = selection
    }
    
    func getLayout() -> AnyView {
        switch selection {
            case 0 :
                return AnyView(View1())
            case 1 :
                return AnyView(View2())
            case 2 :
                return AnyView(View3())
            default :
                return AnyView(Text("Hello World!"))
        }
    }
    
    init() {
        self.selection = undefined
    }
    
    
}

struct View1 : View {
    var body : some View {
        Text("Name1")
    }
}

struct View2 : View {
    var body : some View {
        Text("Name2")
    }
}

struct View3 : View {
    var body : some View {
        Text("Name3")
    }
}

