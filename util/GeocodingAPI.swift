//
//  GeocodingAPI.swift
//  iDineAdmin
//
//  Created by Nick Thacke on 7/28/23.
//

import Foundation
import GoogleMaps
import GooglePlaces


/**
    To have the module GoogleMaps imported, you need to have CocoaPods installed.
 
 1.) Install CocoaPods
 
 If you do not have CocoaPods installed, run the following command :
 
    sudo gem install cocoapods
 
 This installs cocoapods.
 
 2.) Go to current directroy
 
 Navigate to the directory this project is located.
 
 cd ~/my/project/location
 
 3.) Initalize the podfile
 
 If there is no Podfile in the project, run the following command :
 
    pod init
 
4,) Modify the podfile to include dependencies
 
 To open the podfile, run the command :
 
    open Podfile
 
To include GoogleMaps as a dependency, insert the following code into the podfile :
 
 "
 #This Podfile is used to get the Google Maps API as a module

 source 'https://github.com/CocoaPods/Specs.git'

 platform :ios, '14.0'

 target 'iDineAdmin' do
   pod 'GoogleMaps', '8.1.0'
 end
 "
 
 5.) Install the dependencies
 
 To install the depencies, simply run the following command :
 
 pod install
 
 6.) All done!
 
 Now you should have the specified depencies imported.
 */

public class GeocodeAPI {
    
    private static let API_KEY : String = "AIzaSyC9gQRohZI8dCljQhc2tjisK_OHNhSwGpM"
    
    static func request(address : String) {
        
        let baseUrl = "https://maps.googleapis.com/maps/api/geocode/json"
        let addressQuery = address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let apiKeyQuery = "key=\(API_KEY)"
        let fullUrl = "\(baseUrl)?address=\(addressQuery)&\(apiKeyQuery)"
        guard let url = URL(string: fullUrl) else {
            print("Invalid URL.")
            return
        }

        // Create and send the request
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            if let data = data {
                // Parse the JSON response
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        // Process the response data here
                        print(json)
                    }
                } catch {
                    print("Error parsing JSON: \(error.localizedDescription)")
                }
            }
        }
        task.resume()
    }
}
