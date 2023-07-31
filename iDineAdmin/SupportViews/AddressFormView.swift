//
//  AddressFormView.swift
//  iDineAdmin
//
//  Created by Nick Thacke on 7/31/23.
//

import Foundation
import SwiftUI


struct AddressFormView : View {
    
    @ObservedObject var address : Address
    
    var body : some View {
        VStack (alignment : .leading){
            HStack {
                Text("Address")
                Spacer()
            }.padding()
            
            TextField("Address Line", text : $address.line).padding().overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1)).padding()
            
            TextField("City", text : $address.administrativeArea).padding().overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1)).padding()
            
            TextField("State", text : $address.locality).padding().overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1)).padding()
            
            TextField("Postal Code", text : $address.postalCode).padding().overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1)).padding()
            
            TextField("Country", text : $address.region).padding().overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1)).padding()
        }
    }
    
    init(address : Address) {
        self.address = address
    }
}

struct AddressFormViewPreview : PreviewProvider {
    static var previews: some View {
        AddressFormView(address: Address())
    }
}
