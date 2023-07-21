//
//  AccountView.swift
//  iDineAdmin
//
//  Created by Nick Thacke on 7/21/23.
//

import Foundation
import SwiftUI


struct AccountEditView : View {
    
    /**
     The visibility of the restaurant. If this field is set to AdminAccount.visible, it signifies that the admin of this restaurant wants the restaurant to be visible to clients using the app.
     */
    @State var visible : String = Manager.account.visible
    
    /**
     The name of this restaurant. Yes, we give the user the option to change their name!
     */
    @State var restaurantName : String = Manager.account.restaurantName
    
    /**
     The location of this restaurant. Yes, we give the user the option to change their locaiton!
     */
    @State var restaurantLocation : String = Manager.account.restaurantLocation
    
    /**
     The layout style of this restaurant.
     */
    @State var layoutStyle : String = Manager.account.layoutStyle
    
    /**
            This variable is used to signify if the user has chosen to select a photo to view. If true, then this is used to signify to the PhotoPicker that it should be appearing
     */
    @State var selectPhoto = false
    
    /**
            Thie variable is used to signify that the user canceled their operation in the view. This is used to signal to the NavigationLink that it should navigate back to the previous page.
     */
    
    @State var cancel = false
    
    /**
                This variable is used to signify that the user hit the submit button. This is signled to the popover which confirms that the user is okay with the current changes.
     */
    
    @State var submit = false
    /**
     Thhis variable is used to signify that the user has confirmed that they want the current changes to be reflected to the database and overall the rest of the app.
     */
    
    @State var confirm = false
    
    /**
     This variable is used to track the selected image. For unknown (?) reasons, this cannot be stored in the ChangeTracker class -- various bugs occur if that is used. Instead, we must keep track of the image locally.
     */
    
    @State var image : UIImage?
    
    
    @State var visiblity = false
    
    var body :  some View {
        
        NavigationView {
            VStack {
                Group {
                    if let image = Manager.account.image() {
                        Image(uiImage: image)
                    }
                    Rectangle().frame(width: 250, height: 1.5).foregroundColor(Color.blue)
                    Text(Manager.account.email).foregroundColor(Color.gray)
                }
                
                Group { //Group for restaurnt information
                    VStack {
                        HStack {
                            Spacer()
                        }
                        Group { //Group for restaurant name information
                            HStack {
                                Text("Restaurant Name").foregroundColor(Color.gray)
                                Spacer()
                            }
                            TextField("Restaurant Name", text : $restaurantName)
                                .padding()
                                .overlay(RoundedRectangle(cornerRadius : 10).stroke(Color.blue))
                        }
                        
                        Group { //Group for location information
                            HStack {
                                Text("Restaurant Location").foregroundColor(Color.gray)
                                Spacer()
                            }
                            TextField("Restaurant Location", text : $restaurantLocation)
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
                                    Image(systemName: "fork.knife.circle")
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
                        
                        Group {
                            HStack {
                                Text("Visibility").foregroundColor(Color.gray)
                                Spacer()
                            }
                            HStack {
                                
                                if(visible == "false") {
                                    Text("Not Visible")
                                }
                                else {
                                    Text("Visible")
                                }
                                Spacer()
                                
                                Toggle("", isOn: $visiblity).onChange(of: visiblity) { v in
                                    toggleVisiblity()
                                }
                                
                                
                            }.padding().overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue))
                        }
                        Spacer()
                    }.padding()
                }
                
                Group { //Group for cancel / submit buttons
                    HStack {
                        ZStack { //Cancel button
                            RoundedRectangle(cornerRadius: 10).frame(width:100, height: 50).foregroundColor(Color.red)
                            Button("CANCEL") {
                                cancel = true
                            }.foregroundColor(Color.white)
                        }
                        Spacer()
                        ZStack { //Submit button
                            RoundedRectangle(cornerRadius: 10).frame(width:100, height: 50).foregroundColor(Color.blue)
                            Button("SUBMIT") {
                                submit = true
                            }.foregroundColor(Color.white)
                        }
                    }
                }
                
                
                Spacer() //Ensures that the entire vstack is tight to the top of the screen
            }.padding()
                .sheet(isPresented : $selectPhoto) {
                    PhotoPickerView(selectedImage: $image)
                }
                .background(NavigationLink(destination : AccountView(), isActive : $cancel) {
                    EmptyView()
                })
                .background(NavigationLink(destination : MenuView(), isActive : $confirm) {
                    EmptyView()
                })
                .popover(isPresented : $submit) {
                    
                    Text("Are you sure you want to submit these changes? These changes will be reflected across the app to customers.")
                    
                    HStack {
                        
                        Button("Cancel") {
                            submit = false
                        }
                        Spacer()
                        
                        Button("OK") {
                            submit() {
                                submit = false
                                confirm = true
                            }
                        }
                    }
                }
        }.navigationBarBackButtonHidden(true)
    }
    
    func toggleVisiblity() {
        print("In toggle visilbity function")
        print("Visiblity is set to \(visible)")
        if(visiblity) {
            visible = AdminAccount.visible
        }
        else {
            visible = AdminAccount.invisible
        }
    }
    
    func submit(completion : @escaping () -> Void) {
        print("Inside submit function")
        print("Name : \(restaurantName)")
        print("Location : \(restaurantLocation)")
        
//        let imageString = AdminAccount.imageToString(image: image!)!
        
//        print("Image : \(imageString)")
//        print("Layout Style : \(layoutStyle)")
//        print("Visible : \(visible)")
        
        
        guard let url = URL(string: "https://vqffc99j52.execute-api.us-east-1.amazonaws.com/Testing/admin_account/update") else {
            print("Invalid URL")
            return
        }
        print("Vaid URL")
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
    
        
        var requestBody : [String : String]
        
        requestBody = [
            "id": Manager.account.id,
            "restaurantName": restaurantName,
            "restaurantLocation" : restaurantLocation,
            "restaurantImage" : "empty",
            "layoutStyle" : "0",
            "visible" : "false"
        ] as [String : String]
            
        print("Successfuly created body")
        do {
            let jsonData = try JSONEncoder().encode(requestBody)
            request.httpBody = jsonData
        } catch {
            print("Error encoding JSON: \(error)")
            return
        }
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                completion()
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Status Code: \(httpResponse.statusCode)")
                if(httpResponse.statusCode == 200) {
//                    Manager.account.setImage(image: image!)
                    Manager.account.restaurantName = self.restaurantName
                    Manager.account.restaurantLocation = self.restaurantLocation
                }
                completion()
            }
        }
        
        task.resume()
    }
}



struct AccountEditView_Previews: PreviewProvider {
    static var previews: some View {
        AccountEditView()
    }
}
