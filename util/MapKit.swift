//
//  MapKit.swift
//  iDineAdmin
//
//  Created by Nick Thacke on 7/28/23.
//

import Foundation
import SwiftUI
import MapKit

class AddressSearchCompleter: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    @Published var suggestions: [MKLocalSearchCompletion] = []
    
    private let completer: MKLocalSearchCompleter
    
    override init() {
        completer = MKLocalSearchCompleter()
        super.init()
        completer.delegate = self
    }
    
    func updateSearchResults(for searchText: String) {
        completer.queryFragment = searchText
    }
    
    // MKLocalSearchCompleterDelegate method to handle changes in search results
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        suggestions = completer.results
    }
}

struct AddressSearchView: View {
    @State private var searchText: String = ""
    @ObservedObject private var completer = AddressSearchCompleter()
    
    @ObservedObject private var fields : ChangeTracker
    
    var body: some View {
        VStack {
            TextField("Search for an address...", text: $searchText, onEditingChanged: { isEditing in
                // Implement any necessary logic when the search bar starts/ends editing
            }, onCommit: {
                // Implement any necessary logic when the user presses the search button
            })
            .textFieldStyle(RoundedBorderTextFieldStyle()) // Add a border to the search bar
            
            ScrollView {
                VStack(alignment : .leading) {
                    ForEach(completer.suggestions, id : \.title) { suggestion in
                        VStack(alignment: .leading) {
                            Text(suggestion.title)
                                .font(.headline)
                            Text(suggestion.subtitle)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .onTapGesture() {
                            searchText = suggestion.title + " " + suggestion.subtitle
                        }
                    }
                }
            }.frame(width : .infinity, height : 100)
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
            // Clear the search text and suggestions when the app resigns active state
            self.searchText = ""
            self.completer.suggestions.removeAll()
        }
        .onChange(of: searchText) { newText in
            // Update the search results as the user types
            self.completer.updateSearchResults(for: newText)
            fields.restaurantLocation = newText
        }
    }
    
    func text() -> String {
        return self.searchText
    }
    
    init(changeTracker : ChangeTracker) {
        self.fields = changeTracker
    }
}
