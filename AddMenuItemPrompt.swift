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
    
    /**
            The name of the new menu item
     */
    @State var name : String = ""
    /**
            The price of the new menu item
     */
    @State var price : String = ""
    /**
     The description of the new menu item
     */
    @State var description : String = ""
    /**
     The image associated with this menu item. This is the encoded data of the image -- this is how we store the image in the database (which is not good for scale!)
     */
    @State var image : String = ""
    
    /**
     The menu type associated with this menu item. This field is either breakfast, lunch, dinner, or empty (empty only occurs when the user has not entered a value yet). This denotes which menu section the item will belong to. Breakfast items are in the breakfast menu, and so on.
     */
    @State var menuType : String = ""
    /**
     The section that this item belongs to. Every menu (breakfast, lunch, or dinner) is further categorized into sections. There is no pre-defined sections -- the administrator must create their own sections.
     
        This program ensures that every item belonging to a particular menu and section will be sorted in the same category. For example, let us assume that there exists three menu items on the entire menu :
     
            Menu Type
                Section Type A
                        item x
                        item y
                Section Type B
                        item w
                        item z
     
            Breakfast
                Classics
                        Toast & Eggs
                        Bacon & Eggs
                Omeletes
                        Western Omelete
            
     This shows three items in the Breakfast menu type. Beneath it, there are two sections. One section is named "Classics" and includes "Toast & Eggs" and "Bacon & Eggs". Another section is named "Omeletes", and includes a "Western Omelete" as an item.
     
     If a user added another menu item that was some other category, the program will create that section on the fly. If they add a new menu item for a section that already exists, it'll include it in that section.
     */
    @State var sectionType : String = ""
    
    
    /**
            This field is used to denote when the form has been submitted. If the form has been submitted, the state is "closed" in the sense that no more data can be entered. Once the state is closed (this field is true), then all of the data in the form gets created as a new menu item object, and sent into the database. Furthermore, a popup appears denoting the user that their menu item has beena added to the menu.
     */
    @State var closed  = false
    
    /**
     This field is used to denote when the current form is invalid. If required fields are not entered, this equates to true. Required fields are denoted as required, but they are : "name", "price", "menuType", and "sectionType"
     
     */
    @State var inValid = false
    
    /**
            This is the selected image that the user has selected from their gallery. If no image has been selected, then this value equates to nil, hence the optional binding.
     */
    
    @State private var selectedImage : UIImage?
    
    /**
            This is used to flag when the user wants to select a photo. This is used as a reference for the PhotoPicker -- when this value is true, the PhotoPicker is being displayed. Otherwise, the PhotoPicker is not displayed.
     
            This value turns to true when the user selects the button "Choose from gallery" under the "Image" section.
     */
    @State private var showingPhotoPicker = false
    
    
    @State var showMenuTypeInfo = false
    
    /**
        This is used to store the currently selected restriction. When a user adds a restrictions, this field gets updated. Then, it gets appended onto the chosen restrictions, and removed from the possible restrictions. When a restriction is thereafter removed, the opposite operation occurs.
     */
    @State private var selection = ""
    
    /**
            The restrictions that the user chooses to have on this new menu item.
     */
    @State var chosenRestrictions : [String] = []
    
    /**
     The possible restrictions to have on a menu item
     */
    @State var restrictions : [String] = [MenuItem.GLUTEN_FREE, MenuItem.VEGAN, MenuItem.VEGETARIAN]
    
    
    /**
     Thie field is used to denote whether the user wants to see information regarding restrictions. When the user clicsk on the info button next to the restrictions section, this field is set to true. Then, another section element appears above the restrictions, describing what restrictions are and what they are used for.
     */
    @State var showRestrictionInfo = false
    
//    var restrictionView = SetRestrictionView()
    
    
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
                }
            }
            .sheet(isPresented : $showingPhotoPicker) {
                PhotoPickerView(selectedImage : $selectedImage)
            }
            if showMenuTypeInfo {
                Section("A menu type denotes which category an item belongs to. Options are Breakfast, Lunch or Dinner.") {}
            }
            Section("Menu Type") {
                HStack {
                    let menuTypes = ["Breakfast", "Lunch", "Dinner"]
                    Menu("Choose") {
                        ForEach(menuTypes, id : \.self) {type in
                            Button(action : {
                                self.menuType = type
                            }) {
                                Text(type)
                            }
                        }
                    }
                    Spacer()
                    Text(menuType)
                    Spacer()
                    Spacer()
                    if(menuType.isEmpty) {
                        warning()
                    }
                }
            }
            
            
            Section("Section Type") {
                HStack {
                    Text("Section Type")
                    TextField("\t.\t.\t.\t.\t.\t.\t.\t.", text : $sectionType)
                    if(sectionType.isEmpty) {
                        warning()
                    }
                }
            }
            Section("Image") {
                VStack(alignment : .center) {
                    Button("Choose from gallery") {
                        showingPhotoPicker = true
                    }
                }
            }
            if let image = selectedImage {
                Image(uiImage : image).resizable().frame(width : 100, height : 100)
            }
            
            if showRestrictionInfo {Section("Restrictions are used to accomdate those with dietary needs") {}
            }
            Section(header: SectionHeaderView(title: "Set Restrictions", action : toggleRestrictionInfo)) {
                Menu("Select a Restriction") {
                    ForEach(restrictions, id : \.self) {r in
                        Button(action : {
                            self.selection = r
                        }) {
                            Text(r)
                        }
                    }
                }
                .onChange(of : selection) { selection in
                    //add chosen restriction to list of chosen restrictions, and remove it from the possible selections
                    chosenRestrictions.append(selection)
                    restrictions.remove(at : restrictions.firstIndex(of: selection)!)
                }
            }
            
            if(!chosenRestrictions.isEmpty) {
                Section("Restrictions") {
                    ForEach(chosenRestrictions, id : \.self) {r in
                        Text(r)
                    }
                    .onDelete(perform : { offsets in
                        //remove the restriction from chosen restrictions, and append it onto the possible restrictions
                        if let index = offsets.first {
                            let item = chosenRestrictions.remove(at : index)
                            restrictions.append(item)
                        }
                    })
                }
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
    
    /**
     This functon resized the given image into the given scaled size and returns the resized image back.
     */
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
            let restrictions = retrieveRestrictions()
            
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
            
            let item = MenuItem(name: name, type : menuType, section: sectionType, image : image, price : price, description : description, restrictions: restrictions)
            
            do {
                try APIHelper.putItem(item: item)
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
        
        clearRestrictions()
        
        closed = true
        
    }
    
    func clearRestrictions() {
        
        for item in chosenRestrictions {
            print(item)
            if let index = chosenRestrictions.firstIndex(of:item) {
                chosenRestrictions.remove(at : index)
                restrictions.append(item)
            }
        }
    }
    
    /**
     This function is used whenever the user clicks on the information button on the restriction section. It simply toggles the  internal boolean field 'showRestrictionInfo'
     */
    func toggleRestrictionInfo() {
        self.showRestrictionInfo.toggle()
    }
    
    func retrieveRestrictions() -> String {
        var s = ""
        for i in chosenRestrictions {
            s += "," + i
        }
        return s
    }
    
    
}

struct AddMenuItemPrompt_Previews: PreviewProvider {
    static var previews: some View {
        AddMenuItemPrompt()
    }
}
