//
//  LoginAPIManager.swift
//  HostsShop
//
//  Created by Vishnu Vardhan PV on 26/12/16.
//  Copyright © 2016 vishnuvardhanpv. All rights reserved.
//

import Foundation
import Alamofire

class LoginAPIManager: ApiManager {
    typealias ApiCallback = (String?, Error?) -> Void

    class func loginUser(callback: @escaping ApiCallback) {
//        var headers: HTTPHeaders = [:]
////                if let authorizationHeader = Request.authorizationHeader(user: userName, password: password) {
////                    headers[authorizationHeader.key] = authorizationHeader.value
////                }
//        headers["content-type"] = "multipart/form-data"
//
//        let url = Constants.API.baseUrl + Constants.API.loginUrl
//
//        var params:[String:Any] = [:]
//        params["username"] = Constants.API.loginUsername
//        params["password"] = Constants.API.loginPassword
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

///*******************************************

//        let URL: NSURL = NSURL(string: Constants.API.baseUrl + Constants.API.loginUrl)!
//        let request:NSMutableURLRequest = NSMutableURLRequest(url:URL as URL)
//        request.httpMethod = "POST"
////        request.HTTPBody = ??????
//
//        let bodyData = "username=vishnu&password=zaqxswcde@1987"
//        request.httpBody = bodyData.data(using: String.Encoding.utf8);
//            NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue.main)
//            {
//                (response, data, error) in
//                print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue))
//        }


        var request = URLRequest(url: URL(string: Constants.API.baseUrl + Constants.API.loginUrl)!)
        request.httpMethod = "POST"
        let postString = "username=vishnu&password=zaqxswcde@1987"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error)")
                callback(nil, error)
                return
            }

            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }

            let responseString = String(data: data, encoding: .utf8)
            let dict = self.convertToDictionary(text: responseString!)

            callback(dict?["sessionId"] as? String, nil)
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
