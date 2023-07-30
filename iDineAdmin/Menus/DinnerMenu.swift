//
//  LunchMenu.swift
//  iDineAdmin
//
//  Created by Nick Thacke on 7/14/23.
//

import Foundation
import SwiftUI

/**
 This struct serves as the View for when a user is viewing the Dinner menu
 */

struct DinnerMenu : View {
    
    @StateObject var viewModel : MenuViewModel = MenuViewModel(menu : "dinner")
    
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
    
    /**
        This method deletes the given item from the data set. This method is only meant to be invoked internally from the onDelete() modifier on a ForEach loop.
     */
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

struct DinnerMenu_Previews: PreviewProvider {
    static var previews: some View {
        DinnerMenu()
    }
}
