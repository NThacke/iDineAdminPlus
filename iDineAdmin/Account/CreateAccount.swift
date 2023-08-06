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
    
    @ObservedObject private var account : CreateAccountHelper = CreateAccountHelper()
    
    @ObservedObject var address : Address = Address()
    
    @ObservedObject private var restaurantType : RestaurantType = RestaurantType()
    
    
    private let id : String = UUID().uuidString
    
    
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
                    }
                    ScrollView {
                        //account info header
                        HStack {
                            Text("Account Info").padding()
                            Spacer()
                        }
                        Group {
                            //show a red outline along with text if email exists
                            if(account.emailExists) {
                                Text("Email already exists").foregroundColor(Color.gray)
                                TextField("Email", text : $account.email).padding().onChange(of: account.email, perform: {s in
                                    account.emailExists = false
                                }).overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.red, lineWidth: 1)).padding()
                            }
                            else if(account.invalidEmail) {
                                TextField("Email", text : $account.email).padding().onChange(of: account.email, perform: {s in
                                    account.invalidEmail = false
                                }).overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.red, lineWidth: 1)).padding()
                            }
                            //otherwise (email does not exist) just show normal email
                            else {
                                TextField("Email", text : $account.email).padding().overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1)).padding()
                            }
                            //password
                            if(account.invalidPassword) {
                                SecureField("Password", text : $account.password).padding().overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.red, lineWidth: 1)).padding().onChange(of: account.password) { newValue in
                                    account.invalidPassword = false
                                }
                            }
                            else {
                                SecureField("Password", text : $account.password).padding().overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1)).padding()
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
                                    account.restaurantInfo.toggle()
                                }) {
                                    Image(systemName : "info.circle")
                                }
                            }
                        }
                        Group {
                            //display info if user selected to
                            VStack {
                                if(account.restaurantInfo) {
                                    ScrollView {
                                        Text("Every restaurant has a name, type, and location. You can change the name later, but you cannot change the type or address after creating an account. ").foregroundColor(Color.gray)
                                    }
                                }
                                //name textfield
                                if(account.invalidName) {
                                    TextField("Restaurant Name", text : $account.restaurantName).padding().overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.red, lineWidth: 1)).padding().onChange(of: account.restaurantName, perform: {s in
                                        account.invalidName = false
                                    })
                                }
                                else {
                                    TextField("Restaurant Name", text : $account.restaurantName).padding().overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1)).padding()
                                }
                                
                                HStack {
                                    Menu(restaurantType.label) {
                                        Button(RestaurantType.MEXICAN) {restaurantType.changeSelection(to : RestaurantType.MEXICAN)}
                                        Button(RestaurantType.ITALIAN) {restaurantType.changeSelection(to: RestaurantType.ITALIAN)}
                                        
                                        
                                    }
                                    Spacer()
                                }.padding().overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth : 1)).padding()
                                Group { //Location Information
                                    if(account.invalidLocation) {
                                        warning()
                                        AddressFormView(address: address).onSubmit {
                                            account.invalidLocation.toggle()
                                        }
                                    }
                                    else {
                                        AddressFormView(address : address)
                                    }
                                }
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
                    
                    if(account.loading) {
                        // This is the loading icon (indeterminate spinner)
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
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
        
        validEntries() { result in
            if(result) {
                account.loading = true
                self.invokeAPI() {
                    account.loading = false
                    if(!account.emailExists) {
                        Manager.getAccountInfo(email: account.email) {acc in
                            Manager.account = acc!
                            account.loginSuccess = true
                            current.state = AppState.MenuView
                        }
                    }
                }
            }
        }
    }
    
    func warning() -> some View {
        HStack {
            Image(systemName : "exclamationmark.triangle")
            
            Text("Our system indicates this is an invalid address. Please try again.")
        }.padding().overlay(RoundedRectangle(cornerRadius:10).stroke(Color.black, lineWidth : 1))
    }
    
    /**
            This methods checks to see if every entry entered is valid. If not, it signals the issue to the user by presenting a pop up.
     */
    func validEntries(completion : @escaping (Bool) -> Void){
        
        print("Inside valid entries()")
        account.invalidName = account.restaurantName.isEmpty
        account.invalidEmail = account.email.isEmpty
        account.invalidPassword = account.password.isEmpty
        
            Util.isAddressValid(address: address) { result in
                account.invalidLocation = (address.line.isEmpty || address.locality.isEmpty || address.postalCode.isEmpty || address.region.isEmpty || address.administrativeArea.isEmpty) || !result
                
                print("\(address.line) + is an address : \(result)")
                
                completion(!(account.invalidName || account.invalidEmail || account.invalidPassword || account.invalidLocation))
            }
    }
    
    func invokeAPI(completion : @escaping () -> Void) {
        // Set the API endpoint URL
        
        putAccountDetails() {
            putAccountAddress() {
                completion()
            }
        }
        
    }
    
    func putAccountAddress(completion : @escaping () -> Void) {
        print("Putting account address")
        guard let url = URL(string : "https://vqffc99j52.execute-api.us-east-1.amazonaws.com/Testing/admin_account/address") else {
            print("Invalid URL")
            return
        }
        
        //set the request method to be PUT
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        
        //create a body for the JSON data
        let requestBody = [
            "id" : id,
            "line" : address.line,
            "postalCode" : address.postalCode,
            "administrativeArea" : address.administrativeArea,
            "locality" : address.locality,
            "region" : address.region
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
                completion()
            }
        }
        task.resume()
    }
    
    func putAccountDetails(completion : @escaping () -> Void) {
        guard let url = URL(string: "https://vqffc99j52.execute-api.us-east-1.amazonaws.com/Testing/admin_account") else {
            print("Invalid URL")
            return
        }
        
        //set the request method to be PUT
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        
        //generate salt and hash the password+salt
        let salt = generateSalt(length:16)
        let hashed_salted_password = sha256Hash(account.password+salt)
        
        //lowercase email
        let email = account.email.lowercased()
        
        
        let basicImage = AdminAccount.example().details.image()
        let imageAsString = AdminAccount.imageToString(image: basicImage!)!
            
        //create a body for the JSON data
        let requestBody = [
            "id" : id,
            "email" : email,
            "salt" : salt,
            "password" : hashed_salted_password,
            "restaurantName" : account.restaurantName,
            "restaurantImage" : imageAsString,
            "layoutStyle" : "0",
            "visible" : "false",
            "restaurantType" : account.restaurantType
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
                    account.emailExists = true
                    
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



private class CreateAccountHelper : ObservableObject {
    @Published var email : String = ""
    @Published var password : String = ""
    @Published var restaurantName : String = ""
    @Published var restaurantType : String = ""
    @Published var restaurantInfo = false
    
    /**
        A state variable used to signify that an email already exists.
     */
    @Published var emailExists = false
    
    /**
     This state variable is used to signify when we are loading data from an API endpoint. This is used to show loading bars.
     */
    @Published var loading = false
    
    
    @Published var invalidEmail = false
    
    @Published var invalidPassword = false
    
    @Published var invalidName = false
    
    @Published var invalidLocation = false
    
    
    @Published var loginSuccess = false
    
    @Published var cancel = false
}

private class RestaurantType : ObservableObject {
    @Published var currentSelection : String = ""
    
    @Published var label : String = "Restaurant Type"
    
    static let MEXICAN : String = "Mexican"
    static let ITALIAN : String = "Italian"
    
    func changeSelection(to: String) {
        currentSelection = to
        label = to
    }
    
    
    
    
    
}
