//
//  OrderDetailAPIResponse.swift
//  HostsShop
//
//  Created by Vishnu Vardhan PV on 11/02/17.
//  Copyright © 2017 vishnuvardhanpv. All rights reserved.
//

import Foundation
import ObjectMapper

class OrderDetailAPIResponse: NSObject, Mappable {
    var status: String?
    var message: String?
    var data: OrderDetail?

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
        data <- map["data"]
    }
}
