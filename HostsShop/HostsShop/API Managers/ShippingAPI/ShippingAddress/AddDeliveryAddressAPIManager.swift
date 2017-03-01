//
//  AddDeliveryAddressAPIManager.swift
//  HostsShop
//
//  Created by Vishnu Vardhan PV on 22/01/17.
//  Copyright © 2017 vishnuvardhanpv. All rights reserved.
//

import Foundation

class AddDeliveryAddressAPIManager: ApiManager {
    typealias ApiCallback = ([String:String]?, Error?) -> Void

    class func addDeliveryAddressAPIManager(sessionId: String, emailId: String, streetAddress: String, firstName: String, lastName: String, telephone: String, countryId: String, region: String, city: String, zipCode: String, callback: @escaping ApiCallback) {
        var request = URLRequest(url: URL(string: Constants.API.baseUrl + Constants.API.addDeliveryAddress)!)
        request.httpMethod = "POST"
        let postString = "session_id=\(sessionId)&email_id=\(emailId)&street_address=\(streetAddress)&firstName=\(firstName)&lastName=\(lastName)&telephone=\(telephone)&country_id=\(countryId)&region=\(region)&city=\(city)&zipcode=\(zipCode)"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("error=\(error)")
                callback(nil, error)
                return
            }

            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }

            let responseString = String(data: data, encoding: .utf8)
            let dict = self.convertToDictionary(text: responseString!)

            if let error = error {
                callback(nil, error)
            } else {
                if let json = dict {
                    callback(json as? [String: String], nil)
                }
            }
        }
        task.resume()
    }

    class func addDeliveryAddressWithAddressIdAPIManager(sessionId: String, emailId: String, addressId: String, callback: @escaping ApiCallback) {
        var request = URLRequest(url: URL(string: Constants.API.baseUrl + Constants.API.addDeliveryAddress)!)
        request.httpMethod = "POST"
        let postString = "session_id=\(sessionId)&email_id=\(emailId)&address_id=\(addressId)"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("error=\(error)")
                callback(nil, error)
                return
            }

            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }

            let responseString = String(data: data, encoding: .utf8)
            let dict = self.convertToDictionary(text: responseString!)

            if let error = error {
                callback(nil, error)
            } else {
                if let json = dict {
                    callback(json as? [String: String], nil)
                }
            }
        }
        task.resume()
    }

    class func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
