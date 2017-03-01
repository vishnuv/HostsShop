//
//  CatalogueDataAPIManager.swift
//  HostsShop
//
//  Created by Vishnu Vardhan PV on 02/01/17.
//  Copyright © 2017 vishnuvardhanpv. All rights reserved.
//

import Foundation

enum SortBy: String {
    case asc = "asc", dsc = "dsc"
}

class CatalogueDataAPIManager: ApiManager {
    typealias ApiCallback = (Any?, Error?) -> Void
    class func getCatalogueData(sessionId: String, categoryId: String? = nil, sortBy: SortBy? = nil, sortOption: String? = nil, callback: @escaping ApiCallback) {
        var request = URLRequest(url: URL(string: Constants.API.baseUrl + Constants.API.getCatalogueData)!)
        request.httpMethod = "POST"
        var postString = "session_id=\(sessionId)"
        if let cat = categoryId {
            postString += "&category_id=\(cat)"
        }
        if let sort = sortBy {
            postString += "&sorting_order=\(sort)"
        }
        if let option = sortOption {
            postString += "&sort_by=\(option)"
        }
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
                    if let _ = categoryId, json["model"]! as! String == "Product" {
                        print(json["model"]!)
                        let details: SubCategoryProductResponse? = SubCategoryProductResponse(JSON: json)
                        callback(details, nil)
                    } else {
                        let details: CatalogueDataResponse? = CatalogueDataResponse(JSON: json)
                        callback(details, nil)
                    }
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
