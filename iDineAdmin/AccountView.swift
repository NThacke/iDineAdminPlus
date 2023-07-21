//
//  AccountView.swift
//  iDineAdmin
//
//  Created by Nick Thacke on 7/21/23.
//

import Foundation
import SwiftUI

struct AccountView : View {
    
    @State var edit = false
    
    @State var cancel = false
    
    var body :  some View {
        
        NavigationView {
            VStack {
                Group {
                    HStack {
                        Text("Account").bold()
                        Spacer()
                    }
                    if let image = Manager.account.image() {
                        Image(uiImage: image).resizable().frame(width: 75, height : 75)
                    }
                    Rectangle().frame(width: 250, height: 1.5).foregroundColor(Color.blue)
                    Text(Manager.account.email).foregroundColor(Color.gray)
                }
                
                Group {
                    VStack {
                        HStack {
                            Spacer()
                        }
                        Group { //Group for restaurant name information
                            HStack {
                                Text("Restaurant Name").foregroundColor(Color.gray)
                                Spacer()
                            }
                            HStack {
                                Text(Manager.account.restaurantName)
                                Spacer()
                            }.padding()
                                .overlay(RoundedRectangle(cornerRadius : 10).stroke(Color.blue))
                        }
                        
                        Group { //Group for location information
                            HStack {
                                Text("Restaurant Location").foregroundColor(Color.gray)
                                Spacer()
                            }
                            HStack {
                                Text(Manager.account.restaurantLocation)
                                Spacer()
                            }.padding()
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue))
                        }
                    }
                    Spacer()
                }.padding()
            
            Group { //Group for cancel / submit buttons
                HStack {
                    ZStack { //Back button
                        RoundedRectangle(cornerRadius: 10).frame(width:100, height: 50).foregroundColor(Color.blue)
                        Button("Back") {
                            cancel = true
                        }.foregroundColor(Color.white)
                    }
                    Spacer()
                    
                    ZStack { //Edit button
                        RoundedRectangle(cornerRadius: 10).frame(width:100, height: 50).foregroundColor(Color.blue)
                        Button("Edit") {
                            edit = true
                        }.foregroundColor(Color.white)
                    }
                }
                
            }
            
            
            Spacer() //Ensures that the entire vstack is tight to the top of the screen
        }.padding()
            .background(NavigationLink(destination : MenuView(), isActive : $cancel) {
                EmptyView()
            })
            .background(NavigationLink(destination : AccountEditView(), isActive : $edit) {
                EmptyView()
            })
        }.navigationBarBackButtonHidden(true)
    }
}



struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
