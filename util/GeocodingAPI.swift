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

//This does not work.

//class GeocodeAPI : UIViewController { //The Struggle : This was difficult.
//    private static let API_KEY : String = "AIzaSyC9gQRohZI8dCljQhc2tjisK_OHNhSwGpM"
//
//    private var placesClient: GMSPlacesClient!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        print("Giving API Key")
//        GMSServices.provideAPIKey(GeocodeAPI.API_KEY)
//        placesClient = GMSPlacesClient.shared()
//    }
//
//    func fetchAddressSuggestions(for query: String) {
//
//        print("Inside fetch address suggestions")
//        GMSServices.provideAPIKey(GeocodeAPI.API_KEY)
//        placesClient = GMSPlacesClient.shared()
//
//        let filter = GMSAutocompleteFilter()
//        // You can customize the filter to only show specific types of results like cities or addresses.
//        // filter.type = .address
//
//
//        placesClient.findAutocompletePredictions(fromQuery: query, filter: filter, sessionToken: nil) { (results, error) in
//
//            print("In auto complete")
//
//            if let error = error {
//                print("Autocomplete error: \(error.localizedDescription)")
//                return
//            }
//
//            if let results = results {
//                // Process the autocomplete results and display suggestions to the user.
//                for prediction in results {
//                    print("Place ID: \(prediction.placeID), Description: \(prediction.attributedFullText.string)")
//                }
//            }
//        }
//    }
//}
//
//class ViewController: UIViewController {
//    private static let API_KEY : String = "AIzaSyC9gQRohZI8dCljQhc2tjisK_OHNhSwGpM"
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        GMSServices.provideAPIKey(ViewController.API_KEY)
//
//        // Do any additional setup after loading the view.
//        // Create a GMSCameraPosition that tells the map to display the
//        // coordinate -33.86,151.20 at zoom level 6.
//        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
//        let mapView = GMSMapView.map(withFrame: view.frame, camera: camera)
//        view.addSubview(mapView)
//
//        // Creates a marker in the center of the map.
//        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
//        marker.title = "Sydney"
//        marker.snippet = "Australia"
//        marker.map = mapView
//    }
//}
