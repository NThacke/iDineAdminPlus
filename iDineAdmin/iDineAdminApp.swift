//
//  iDineAdminApp.swift
//  iDineAdmin
//
//  Created by Nick Thacke on 7/12/23.
//

import SwiftUI
import GooglePlaces
import GoogleMaps

@main
struct iDineAdminApp: App {
    
    let current = AppState()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(current)
        }
    }
}
