//
//  GetOrderTotalAPIResponse.swift
//  HostsShop
//
//  Created by Vishnu Vardhan PV on 02/02/17.
//  Copyright © 2017 vishnuvardhanpv. All rights reserved.
//

import Foundation
import ObjectMapper

class GetOrderTotalAPIResponse: NSObject, Mappable {
    var status: String?
    var message: String?
    var data: OrderTotal?

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
        data <- map["data"]
    }
}
