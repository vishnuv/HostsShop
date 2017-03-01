//
//  SearchAPIManager.swift
//  HostsShop
//
//  Created by Vishnu Vardhan PV on 22/02/17.
//  Copyright © 2017 vishnuvardhanpv. All rights reserved.
//

import Foundation

class SearchAPIManager: ApiManager {
    typealias ApiCallback = (Any?, Error?) -> Void
    class func getSearchedData(sessionId: String, searchTerm: String, callback: @escaping ApiCallback) {
        var request = URLRequest(url: URL(string: Constants.API.baseUrl + Constants.API.getSearchedData)!)
        request.httpMethod = "POST"
        var postString = "session_id=\(sessionId)&search_term=\(searchTerm)"
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
                    let details: SubCategoryProductResponse? = SubCategoryProductResponse(JSON: json)
                    callback(details, nil)
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
