//
//  UpdateCustomerAddressAPIManager.swift
//  HostsShop
//
//  Created by Vishnu Vardhan PV on 17/02/17.
//  Copyright © 2017 vishnuvardhanpv. All rights reserved.
//

import Foundation
import ObjectMapper

class UpdateCustomerAddressAPIManager: ApiManager {
    typealias ApiCallback = ([String: String]?, Error?) -> Void

    class func updateCustomerAddress(sessionId: String, countryId: String, region: String, city: String, pincode: String, callback: @escaping ApiCallback) {
        var request = URLRequest(url: URL(string: Constants.API.baseUrl + Constants.API.UpdateCustomerAddress)!)
        request.httpMethod = "POST"
        let postString = "session_id=\(sessionId)&country_id=\(countryId)&region=\(region)&city=\(city)&pincode=\(pincode)"
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
