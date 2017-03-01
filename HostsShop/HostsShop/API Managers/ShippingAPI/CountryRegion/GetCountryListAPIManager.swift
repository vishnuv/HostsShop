//
//  GetCountryListAPIManager.swift
//  HostsShop
//
//  Created by Vishnu Vardhan PV on 22/01/17.
//  Copyright © 2017 vishnuvardhanpv. All rights reserved.
//

import Foundation
import ObjectMapper

class GetCountryListAPIManager: ApiManager {
    typealias ApiCallback = ([Country]?, Error?) -> Void

    class func getCountryList(callback: @escaping ApiCallback) {
        var request = URLRequest(url: URL(string: Constants.API.baseUrl + Constants.API.getCountryList)!)
        request.httpMethod = "POST"
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
                if dict.count != 0 {
                    let response = Mapper<Country>().mapArray(JSONObject: dict)
                    callback(response, nil)
                }
            }
        }
        task.resume()
    }

    class func convertToDictionary(text: String) -> NSArray {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as! NSArray
            } catch {
                print(error.localizedDescription)
            }
        }
        return []
    }
}
