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
        
        getAccountDetails(email : email) { details in
            getAccountAddress(id : details!.id) { address in
//                let acount = AdminAccount(details : details ?? AdminAccount.example().details, address : address ?? AdminAccount.example().address)
                let acc = AdminAccount(details : details!, address : address!)
                print("**********************")
                print("-----------------")
                print("Account Details")
                print("-----------------")
                print("Email : \(account.details.email)")
                print("Name : \(account.details.restaurantName)")
                print("-----------------")
                print("Account Address")
                print("-----------------")
                print("Line : \(account.address.line)")
                print("Locality : \(account.address.locality)")
                print("**********************")
                completion(acc)
            }
        }
    }
    
    static func getAccountDetails(email: String, completion: @escaping (AccountDetails?) -> Void) {
        
        print("Getting account details for \(email)")
        let url = URL(string: "https://vqffc99j52.execute-api.us-east-1.amazonaws.com/Testing/admin_account/info?email=\(email)")!

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
                print(accountDetails!)
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
    
    static func getAccountAddress(id: String, completion: @escaping (AccountAddress?) -> Void) {
        print("Getting account address for \(id)")
        let url = URL(string: "https://vqffc99j52.execute-api.us-east-1.amazonaws.com/Testing/admin_account/address?id=\(id)")!

        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(nil)
                return
            }

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
               let data = data {
                let accountAddress = self.processAccountAddress(data: data)
                print(accountAddress)
                completion(accountAddress)
            } else {
                completion(nil)
            }
        }

        task.resume()
    }
    
    private static func processAccountDetails(data : Data) -> AccountDetails? {
        do {
            let decoder = JSONDecoder()
            let jsonData = try decoder.decode(AccountDetails.self, from: data)
            return jsonData
        } catch {
            print(String(describing: error))
            return nil
        }
    }
    
    private static func processAccountAddress(data : Data) -> AccountAddress? {
        do {
            let decoder = JSONDecoder()
            let jsonData = try decoder.decode(AccountAddress.self, from: data)
            return jsonData
        } catch {
            print(String(describing: error))
            return nil
        }
    }
    
    
    
    
}
