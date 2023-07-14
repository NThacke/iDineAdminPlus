//
//  APIClass.swift
//  iDineAdmin
//
//  Created by Nick Thacke on 7/12/23.
//

import Foundation

/**
 The purpose of this class is to handle API requests to our AWS API endpoint.
 This class will handle retrieving data as well as sending new data to the API.
 */

public class APIHelper {
    
    static var breakfastItems : [MenuSection] = [MenuSection]()
    
    
    static func getBreakfast( completion : @escaping ([MenuSection]) -> Void) {
        
        var classicBreakfasts = MenuSection(name: "Classics")
        
        getItems( menuType: "breakfast", sectionType: "classics") { items in
            breakfastItems = []
            for item in items {
                classicBreakfasts.append(item: item)
            }
            breakfastItems.append(classicBreakfasts)
            completion(breakfastItems)
        }
        
    }
    static func getLunch() -> [MenuSection] {
        return [MenuSection]()
    }
    static func getDinner() -> [MenuSection] {
        return [MenuSection]()
    }
    
    static func putItem(item : MenuItem) throws {
        print("Inside putItem function")
            
            guard let url = URL(string: "https://nueyl8ey42.execute-api.us-east-1.amazonaws.com/testing/menu") else {
                print("Invalid URL")
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
                
            let requestBody = [
                "id": item.id,
                "name": item.name,
                "menuType": item.menuType,
                "sectionType": item.sectionType,
                "image" : item.image,
                "description" : item.description,
                "price": item.price
            ] as [String : String]
            
            do {
                let jsonData = try JSONEncoder().encode(requestBody)
                request.httpBody = jsonData
            } catch {
                print("Error encoding JSON: \(error)")
                return
            }
            
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let session = URLSession.shared
            let task = session.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Error: \(error)")
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    print("Status Code: \(httpResponse.statusCode)")
                }
            }
            
            task.resume()
    }
    
    static func getItems(menuType: String, sectionType: String, completion: @escaping ([MenuItem]) -> Void) {
        print("Inside getItems function for section \(sectionType)")

        // Set the API endpoint URL
        let url = URL(string: "https://nueyl8ey42.execute-api.us-east-1.amazonaws.com/testing/menu?menuType=\(menuType)&sectionType=\(sectionType)")!

        // Create a URLSession instance
        let session = URLSession.shared

        // Create a data task
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion([]) // Call the completion handler with an empty array
                return
            }

            // Handle the API response
            if let httpResponse = response as? HTTPURLResponse {
                print("Status code: \(httpResponse.statusCode)")

                if let data = data {
                    let items = process(data: data)
                    
                    completion(items) // Call the completion handler with the received items
                } else {
                    completion([]) // Call the completion handler with an empty array
                }
            } else {
                completion([]) // Call the completion handler with an empty array
            }
        }

        // Start the data task
        task.resume()
    }
    private static func process(data: Data ) -> [MenuItem] {
        print("Inside process function")
        print(data)
        do {
            let decoder = JSONDecoder()
            let jsonData = try decoder.decode([MenuItem].self, from: data)
            print("JSON DATA : \(jsonData)")
            return jsonData
        } catch {
//            print("Error decoding JSON: \(error.localizedDescription)")
            print(String(describing: error))
            return []
        }
    }
}
