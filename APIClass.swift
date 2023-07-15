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
    
    
    /**
     This method returns every MenuSection belonging to the Breakfast Menu. It determines the Sections when it invokes the API. The API returns back every item in the givent Menu, and this method then filters the Sections found within each item, and appends it to the appropriate one. If it comes across a section it is unaware of, it makes a new one.
     
        example usage :
            
     retrieveMenuItems(menu : "breakfast") { items in
            myItems = items
     }
     
     */
    static func retrieveMenuItems(menu : String, completion : @escaping ([MenuSection]) -> Void) {
        var sections = [String]() //menu sections
        var mySections = [MenuSection]()
    
        
        getItems(menuType : menu) {items in
            for item in items {
                if(newSection(sections : sections, section : item.sectionType)) {
                    //newly found section, create it and append the item
                    sections.append(item.sectionType)
                    var newSection = MenuSection(name : item.sectionType)
                    newSection.append(item : item)
                    mySections.append(newSection)
                }
                else {
                    for i in 0..<mySections.count {
                        if(mySections[i].name == item.sectionType) {
                            mySections[i].append(item : item) //you must append an item by referencing it directly, not using a variable!
                        }
                    }
                }
            }
            completion(mySections)
        }
    }
    
    /**
            This method is used to determine if a particular section is a newly found section. This is useful for getting data from the API. When we get every breakfast item, we want to be able to categroize them by sections. We don't know how many sections there are prior to this invocation -- as such,. we create new MenuSections any time that we encounter a new section.
     */
    private static func newSection(sections : [String], section : String) -> Bool {
        for item in sections {
            if(item == section) {
                return false
            }
        }
        return true
    }
    
    static func putItem(item : MenuItem) throws {
        print("Inside putItem function")
            
            guard let url = URL(string: "https://nueyl8ey42.execute-api.us-east-1.amazonaws.com/testing/menu") else {
                print("Invalid URL")
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
        
        print("Image has \(item.image.count) characters")
                
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
    
    private static func getItems(menuType: String, completion: @escaping ([MenuItem]) -> Void) {
//        print("Inside getItems function for section \(sectionType)")

        // Set the API endpoint URL
        let url = URL(string: "https://nueyl8ey42.execute-api.us-east-1.amazonaws.com/testing/menu?menuType=\(menuType)")!

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
//                print("Status code: \(httpResponse.statusCode)")

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
//        print("Inside process function")
//        print(data)
        do {
            let decoder = JSONDecoder()
            let jsonData = try decoder.decode([MenuItem].self, from: data)
//            print("JSON DATA : \(jsonData)")
            return jsonData
        } catch {
//            print("Error decoding JSON: \(error.localizedDescription)")
            print(String(describing: error))
            return []
        }
    }
    
    /**
    
     This method deletes the item with the specified ID from the DynamoDB database that is backing the restaurant menu.
                
            This method is a completion handler, which enables one to invoke this method, and then run code once it has been completed.
                 
            For example,
                 
            APIHelper.deletItem(id : "1234") {
                //code to run after deleting the item (perhaps just a refresh method)
                refresh()
            }
     
     */
    static func deleteItem(id : String, completion : @escaping () -> Void) {
        
        print("Inside delete function in APIHelper.")
        // Set the API endpoint URL
        let url = URL(string: "https://nueyl8ey42.execute-api.us-east-1.amazonaws.com/testing/menu?id=\(id)")!

        // Create a URLSession instance
        let session = URLSession.shared
        
        var request = URLRequest(url : url)
        request.httpMethod = "DELETE"
        

        // Create a data task
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion() // Call the completion handler with an empty array
            }

            // Handle the API response
            if let httpResponse = response as? HTTPURLResponse {
                print("Status code: \(httpResponse.statusCode)")
                completion()
            } else {
                completion() // Call the completion handler with an empty array
            }
        }
        // Start the data task
        task.resume()
    }
}
