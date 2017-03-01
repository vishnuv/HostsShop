//
//  GetProductDataAPIResponse.swift
//  HostsShop
//
//  Created by Vishnu Vardhan PV on 16/01/17.
//  Copyright © 2017 vishnuvardhanpv. All rights reserved.
//

import Foundation
import ObjectMapper

class GetProductDataAPIResponse: NSObject, Mappable {
    var status: String?
    var message: String?
    var model: String?
    var data: ProductData?

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
        data <- map["data"]
        model <- map["model"]
    }
}
