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


enum ProgramState {
    
    case AccountLogin
    case CreateAccount
    
}

class AppState : ObservableObject {
    
    static let AccountLogin = "AccountLogin"
    
    static let CreateAccount = "CreateAccount"
    
    @Published var state : String?
    
    @Published var refresh = false
    
}
    
struct ContentView : View {
    
    @EnvironmentObject private var current : AppState
    
    var body : some View {
        
        VStack {
            
            
            Text(current.state ?? "nil").frame(width : 0, height : 0)
            
            switch(current.state) {
            case AppState.AccountLogin : AccountLogin()
            case AppState.CreateAccount : CreateAccount()
                
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
