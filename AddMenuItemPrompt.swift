//
//  AddMenuItemPrompt.swift
//  iDineAdmin
//
//  Created by Nick Thacke on 7/12/23.
//

import Foundation
import SwiftUI

struct AddMenuItemPrompt : View {
    
    @State var name : String = ""
    @State var price : String = ""
    @State var description : String = ""
    @State var image : String = ""
    @State var menuType : String = ""
    @State var sectionType : String = ""
    
    @State var closed  = false
    @State var inValid = false
    
    
    var body : some View {
        
        List {
            Section("New Menu Item") {
                VStack {
                    HStack {
                        Text("Name")
                        TextField("\t.\t.\t.\t.\t.\t.", text : $name)
                        if(name.isEmpty) {
                            warning()
                        }
                    }
                    HStack {
                        Text("Price")
                        TextField("\t.\t.\t.\t.\t.\t.\t.", text : $price)
                        if(price.isEmpty) {
                            warning()
                        }
                    }
                    HStack {
                        Text("Description")
                        TextField("\t.\t.\t.\t.\t.\t.\t.\t.", text : $description)
                    }
                    HStack {//figure out a good import source for images
                        Text("Image")
                        
                    }
                    HStack {
                        Text("Menu Type")
                        TextField("\t.\t.\t.\t.\t.\t.\t.\t.", text : $menuType)
                        if(menuType.isEmpty) {
                            warning()
                        }
                    }
                    HStack {
                        Text("Section Type")
                        TextField("\t.\t.\t.\t.\t.\t.\t.\t.", text : $sectionType)
                        if(sectionType.isEmpty) {
                            warning()
                        }
                    }
                }
            }
        }.popover(isPresented: $closed) {
            Text("Fantastic! That'll be added to the menu shortly.")
            Button("OK", action : {
                self.closed = false
            })
        }
        Button("OK") {
            inValid = !invokeAPI()
        }
        .popover(isPresented : $inValid) {
            Text("Oops! Seems like you forgot one or more required entries!")
        }
        
        
    }
    
    func warning() -> some View {
        Image(systemName: "exclamationmark.circle").foregroundColor(Color.red)
    }
    
    func valid() -> Bool {
//        if (!name.isEmpty && !price.isEmpty && !menuType.isEmpty && !sectionType.isEmpty) {
//            return true
//        }
//        else {
//            return false
//        }
        return !name.isEmpty && !price.isEmpty && !menuType.isEmpty && !sectionType.isEmpty
    }
    func notValid() -> Bool {
        return !valid()
    }
    func getMenuType() -> String {
        return self.menuType
    }
    func getSectionType() -> String {
        return self.sectionType
    }
    
    func invokeAPI() -> Bool {
        print("Inside invokeAPI")
        print(valid())
        
        if(!notValid()) {
            let name = name
            let price = price.lowercased()
            let description = description
            let menuType = menuType.lowercased()
            let sectionType = sectionType.lowercased()
            let image = image
            
            let item = MenuItem(name: name, type : menuType, section: sectionType, image : image, price : price, description : description )
            
            do {
                try APIHelper.putItem(item : item)
            }
            catch {

            }
            clear()
            return true
        }
        return false
    }
    
    /**
            Clears all internal fields so that the prompt is an empty prompt.
     */
    func clear() {
        self.name = ""
        self.price = ""
        self.description = ""
        self.image = ""
        self.menuType = ""
        self.sectionType = ""
        
        closed = true
        
    }
    
    
}

struct AddMenuItemPrompt_Previews: PreviewProvider {
    static var previews: some View {
        AddMenuItemPrompt()
    }
}
