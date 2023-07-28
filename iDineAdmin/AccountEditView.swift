//
//  AccountView.swift
//  iDineAdmin
//
//  Created by Nick Thacke on 7/21/23.
//

import Foundation
import SwiftUI


/**
 This class is used solely to communcate the location between the AddressSearchView and the AccountEditView.
 
 For some reason, you cannot pass the ChangeTracker Object into the AddressSearchView without causeing the AddressSearchView to not display search results -- which is exactly why we even want it in the first place.
 
 So, we communicate the Location with this. Anytime we change the location, this field is reflected, and is retrieved when submitting the changes to the server.
 */
class Communicator {
    static var location : String = ""
}


struct AccountEditView : View {
    
    @EnvironmentObject var current : AppState
    
    @StateObject var fields : ChangeTracker = ChangeTracker()
    
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
    
    @State var visibility = Manager.account.visibility()
    
    var body :  some View {
            VStack {
                Group {
                    
                    HStack {
                        Text("Edit Account").bold()
                        Spacer()
                    }
                    if let image = Manager.account.image() {
                        Image(uiImage: image).resizable().frame(width: 75, height : 75)
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
                            TextField("Restaurant Name", text : $fields.restaurantName)
                                .padding()
                                .overlay(RoundedRectangle(cornerRadius : 10).stroke(Color.blue))
                        }
                        
                        Group { //Group for location information
                            HStack {
                                Text("Restaurant Location").foregroundColor(Color.gray)
                                Spacer()
                            }
                            AddressSearchView()
//                            TextField("Restaurant Location", text : $restaurantLocation)
                                .padding()
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue))
                        }
                        
                        Group { //Group for image information
                            HStack {
                                Text("Restaurant Image").foregroundColor(Color.gray)
                                Spacer()
                            }
                            HStack {
                                if let myImage = fields.image {
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
                                
                                if(fields.visible == "false") {
                                    Text("Not Visible")
                                }
                                else {
                                    Text("Visible")
                                }
                                Spacer()
                                
                                Toggle("", isOn: $visibility).onChange(of: visibility) { v in
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
                                current.state = AppState.AccountView
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
                    PhotoPickerView(selectedImage: $fields.image)
                }
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
                                current.state = AppState.MenuView
                            }
                        }
                    }
                }
    }
    
    func toggleVisiblity() {
        print("In toggle visilbity function")
        print("Visiblity is set to \(fields.visible)")
        if(visibility) {
            fields.visible = AdminAccount.visible
        }
        else {
            fields.visible = AdminAccount.invisible
        }
    }
    
    func submit(completion : @escaping () -> Void) {
        print("Inside submit function")
        
        let resized = AdminAccount.reiszeImage(image: fields.image!, scaledToSize: CGSize(width: 50, height:50)) //must be resized so that the string representation is not too large
        let myImage = AdminAccount.imageToString(image: resized)!
        
        
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
            "restaurantName": fields.restaurantName,
            "restaurantLocation" : Communicator.location,
            "restaurantImage" : myImage,
            "layoutStyle" : fields.layoutStyle,
            "visible" : fields.visible
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
                    Manager.account.setImage(image: resized)
                    Manager.account.restaurantName = fields.restaurantName
                    Manager.account.restaurantLocation = fields.restaurantLocation
                    Manager.account.layoutStyle = fields.layoutStyle
                    Manager.account.visible = fields.visible
                }
                completion()
            }
        }
        
        task.resume()
    }
}

class ChangeTracker : ObservableObject{
    @Published var restaurantName : String = Manager.account.restaurantName
    @Published var restaurantLocation : String = Manager.account.restaurantLocation
    @Published var visible : String = Manager.account.visible
    @Published var image : UIImage? = Manager.account.image()
    @Published var layoutStyle : String = Manager.account.layoutStyle
    
    
    
}



struct AccountEditView_Previews: PreviewProvider {
    static var previews: some View {
        AccountEditView()
    }
}
