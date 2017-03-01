//
//  OrderDetail.swift
//  HostsShop
//
//  Created by Vishnu Vardhan PV on 11/02/17.
//  Copyright © 2017 vishnuvardhanpv. All rights reserved.
//

import Foundation
import ObjectMapper

class OrderDetail: NSObject, Mappable {
    var orderItems: [OrderItem]?
    var subTotal: String?
    var shippingAmount: String?
    var grandTotal: String?
    var shippingAddress: String?

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        orderItems <- map["order_items"]
        subTotal <- map["subtotal"]
        shippingAmount <- map["shipping_amount"]
        grandTotal <- map["grand_total"]
        shippingAddress <- map["shipping_address"]
    }
}
