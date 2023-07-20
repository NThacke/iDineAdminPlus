//
//  Manager.swift
//  iDineAdmin
//
//  Created by Nick Thacke on 7/20/23.
//

import Foundation


class Manager {
    
    var account : AdminAccount
    
    init(account : AdminAccount) {
        self.account = account
    }
    
    /**
            Creates a new manager from the given email. This function calls an API to gather information regarding this account's email.
     */
    init(email : String) {
        self.account = AdminAccount.example()
        getInfo(email : email) {acc in
            self.account = acc!
        }
        
    }
    
    func getInfo(email : String, completion : @escaping (AdminAccount?) -> Void) {
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
                print("Status code: \(httpResponse.statusCode)")

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
    
    func process(data : Data) -> AdminAccount? {
        print("Inside process function in Manager")
              do {
                  let decoder = JSONDecoder()
                  let jsonData = try decoder.decode(AdminAccount.self, from: data)
                  return jsonData
              } catch {
                  print(String(describing: error))
                  return nil
              }
    }
    
    static func example() -> Manager {
        
        let account = AdminAccount.example()
        
        return Manager(account : account);
    }
    
}
