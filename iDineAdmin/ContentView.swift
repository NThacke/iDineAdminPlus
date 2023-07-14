//
//  ContentView.swift
//  iDineAdmin
//
//  Created by Nick Thacke on 7/12/23.
//

import SwiftUI

let breakfastMenu = Menu()
var lunchMenu = Menu()

enum ButtonState {
    case breakfast
    case lunch
    case dinner
    case add
    case unselected
}

struct ContentView: View {
    @State private var buttonState : ButtonState = .unselected
    
    @State private var showingPopover = false
    
    @State private var refresh = false
    
    var breakfastItems : [MenuSection] = [MenuSection]();

    
    var body: some View {
        
        VStack {
            VStack {
                HStack {
                    Spacer()
                    Spacer()
                }
                logo()
                
                Spacer()
                HStack {
                    breakfast()
                    lunch()
                    dinner()
                    addMenuItem()
                }
                
                NavigationView {
                    
                    if buttonState == .breakfast {
                        breakfastMenu
                    }
                    else if buttonState == .lunch {
                        lunchMenu
                    }
                    else if buttonState == .dinner {
                        Text("Dinner")
                    }
                    else if buttonState == .add {
                        let adder = AddMenuItemPrompt();
                        
                        VStack {
                            adder
//                            Button("OK", action : {
//                                showingPopover = !adder.isValid();
//                                adder.invokeAPI();
////                                invokeAPI()
//                            })
                        }
                        
        
                    }
                }
            }
        }
    }
    
    func dinner() -> some View {
        Button("Dinner", action : {
            buttonState = .dinner
        })
        .foregroundColor(buttonState == .dinner ? Color.black : Color.blue)
    }
    
    func addMenuItem() -> some View {
        Button("Add Menu Item", action : {
            buttonState = .add
        })
        .foregroundColor(buttonState == .add ? Color.black : Color.blue)
    }
    
    /**
     This method is used to return a view which displays a button.
     Using this instead of directly inserting the view into the callee location enables modular use as well as encourages code readability.
     */
    func lunch() -> some View {
        Button("Lunch", action : {
            buttonState = .lunch
        })
        .foregroundColor(buttonState == .lunch ? Color.black : Color.blue)
    }
    /**
     This method is used to return a view which displays a button.
     Using this instead of directly inserting the view into the callee location enables modular use as well as encourages code readability.
     */
    func breakfast() -> some View {
        Button("Breakfast", action : {
            buttonState = .breakfast
        })
        .foregroundColor(buttonState == .breakfast ? Color.black : Color.blue)
    }
    /**
     This method is used to return a view which displays the logo..
     Using this instead of directly inserting the view into the callee location enables modular use as well as encourages code readability.
     */
    func logo() -> some View {
        Image(systemName: "fork.knife.circle")
            .resizable()
            .padding()
            .frame(width:100, height:100)
    }
    /**
     This method is used to return a view which displays a button.
     Using this instead of directly inserting the view into the callee location enables modular use as well as encourages code readability.
     */
    func cartButton() -> some View {
        Button(action : {
            
        }) {
            Image(systemName: "cart.circle")
                .resizable()
                .frame(width: 25, height:25)
        }
        .padding()
    }
    
    func invokeAPI() {
        let item = MenuItem.example()
        do {
            try APIHelper.putItem(item : item)}
            catch {
                
            }
        }
    }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
