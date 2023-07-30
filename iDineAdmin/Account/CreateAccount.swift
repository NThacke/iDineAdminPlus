//
//  CreateAccount.swift
//  iDineAdmin
//
//  Created by Nick Thacke on 7/19/23.
//

import Foundation
import SwiftUI

import CryptoKit


struct CreateAccount : View {
    
    @EnvironmentObject var current : AppState
    
    @StateObject var fields : ChangeTracker = ChangeTracker()
    
    /**
            The email associated with the newly created account.
     */
    @State var email : String = ""
    
    @State var restaurantLocation : String = ""
    
    /**
                    The password of the newly created account.
     */
    @State var password : String = ""
    
    /**
     The restaurant name associated with this account
     */
    
    @State var restaurantName : String = ""
    
    /**
     The restaurant location associated with this account.
     */
    @State var location : String = ""
    
    /**
            A State variable that is used to denote if the user wishes to see information regarding restaurants.
     */
    @State var restaurantInfo = false
    
    
    /**
        A state variable used to signify that an email already exists.
     */
    @State var emailExists = false
    
    /**
     This state variable is used to signify when we are loading data from an API endpoint. This is used to show loading bars.
     */
    @State var loading = false
    
    
    @State var invalidEmail = false
    
    @State var invalidPassword = false
    
    @State var invalidName = false
    
    @State var invalidLocation = false
    
    
    @State var loginSuccess = false
    
    @State var cancel = false
    
    
    var body : some View {
            Group {
                VStack (alignment : .center) {
                    Group {
                        //overall header
                        Spacer() //used to place entire view in correct position
                        HStack {
                            Text("Create Account").bold(true)
                            Spacer()
                        }
                        //account info header
                        HStack {
                            Text("Account Info").padding()
                            Spacer()
                        }
                    }
                    Group {
                        //show a red outline along with text if email exists
                        if(emailExists) {
                            Text("Email already exists").foregroundColor(Color.gray)
                            TextField("Email", text : $email).padding().onChange(of: email, perform: {s in
                                emailExists = false
                            }).overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.red, lineWidth: 1)).padding()
                        }
                        else if(invalidEmail) {
                            TextField("Email", text : $email).padding().onChange(of: email, perform: {s in
                                invalidEmail = false
                            }).overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.red, lineWidth: 1)).padding()
                        }
                        //otherwise (email does not exist) just show normal email
                        else {
                            TextField("Email", text : $email).padding().overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1)).padding()
                        }
                        //password
                        if(invalidPassword) {
                            SecureField("Password", text : $password).padding().overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.red, lineWidth: 1)).padding().onChange(of: password) { newValue in
                                invalidPassword = false
                            }
                        }
                        else {
                            SecureField("Password", text : $password).padding().overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1)).padding()
                        }
                    }
                    Group {
                        //resturant info header
                        HStack {
                            //text
                            Text("Restaurant Info").padding()
                            Spacer()
                            //info button
                            Button(action : {
                                restaurantInfo.toggle()
                            }) {
                                Image(systemName : "info.circle")
                            }
                        }
                    }
                    Group {
                        //display info if user selected to
                        if(restaurantInfo) {
                            ScrollView {
                                Text("To put a restaurant on this app, you need a name and a location to begin with. These can be changed later. However, only one restaurant may be associated with an account.").foregroundColor(Color.gray)
                            }
                        }
                        //name textfield
                        if(invalidName) {
                            TextField("Restaurant Name", text : $restaurantName).padding().overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.red, lineWidth: 1)).padding().onChange(of: restaurantName, perform: {s in
                                invalidName = false
                            })
                        }
                        else {
                            TextField("Restaurant Name", text : $restaurantName).padding().overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1)).padding()
                        }
                            //location textfield
                            if(invalidLocation) {
                                // red
                                TextField("Restaurant Location", text : $restaurantLocation).padding().overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.red, lineWidth: 1)).padding().onChange(of: location) { newValue in
                                    invalidLocation = false
                                }
                                    
                                AddressSearchView().padding().overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1)).onTapGesture {
                                    restaurantLocation = Communicator.location
                                }
                            }
                            else {
                                //blue
                                TextField("Restaurant Location", text : $restaurantLocation).padding().overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1)).padding()
                                
                                AddressSearchView().padding().overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1)).onTapGesture {
                                    restaurantLocation = Communicator.location
                                }
                            }
                    }
                    Group {
                        //OK button is a ZStack with rectangle on top of button
                        ZStack {
                            RoundedRectangle(cornerRadius : 10).foregroundColor(Color.blue).frame(width: 50, height:50)
                            Button("OK", action : {
                                create()
                            }).foregroundColor(Color.white)
                        }
                        ZStack {
                            RoundedRectangle(cornerRadius : 10).foregroundColor(Color.red).frame(width: 75, height:50)
                            Button("Cancel", action : {
//                                cancel = true
                                current.state = AppState.AccountLogin
                            }).foregroundColor(Color.white)
                        }
                    }
                    
                    if(loading) {
                        // This is the loading icon (indeterminate spinner)
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                    }
                    
                    Group {
                        //Used to place the entire View in the correct position
                        Spacer()
                        Spacer()
                        Spacer()
                    }
                    
                }.padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity) // Fill the entire available space
                    .edgesIgnoringSafeArea(.top) //
                    
            }
    }
    
    /**
     Attemps to create an account. If the given email already exists, this flags the corresponding variable to be true.
     */
    func create() {
        
        if(validEntries()) {
            self.loading = true
            self.invokeAPI() {
                self.loading = false
                if(!emailExists) {
                    Manager.getAccountInfo(email: email) {acc in
                        Manager.account = acc!;
                        loginSuccess = true
                        current.state = AppState.MenuView
                    }
                }
            }
        }
    }
    
    /**
            This methods checks to see if every entry entered is valid. If not, it signals the issue to the user by presenting a pop up.
     */
    func validEntries() -> Bool {
        invalidName = restaurantName.isEmpty
        invalidEmail = email.isEmpty
        invalidLocation = location.isEmpty
        invalidPassword = password.isEmpty
        
        return !(email.isEmpty || password.isEmpty || restaurantName.isEmpty || location.isEmpty)
    }
    
    func invokeAPI(completion : @escaping () -> Void) {
        // Set the API endpoint URL
        guard let url = URL(string: "https://vqffc99j52.execute-api.us-east-1.amazonaws.com/Testing/admin_account") else {
            print("Invalid URL")
            return
        }
        
        //set the request method to be PUT
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        
        //generate salt and hash the password+salt
        let salt = generateSalt(length:16)
        let hashed_salted_password = sha256Hash(password+salt)
        
        //lowercase email
        email = email.lowercased()
        
        
        let basicImage = AdminAccount.example().image()
        let imageAsString = AdminAccount.imageToString(image: basicImage!)!
            
        //create a body for the JSON data
        let requestBody = [
            "id" : UUID().uuidString,
            "email" : email,
            "salt" : salt,
            "password" : hashed_salted_password,
            "restaurantName" : restaurantName,
            "restaurantLocation" : location,
            "restaurantImage" : imageAsString,
            "layoutStyle" : "0",
            "visible" : "false"
        ] as [String : String]
        
        //encode the body as json data
        do {
            let jsonData = try JSONEncoder().encode(requestBody)
            request.httpBody = jsonData
        } catch {
            print("Error encoding JSON: \(error)")
            return
        }
        
        //idk
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //start up the connection
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Status Code: \(httpResponse.statusCode)")
                //status code
                if(httpResponse.statusCode == 400) {
                    //email already exists
                    emailExists = true
                    
                }
                
                //body
                if let data = data {
                            if let bodyString = String(data: data, encoding: .utf8) {
                                print("Response Body: \(bodyString)")
                                
                                // Now you can use the body data as needed
                            }
                        }
                completion()
            }
        }
        
        task.resume()
    }
    
    func generateSalt(length: Int) -> String {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString = ""

        for _ in 0..<length {
            let randomIndex = Int(arc4random_uniform(UInt32(characters.count)))
            let randomCharacter = characters[characters.index(characters.startIndex, offsetBy: randomIndex)]
            randomString.append(randomCharacter)
        }

        return randomString
    }
    
    init() {
        Communicator.location = "" //Refreshes the communicator's location as other views use and can modify this. This is dangerous.
    }
}

func sha256Hash(_ input: String) -> String {
    let inputData = Data(input.utf8)
    let hashedData = SHA256.hash(data: inputData)
    let hashedString = hashedData.compactMap { String(format: "%02x", $0) }.joined()
    return hashedString
}

struct CreateAccount_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccount().environmentObject(AppState())
    }
}
