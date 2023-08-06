//
//  AccountLogin.swift
//  iDineAdmin
//
//  Created by Nick Thacke on 7/19/23.
//

/**
 This view is the inital view that the user sees on boot up. This view prompts the user to login or to create an account if they do not have an account.
 */
import Foundation
import SwiftUI


struct AccountLogin : View {
    
    @EnvironmentObject private var current : AppState
    
    @State var email : String = ""
    @State var password : String = ""
    
    @State var loginSuccessful = false
    @State var createAccount = false
    
    @State var error = false
    
    @State var loading = false
    
    @State var emptyEmail = false
    
    @State var emptyPassword = false
    
    var body : some View {
            VStack (alignment : .center) {
                
                Image(systemName : "globe").padding()
                
                if(error) {
                    Text("Either email or password are incorrect.").foregroundColor(Color.red)
                }
                
                if(emptyEmail) {
                    TextField("Email", text : $email).padding().overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.red, lineWidth: 1)).padding().onChange(of: email) { newValue in
                        error = false
                        emptyEmail = false
                        
                    }
                }
                else {
                    TextField("Email", text : $email).padding().overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1)).padding().onChange(of: email) { newValue in
                        error = false
                    }
                }
                
                if(emptyPassword) {
                    SecureField("Password", text : $password).padding().overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.red, lineWidth: 1)).padding().onChange(of: password) { newValue in
                        error = false
                        emptyPassword = false
                    }
                }
                else {
                    SecureField("Password", text : $password).padding().overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1)).padding().onChange(of: password) { newValue in
                        error = false
                    }
                }
                
                HStack {
                    Spacer()
                    ZStack {
                        RoundedRectangle(cornerRadius: 10).frame(width:150, height:50).foregroundColor(Color.blue)

                        Button("Create Account") {
                            current.state = AppState.CreateAccount
                            
                        }.foregroundColor(Color.white)
                    }
                    
                    Spacer()
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 10).frame(width:75, height:50).foregroundColor(Color.blue)
                        
                        Button("Login") {
                            login()
                        }.foregroundColor(Color.white)
                    }
                    Spacer()
                }
                if(loading) {
                    // This is the loading icon (indeterminate spinner)
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                }
            }
    }
    
    func login() {
        if(nonEmptyEntries()) {
            email = email.lowercased()
            loading = true
            getSalt() { s in
                let salt = s
                print("salt is \(salt)")
                let saltedHashedPassword = sha256Hash(password+salt)
                attemptLogin(email : email, password : saltedHashedPassword) {
                    loading = false
                    print("Error : \(error)")
                    if(!error) {
                        Manager.getAccountInfo(email: email) {acc in
                            Manager.account = acc!
                            current.state = AppState.MenuView
                        }
                    }
                    
                }
            }
        }
    }
    func nonEmptyEntries() -> Bool {
        if email.isEmpty {
            emptyEmail = true
        }
        if password.isEmpty {
            emptyPassword = true
        }
        
        return !email.isEmpty && !password.isEmpty
    }
    
    func attemptLogin(email : String, password : String, completion : @escaping () -> Void) {
        
        let url = URL(string: "https://vqffc99j52.execute-api.us-east-1.amazonaws.com/Testing/admin_account?email=\(email)&password=\(password)")!

        // Create a URLSession instance
        let session = URLSession.shared

        // Create a data task
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion() // Call the completion handler with an empty array
                return
            }

            // Handle the API response
            if let httpResponse = response as? HTTPURLResponse {
                
                if(httpResponse.statusCode != 200) {
                    self.error = true
                    completion()
                }
                else {
                    self.error = false
                    completion()
                }
            } else {
                completion() // Call the completion handler with an empty array
            }
        }

        // Start the data task
        task.resume()
    }
    
    func getSalt(completion : @escaping (String) -> Void) {
        let url = URL(string: "https://vqffc99j52.execute-api.us-east-1.amazonaws.com/Testing/admin_account/salt?email=\(email)")!

        // Create a URLSession instance
        let session = URLSession.shared

        // Create a data task
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion("") // Call the completion handler with an empty array
                return
            }

            // Handle the API response
            if let httpResponse = response as? HTTPURLResponse {
                
                if(httpResponse.statusCode != 200) {
                    self.error = true
                }

                if let data = data {
                    let item = process(data: data)
                    
                    completion(item) // Call the completion handler with the received items
                } else {
                    completion("") // Call the completion handler with an empty array
                }
            } else {
                completion("") // Call the completion handler with an empty array
            }
        }

        // Start the data task
        task.resume()
    }
    
    private func process(data: Data ) -> String {
//        print("Inside process function")
//        print(data)
        do {
            let decoder = JSONDecoder()
            let jsonData = try decoder.decode(String.self, from: data)
//            print("JSON DATA : \(jsonData)")
            return jsonData
        } catch {
//            print("Error decoding JSON: \(error.localizedDescription)")
            print(String(describing: error))
            return ""
        }
    }
}

struct AccountLogin_Previews: PreviewProvider {
    static var previews: some View {
        AccountLogin().environmentObject(AppState())
    }
}

