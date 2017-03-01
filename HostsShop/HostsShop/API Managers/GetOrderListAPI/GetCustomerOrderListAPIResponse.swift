//
//  GetCustomerOrderListAPIResponse.swift
//  HostsShop
//
//  Created by Vishnu Vardhan PV on 10/02/17.
//  Copyright © 2017 vishnuvardhanpv. All rights reserved.
//

import Foundation
import ObjectMapper

class GetCustomerOrderListAPIResponse: NSObject, Mappable {
    var status: String?
    var message: String?
    var data: [CustomerOrder]?

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
        data <- map["data"]
    }
}
