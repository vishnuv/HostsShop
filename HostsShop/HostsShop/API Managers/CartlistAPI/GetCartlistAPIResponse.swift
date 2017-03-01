//
//  GetCartlistAPIResponse.swift
//  HostsShop
//
//  Created by Vishnu Vardhan PV on 15/01/17.
//  Copyright © 2017 vishnuvardhanpv. All rights reserved.
//

import Foundation
import ObjectMapper

class GetCartlistAPIResponse: NSObject, Mappable {
    var status: String?
    var message: String?
    var cartTotal: String?
    var cartTotalWithoutSymbol: String?
    var data: [CartlistProduct]?

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
        data <- map["data"]
        cartTotal <- map["cart_total"]
        cartTotalWithoutSymbol <- map["cart_total_wtsymbol"]
    }
}
