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
    
    @ObservedObject private var restaurantType : RestaurantType = RestaurantType.shared
    
    private var restaurantTypeSelection : RestaurantTypeSelection
    
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
                                
//                                RestaurantTypeSelection().environmentObject(restaurantType)
                                restaurantTypeSelection.environmentObject(restaurantType)
                                
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
    
    init() {
        self.restaurantTypeSelection = RestaurantTypeSelection()
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
        
        restaurantTypeSelection.valid = restaurantType.currentSelection.isEmpty
        
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
            "restaurantType" : restaurantType.currentSelection
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
    
    @Published var label : String = "Restaurant Cuisine"
    
    /**
     This enables us to follow the Singleton design pattern. In particular, this allows us to reference the same object when we initalaze a RestaurantType in top-level code and pass an environment object of type RestarauntType.
     
     For example, when creating the CreateAccountView, we want to have both a RestaurantTypeSelection and a RestaurantType be instantiated in top-level code. However, RestaurantTypeSelection takes a RestaurantType as an environment variable. Swift won't let us initaliaze an object in top level code and also use that same object in soem other top-level code, so to circumvent this, we must use a singleton pattern. After all, we do want to reference the same object at all times, anyway.
     
     The work-around for the above problem is to have a singleton of RestaurantType that can be accessed statically. That way, we are initalzing the object in the RestaurntTyp, and can simply refer to that object in our top-level code for both the RestaurantType that we use in top-level code, as well as for passing as enviornment variables to our RestaurntTypeSelection.
     */
    static let shared = RestaurantType()
    
    static let MEXICAN : String = "Mexican"
    static let ITALIAN : String = "Italian"
    static let INDIAN : String = "Indian"
    static let THAI : String = "Thai"
    static let FRENCH : String = "French"
    static let CHINESE : String = "Chinese"
    static let JAPANESE : String = "Japanese"
    static let GREEK : String = "Greek"
    static let SPANISH : String = "Spanish"
    
    
    func changeSelection(to: String) {
        currentSelection = to
        label = to
    }
    
    private init() {
        
    }
    
}

/**
 This RestaurantTypeSelection is used as a View which offers the user to change their restaurant type's seletion. Rather than having the code within this struct be thrown into the CreateAccount struct, we simply invoke an stance of this View instead. This increases code reuse (although we do not re use this code), and more importantly, improves code readability.
 
 Note that this struct takes an @EnvironmentObject field. This field is actually of type RestaurantType, and is used to communicate the selected Restaurant Type to the Create Account view. The Create Account View initalzes an instance of RestaurantType and passes it as an environment object to the RestaurantTypeSelection.
 */
private struct RestaurantTypeSelection : View {
    
    /**
     This field is used to communicate the selection between this view and the view which invokes it (CreateAccountView)
     */
    @EnvironmentObject var restaurantType : RestaurantType
    
    @State var valid : Bool = true
    
    var body : some View {
        HStack {
            Menu(restaurantType.label) {
                Button(RestaurantType.CHINESE) {restaurantType.changeSelection(to : RestaurantType.CHINESE)}
                Button(RestaurantType.FRENCH) {restaurantType.changeSelection(to: RestaurantType.FRENCH)}
                Button(RestaurantType.GREEK) {restaurantType.changeSelection(to : RestaurantType.GREEK)}
                Button(RestaurantType.INDIAN){restaurantType.changeSelection(to: RestaurantType.INDIAN)}
                Button(RestaurantType.ITALIAN) {restaurantType.changeSelection(to: RestaurantType.ITALIAN)}
                Button(RestaurantType.JAPANESE) {restaurantType.changeSelection(to: RestaurantType.JAPANESE)}
                Button(RestaurantType.MEXICAN) {restaurantType.changeSelection(to:RestaurantType.MEXICAN)}
                Button(RestaurantType.SPANISH) {restaurantType.changeSelection(to: RestaurantType.SPANISH)}
                Button(RestaurantType.THAI) {restaurantType.changeSelection(to: RestaurantType.THAI)}
            }
            Spacer()
        }.padding().overlay(RoundedRectangle(cornerRadius: 10).stroke(valid ? Color.blue : Color.red, lineWidth : 1)).padding()
    }
}
