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
            Communicator.location = newText
        }
    }
    
    func text() -> String {
        return self.searchText
    }
}

class Util {
    
//    AIzaSyDZqxzoEgoqa2lZlyheQlit-HzFDcJa4h8
    
    
    static func isAddressValid(address : Address, completion: @escaping (Bool) -> Void) {
        // Set the API endpoint URL
        guard let url = URL(string: "https://addressvalidation.googleapis.com/v1:validateAddress?key=AIzaSyDZqxzoEgoqa2lZlyheQlit-HzFDcJa4h8") else {
            print("Invalid URL")
            return
        }
        
        printHelperInfo(address : address)
        
        //set the request method to be PUT
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
            
        if let requestBody = createJSONBody(address : address) {
            request.httpBody = requestBody
        }
        
        //idk
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //start up the connection
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Status Code: \(httpResponse.statusCode)")
                //status code
                if(httpResponse.statusCode == 200) {
                    //valid address
                    completion(true)
                    
                }
                
                //body
                if let data = data {
                            if let bodyString = String(data: data, encoding: .utf8) {
                                print("Response Body: \(bodyString)")
                                
                                // Now you can use the body data as needed
                            }
                        }
                completion(false)
            }
        }
        
        task.resume()
    }
    
    private static func printHelperInfo(address : Address) {
        print("The following information is the address you entered.")
        print("Address Line : \(address.line)")
        print("City : \(address.locality)")
        print("Postal Code : \(address.postalCode)")
        print("Region : \(address.region)")
    }
            
    private static func createJSONBody(address : Address) -> Data? {
        let jsonData: [String: Any] = [
            "address": [
                "regionCode": address.region,
                "locality": address.locality,
                "administrativeArea": address.administrativeArea,
                "postalCode": address.postalCode,
                "addressLines": [address.line]
            ],
            "enableUspsCass": true
        ]
        
        do {
            let jsonBody = try JSONSerialization.data(withJSONObject: jsonData, options: .prettyPrinted)
            return jsonBody
        } catch {
            print("Error encoding JSON: \(error.localizedDescription)")
            return nil
        }
    }
}

class Address : ObservableObject{
    @Published var region : String = ""
    @Published var locality : String = ""
    @Published var administrativeArea : String = ""
    @Published var postalCode : String = ""
    @Published var line : String = ""
}
