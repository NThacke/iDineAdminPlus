//
//  AddMenuItemPrompt.swift
//  iDineAdmin
//
//  Created by Nick Thacke on 7/12/23.
//

import Foundation
import SwiftUI

/**
 This struct is used as the View for adding a new menu item. When a user is adding a new menu item, they are viewing this View
 */

struct AddMenuItemPrompt : View {
    
    @State var name : String = ""
    @State var price : String = ""
    @State var description : String = ""
    @State var image : String = ""
    @State var menuType : String = ""
    @State var sectionType : String = ""
    
    @State var closed  = false
    @State var inValid = false
    
    @State private var selectedImage : UIImage?
    @State private var showingPhotoPicker = false
    
    
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
                        Button("Select") {
                            showingPhotoPicker = true
                        }
                        if let image = selectedImage {
                            Image(uiImage : image).resizable().frame(width : 50, height : 50)
                        }
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
            .sheet(isPresented : $showingPhotoPicker) {
                PhotoPickerView(selectedImage : $selectedImage)
            }
        }.popover(isPresented: $closed) {
            Text("Fantastic! That'll be added to the menu shortly.")
            Button("OK", action : {
                self.closed = false
            })
        }
        Button("OK") {
            let _ = print("Clicked okay!")
            inValid = !self.invokeAPI()
        }
        .popover(isPresented : $inValid) {
            Text("Oops! Seems like you forgot one or more required entries!")
        }
        
        
    }
    
    /**
    @returns a View of an Image which shows a red exclamation mark
     */
    func warning() -> some View {
        Image(systemName: "exclamationmark.circle").foregroundColor(Color.red)
    }
    
    func reiszeImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.draw(in: CGRectMake(0, 0, newSize.width, newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /**
    @returns true if the required  textfields (name, price, menuType, and menuSection)  are all non empty
     */
    func valid() -> Bool {
        return !name.isEmpty && !price.isEmpty && !menuType.isEmpty && !sectionType.isEmpty
    }
    /**
    @returns true if one or more required texteiflds (name, price, menuType and menuSection) are empty
     */
    func notValid() -> Bool {
        return !valid()
    }
    
    /**
    This method sends the entered information in the textfields over to the database which stores the menu items. It does so by invoking an API Put Request
     */
    func invokeAPI() -> Bool {
        
        let _ = print("Inside invokeAPI")
        print(notValid())
        
        if(!notValid()) {
            let name = name
            let price = price.lowercased()
            let description = description
            let menuType = menuType.lowercased()
            let sectionType = sectionType.lowercased()
            
            if let selectedImage = selectedImage {
                print("Selected an image")
                let resized = reiszeImage(image: selectedImage, scaledToSize: CGSize(width: 50, height:50))
                if let data = resized.pngData()?.base64EncodedString() {
                    self.image = data
                }
            }
            else {
                print("Selected image is null")
            }
            
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
        self.selectedImage = nil
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
