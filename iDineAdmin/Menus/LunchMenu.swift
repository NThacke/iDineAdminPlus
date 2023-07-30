//
//  LunchMenu.swift
//  iDineAdmin
//
//  Created by Nick Thacke on 7/14/23.
//

import Foundation
import SwiftUI

struct LunchMenu : View {
    
    @StateObject var viewModel : MenuViewModel = MenuViewModel(menu : "lunch")
    
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

struct LunchMenu_Previews: PreviewProvider {
    static var previews: some View {
        LunchMenu()
    }
}
