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

struct BreakfastMenu : View {
    
    @StateObject var viewModel : MenuViewModel = MenuViewModel(menu : "breakfast")
    
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
    
    @Published var menu : String = ""
    
    func loadData() {
        APIHelper.retrieveMenuItems(menu : menu) { [weak self] items in
            DispatchQueue.main.async {
                self?.myItems.removeAll()
                self?.myItems = items
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
    
    init(menu : String) {
        self.menu = menu
    }
}

struct Breakfast_Previews: PreviewProvider {
    static var previews: some View {
        BreakfastMenu()
    }
}
