//
//  Manager.swift
//  iDineAdmin
//
//  Created by Nick Thacke on 7/20/23.
//

import Foundation


class Manager {
    
    static var account : AdminAccount = AdminAccount.example()
    
    
    static func getAccountInfo(email : String, completion : @escaping (AdminAccount?) -> Void) {
        // Set the API endpoint URL
        print(email)
        let url = URL(string: "https://vqffc99j52.execute-api.us-east-1.amazonaws.com/Testing/admin_account/info?email=\(email)")!

        // Create a URLSession instance
        let session = URLSession.shared

        // Create a data task
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(nil) // Call the completion handler with an empty array
                return
            }

            // Handle the API response
            if let httpResponse = response as? HTTPURLResponse {
//                print("Status code: \(httpResponse.statusCode)")

                if let data = data {
                    let item = self.process(data: data)
                    
                    completion(item) // Call the completion handler with the received items
                } else {
                    completion(nil) // Call the completion handler with an empty array
                }
            } else {
                completion(nil) // Call the completion handler with an empty array
            }
        }

        // Start the data task
        task.resume()
    }
    
    static func getAccountDetails(email: String, completion: @escaping (AccountDetails?) -> Void) {
        let url = URL(string: "https://vqffc99j52.execute-api.us-east-1.amazonaws.com/Testing/admin_account/details?email=\(email)")!

        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(nil)
                return
            }

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
               let data = data {
                let accountDetails = self.processAccountDetails(data: data)
                completion(accountDetails)
            } else {
                completion(nil)
            }
        }

        task.resume()
    }
    
    private static func process(data : Data) -> AdminAccount? {
              do {
                  let decoder = JSONDecoder()
                  let jsonData = try decoder.decode(AdminAccount.self, from: data)
                  return jsonData
              } catch {
                  print(String(describing: error))
                  return nil
              }
    }
    
    
    
    
}
