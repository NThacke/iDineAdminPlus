//
//  CreateAccount.swift
//  iDineAdmin
//
//  Created by Nick Thacke on 7/19/23.
//

import Foundation
import SwiftUI


struct CreateAccount : View {
    
    /**
            The email associated with the newly created account.
     */
    @State var email : String = ""
    
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
    
    
    
    var body : some View {
            VStack (alignment : .center) {
                Image(systemName : "globe").padding()
                
                HStack {
                    Text("Account Info").padding()
                    Spacer()
                }
                
                TextField("Email", text : $email).padding().overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1)).padding()
                
                SecureField("Password", text : $password).padding().overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1)).padding()
                
                HStack {
                    Text("Restaurant Info").padding()
                    Spacer()
                    Button(action : {
                        restaurantInfo.toggle()
                    }) {
                        Image(systemName : "info.circle")
                    }
                }
                
                if(restaurantInfo) {
                    ScrollView {
                        Text("To put a restaurant on this app, you need a name and a location to begin with. These can be changed later. However, only one restaurant may be associated with an account.").foregroundColor(Color.gray).padding()
                    }
                }
                TextField("Restaurant Name", text : $restaurantName).padding().overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1)).padding()
                TextField("Restaurant Location", text : $location).padding().overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1)).padding()
                
                ZStack {
                    RoundedRectangle(cornerRadius : 10).foregroundColor(Color.blue).frame(width: 50, height:50)
                    Button("OK", action : {
                        
                    }).foregroundColor(Color.white)
                }
                Spacer()
            }.padding()
        }
    }
struct CreateAccount_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccount()
    }
}
