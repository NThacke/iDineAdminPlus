//
//  AccountView.swift
//  iDineAdmin
//
//  Created by Nick Thacke on 7/21/23.
//

import Foundation
import SwiftUI


/**
 This class keeps track of changes that occur to the fields. Any mdoification gets reflected to this class, and when the user clicks on the submit button (ensuring that they are okay with the changes), then fields from this class are sent to the admin account class, as well as to the database.
 
 We don't want to keep track of changes in the AdminAccount because those fields are supposed to be the reflective of the database and the data that everyone observes.
 */


private class ChangeTracker {
    
    /**
        The image associated with this account. This is what users see as they scroll against all other restaurants. It is essentially the "logo" of the restaaurant.
     */
//    @State static var restaurantImage : UIImage = AccountView.image!
    
    /**
     The visibility of the restaurant. If this field is set to AdminAccount.visible, it signifies that the admin of this restaurant wants the restaurant to be visible to clients using the app.
     */
    @State static var visible : String = AdminAccount.invisible
    
    /**
     The name of this restaurant. Yes, we give the user the option to change their name!
     */
    @State static var restaurantName : String = Manager.account.restaurantName
    
    /**
     The location of this restaurant. Yes, we give the user the option to change their locaiton!
     */
    @State static var restaurantLocation : String = Manager.account.restaurantLocation
    
    /**
     The layout style of this restaurant.
     */
    @State static var layoutStyle : String = Manager.account.layoutStyle
    
}

struct AccountView : View {
    
    @State var selectPhoto = false
    
    @State var image : UIImage?
    
    var body :  some View {
        
        VStack {
            Group {
                if let image = Manager.account.image() {
                    Image(uiImage: image)
                }
                Rectangle().frame(width: 250, height: 1.5).foregroundColor(Color.blue)
                Text(Manager.account.email).foregroundColor(Color.gray)
            }
            
            Group {
                VStack {
                    HStack {
                        Spacer()
                    }
                    Group { //Group for restaurant name information
                        HStack {
                            Text("Restaurant Name").foregroundColor(Color.gray)
                            Spacer()
                        }
                        TextField("Restaurant Name", text : ChangeTracker.$restaurantName)
                            .padding()
                            .overlay(RoundedRectangle(cornerRadius : 10).stroke(Color.blue))
                    }
                    
                    Group { //Group for location information
                        HStack {
                            Text("Restaurant Location").foregroundColor(Color.gray)
                            Spacer()
                        }
                        TextField("Restaurant Location", text : ChangeTracker.$restaurantLocation)
                            .padding()
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue))
                    }
                    
                    Group { //Group for image information
                        HStack {
                            Text("Restaurant Image").foregroundColor(Color.gray)
                            Spacer()
                        }
                        HStack {
                            if let myImage = image {
                                Image(uiImage : myImage).resizable().frame(width : 50, height : 50)
                            }
                            else {
                                Image(systemName: "tuningfork")
                            }
                            Spacer()
                            Button("Select from Gallery") {
                                selectPhoto = true
                            }
                        }.padding()
                            .overlay(RoundedRectangle(cornerRadius : 10).stroke(Color.blue))
                    }
                    
                    Group { //Group for layout style information
                        HStack {
                            Text("Layout Style").foregroundColor(Color.gray)
                            Spacer()
                        }
                        HStack {
                            Spacer()
                            Button("0") {
                                
                            }
                            Spacer()
                            Button("1") {
                                
                            }
                            Spacer()
                            Button("2") {
                                
                            }
                            Spacer()
                        }.padding()
                            .overlay(RoundedRectangle(cornerRadius : 10).stroke(Color.blue))
                    }
                    Spacer()
                }.padding()
            }
            
            Group { //Group for cancel / submit buttons
                HStack {
                    ZStack { //Cancel button
                        RoundedRectangle(cornerRadius: 10).frame(width:100, height: 50).foregroundColor(Color.red)
                        Button("CANCEL") {
                            
                        }.foregroundColor(Color.white)
                    }
                    Spacer()
                    ZStack { //Submit button
                        RoundedRectangle(cornerRadius: 10).frame(width:100, height: 50).foregroundColor(Color.blue)
                        Button("SUBMIT") {
                            
                        }.foregroundColor(Color.white)
                    }
                }
            }
            
            
            Spacer() //Ensures that the entire vstack is tight to the top of the screen
        }.padding()
            .sheet(isPresented : $selectPhoto) {
                PhotoPickerView(selectedImage: $image)
        }
    }
}



struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
