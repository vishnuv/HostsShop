//
//  OrderTotal.swift
//  HostsShop
//
//  Created by Vishnu Vardhan PV on 02/02/17.
//  Copyright © 2017 vishnuvardhanpv. All rights reserved.
//

import Foundation
import ObjectMapper

class OrderTotal: NSObject, Mappable {
    var sessionId: String?
    var emailId: String?
    var subTotal: String?
    var shippingCost: String?
    var grandTotal: String?
    var payableGrandTotal: String?
    var currecyCode: String?
    var itemsQuantity: Int?
    var itemsCount: String?

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        sessionId <- map["session_id"]
        emailId <- map["email_id"]
        subTotal <- map["subtotal"]
        shippingCost <- map["shippingCost"]
        grandTotal <- map["grand_total"]
        payableGrandTotal <- map["payable_grand_total"]
        currecyCode <- map["currency_code"]
        itemsQuantity <- map["items_qty"]
        itemsCount <- map["items_count"]
    }
}
