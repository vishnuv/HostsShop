//
//  GetHomePageAPIManager.swift
//  HostsShop
//
//  Created by Vishnu Vardhan PV on 28/12/16.
//  Copyright © 2016 vishnuvardhanpv. All rights reserved.
//

import Foundation
import Alamofire

class GetHomePageAPIManager: ApiManager {
    typealias ApiCallback = (HomePageResponse?, Error?) -> Void

    class func getHomePage(sessionId: String, callback: @escaping ApiCallback) {
        var request = URLRequest(url: URL(string: Constants.API.baseUrl + Constants.API.getHomepageUrl)!)
        request.httpMethod = "POST"
        let postString = "session_id=\(sessionId)"
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

//            if let data = dict {
//                callback(data as? [String: Any], nil)
//            }

            if let error = error {
                callback(nil, error)
            } else {
                if let json = dict as [String: Any]? {
                    let details: HomePageResponse? = HomePageResponse(JSON: json)
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
