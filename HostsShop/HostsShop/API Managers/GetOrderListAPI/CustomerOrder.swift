//
//  CustomerOrder.swift
//  HostsShop
//
//  Created by Vishnu Vardhan PV on 10/02/17.
//  Copyright © 2017 vishnuvardhanpv. All rights reserved.
//

import Foundation
import ObjectMapper

class CustomerOrder: NSObject, Mappable {
    var status: String?
    var incrementId: String?
    var grandTotal: String?
    var orderDate: String?

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        status <- map["status"]
        incrementId <- map["increment_id"]
        grandTotal <- map["grand_total"]
        orderDate <- map["order_date"]
    }
}
