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
import Combine


class AppState : ObservableObject {
    
    static let AccountLogin = "AccountLogin"
    
    static let CreateAccount = "CreateAccount"
    
    static let MenuView = "MenuView"
    
    static let AccountView = "AccountView"
    
    static let AccountEditView = "AccountEditView"
    
    @Published var state : String?
}
    
struct ContentView : View {
    
    @EnvironmentObject private var current : AppState
    
    var body : some View {
        
        VStack {
            
            
            Text(current.state ?? "nil").frame(width : 0, height : 0) //Purpose : Ensures refreshing of this View whenever the current.state changes.
            
            switch(current.state) {
            case AppState.AccountLogin : AccountLogin()
                case AppState.CreateAccount : CreateAccount()
                case AppState.MenuView : MenuView()
                case AppState.AccountView : AccountView()
                case AppState.AccountEditView : AccountEditView()
                
                default : AccountLogin()
            }
        }
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    
    static let current : AppState = AppState()
    
    static var previews: some View {
        ContentView().environmentObject(current)
    }
}
