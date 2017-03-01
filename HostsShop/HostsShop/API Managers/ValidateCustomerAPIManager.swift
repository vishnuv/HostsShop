//
//  ValidateCustomerAPIManager.swift
//  HostsShop
//
//  Created by Vishnu Vardhan PV on 26/12/16.
//  Copyright © 2016 vishnuvardhanpv. All rights reserved.
//

import Foundation
import Alamofire

class ValidateCustomerAPIManager: ApiManager {
    typealias ApiCallback = ([String:String]?, Error?) -> Void

    class func validateCustomer(email: String, password: String, session: String, callback: @escaping ApiCallback) {
//        var headers: HTTPHeaders = [:]
//        //        if let authorizationHeader = Request.authorizationHeader(user: userName, password: password) {
//        //            headers[authorizationHeader.key] = authorizationHeader.value
//        //        }
//
//        let url = Constants.API.baseUrl + Constants.API.validateCustomerUrl
//
//        var params:[String:Any] = [:]
//        params["username"] = email
//        params["password"] = password
//        params["session_id"] = password
//
//        executeRequest(url, method:.post, parameters:params, headers: headers) { (response, error) in
//            if let error = error {
//                callback(nil, error)
//            } else {
//                if let json = response?.result.value as? [String: Any] {
//                    //                    let issues: GetAllIssuesResponse? = GetAllIssuesResponse(JSON: json)
//                    //                    debugPrint(issues?.issues?[0] as Any)
//                    callback("", nil)
//                }
//            }
//        }

        var request = URLRequest(url: URL(string: Constants.API.baseUrl + Constants.API.validateCustomerUrl)!)
        request.httpMethod = "POST"
        let postString = "email_id=\(email)&password=\(password)&session_id=\(session)"
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
            callback(dict! as? [String: String], nil)
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
