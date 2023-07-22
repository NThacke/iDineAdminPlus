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


/**
 This class is used to store the current state of the app and to pass the state throughout every View. There should only be one instance of this object within the app, invoked by the iDineAdminApp struct.
 
 For example,
 
 ContentView().environmentObject(AppState()))
 
 will instantiate a ContentView struct, and pass the environment object as a newly instantiated AppState object. Then, any views invoked within ContentView will inherit the EnvironmentObject.
 
 To modify the current state, a View would only need to perform the following :
 
 current.state = AppState.$myChosenState
 
 Note that this assumes that the View has an EnvironmentObject field, such as :
 
 @EnvironmentObject private var current : AppState
 */
class AppState : ObservableObject {
    /**
        The AccountLogin View's internal representation.
     */
    static let AccountLogin = "AccountLogin"
    static let CreateAccount = "CreateAccount"
    static let MenuView = "MenuView"
    static let AccountView = "AccountView"
    static let AccountEditView = "AccountEditView"
    
    @Published var state : String?
}

/**
    This View serves as the view which displays the appropriate View to the user dependent upon the state of the app.
        
 The EnvironmentObject current : AppState contains the current state of the app. Whenever the state field changes, this view sees the change and then appropriately invokes the correct view to display to the user.
 */
    
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
