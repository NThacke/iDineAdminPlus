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


enum ProgramState {
    
    case AccountLogin
    case CreateAccount
    
}

class AppState : ObservableObject {
    
    @Published var state : ProgramState? {
        didSet {
            objectWillChange.send()
        }
    }
    
}
struct ContentView : View {
    
    @EnvironmentObject private var current : AppState
    
    var body : some View {
        
        switch(current.state) {
            case .AccountLogin : AccountLogin()
            case .CreateAccount : CreateAccount()
            
        case nil : AccountLogin()
        }
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(AppState())
    }
}
