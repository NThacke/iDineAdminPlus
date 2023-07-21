//
//  AccountView.swift
//  iDineAdmin
//
//  Created by Nick Thacke on 7/21/23.
//

import Foundation
import SwiftUI


struct AccountView : View {
    
    var body :  some View {
        
        VStack {
            Group {
                Text(Manager.account.email)
                
            }
            if let image = Manager.account.image() {
                Image(uiImage: image)
            }
        }
    }
}


struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
