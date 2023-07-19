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
    
    @State var username : String = ""
    @State var password : String = ""
    
    @State var loginSuccessful = false
    @State var createAccount = false
    
    var body : some View {
        NavigationView {
            VStack (alignment : .center) {
                Image(systemName : "globe").padding()
                
                TextField("Email", text : $username).padding().overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1)).padding()
                
                SecureField("Password", text : $password).padding().overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1)).padding()
                
                HStack {
                    Spacer()
                    ZStack {
                        RoundedRectangle(cornerRadius: 10).frame(width:150, height:50).foregroundColor(Color.blue)

                        Button("Create Account") {
                            createAccount = true
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
            }
            .background(
                        NavigationLink(destination: CreateAccount(), isActive: $createAccount) {
                            EmptyView()
                        }
            ).background(            NavigationLink(destination: ContentView(), isActive: $loginSuccessful, label : {
                EmptyView()}
            ))
            
        }
    }
    
    func login() {
        loginSuccessful = true
    }
}

struct AccountLogin_Previews: PreviewProvider {
    static var previews: some View {
        AccountLogin()
    }
}
