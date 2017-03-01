//
//  GetOrderMessageAPIManager.swift
//  HostsShop
//
//  Created by Vishnu Vardhan PV on 07/02/17.
//  Copyright © 2017 vishnuvardhanpv. All rights reserved.
//

import Foundation
import ObjectMapper

enum MessageType: String {
    case success = "Success"
    case failure = "Failure"
}

class GetOrderMessageAPIManager: ApiManager {
    typealias ApiCallback = ([String: String]?, Error?) -> Void

    class func getOrderMessage(messageType: MessageType, callback: @escaping ApiCallback) {
        var urlString = ""
        if messageType == .success {
            urlString = Constants.API.baseUrl + Constants.API.getOrderSuccessMessage
        } else {
            urlString = Constants.API.baseUrl + Constants.API.getOrderFailureMessage
        }
        var request = URLRequest(url: URL(string: urlString)!)
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
