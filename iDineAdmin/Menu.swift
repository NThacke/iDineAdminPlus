//
//  Menu.swift
//  iDineAdmin
//
//  Created by Nick Thacke on 7/12/23.
//

import Foundation
import SwiftUI

enum Type {
    case breakfast
    case lunch
    case dinner
}

var loaded = false

struct Menu : View {
    
    @StateObject var viewModel = MenuViewModel()
    
    @State var refresh : Bool = false;
    
    var body : some View {
        List {
            ForEach(viewModel.myItems) {section in
                Section(section.name) {
                    ForEach(section.items) {item in
                        ItemRow(item : item)
                    }
                    .onDelete{
                        offsets in deleteItem(at : offsets, section: section)}
                }
            }
        }.onAppear(perform: {
            viewModel.loadData()
        })
        .refreshable {
            viewModel.loadData()
        }
        
    }
    
    func deleteItem(at offsets : IndexSet, section: MenuSection) {
        if let index = offsets.first {
            if let mySection = viewModel.getSection(name: section.name) {
                let id = mySection.items[index].id
                APIHelper.deleteItem(id : id) {
                    viewModel.loadData()
                }
            }
        }
    }
}

class MenuViewModel: ObservableObject {
    @Published var myItems: [MenuSection] = []
    
    func loadData() {
        APIHelper.getBreakfast { [weak self] items in
            DispatchQueue.main.async {
                self?.myItems.removeAll()
                self?.myItems = items
                loaded = true
            }
        }
    }
    func getSection(name : String) -> MenuSection? {
        for item in myItems {
            if(item.name == name) {
                return item
            }
        }
        return nil
    }
}

struct Breakfast_Previews: PreviewProvider {
    static var previews: some View {
        Menu()
    }
}

func makeBreakfastSection() -> [MenuSection] {
    var mySection = [MenuSection]();
    let classicBreakfast = makeClassicBreakfast();
    let grilledBreakfast = makeGrillBreakfast();
    
    mySection.append(classicBreakfast);
    mySection.append(grilledBreakfast);
    
    return mySection
}

func makeClassicBreakfast() -> MenuSection {
    var mySection = MenuSection(name: "classic breakfasts")
    let pancakes = MenuItem(name: "Pancakes", type : "breakfast", section: "classics", image: "pancakes", price: "5.00", description: "Our pancakes ... ")
    
    let waffles = MenuItem(name: "Waffles", type : "breakfast", section : "classics", image : "Breakfast", price : "6.00", description: "Our waffles are the best!")
    
    let eggsAndBacon = MenuItem(name: "Eggs & Bacon", type : "breakfast", section : "classics", image : "Breakfast", price : "4.50", description : "")
    
    mySection.append(item: pancakes)
    mySection.append(item: waffles)
    mySection.append(item: eggsAndBacon)
    
    return mySection
    
    
}

func makeGrillBreakfast() -> MenuSection {
    var mySection = MenuSection(name: "From the Grill")
    
    let sausageEggAndCheese = MenuItem(name : "Sausage Egg & Cheese", type : "breakfast", section : "grilled", image : "sausageEgg&Cheese", price : "5.00", description: "")
    
    let omelete = MenuItem(name : "Omelet", type : "breakfast", section : "grilled", image : "omelete", price : "6.00", description: "")
    
    mySection.append(item:sausageEggAndCheese)
    mySection.append(item: omelete)
    
    return mySection
}

func makeLunchSection() -> [MenuSection] {
    
    var mySection = [MenuSection]()
    
    let classics = makeClassicLunch()
    
    mySection.append(classics)
    return mySection
}

func makeClassicLunch() -> MenuSection {
    var items = MenuSection(name: "Classics")
    let blt = MenuItem(name: "BLT", type : "lunch", section : "classics", image : "Lunch", price: "5.00", description: "Bacon, lettuce, tomato");
    
    let burger = MenuItem(name: "Burger", type : "lunch", section : "classics", image : "Burger", price : "5.50", description : "Burger");
    items.append(item:blt)
    items.append(item:burger)
    return items
}

func makeLunch() -> [MenuItem] {
    
    var menuItems = [MenuItem]()
    
    let blt = MenuItem(name: "BLT", type : "lunch", section : "classics", image : "Lunch", price: "5.00", description: "Bacon, lettuce, tomato");
    
    let burger = MenuItem(name: "Burger", type : "lunch", section : "classics", image : "Burger", price : "5.50", description : "Burger");
    
    menuItems.append(blt)
    menuItems.append(burger)
    
    return menuItems
}
