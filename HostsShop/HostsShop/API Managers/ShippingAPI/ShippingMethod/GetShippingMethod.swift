//
//  GetShippingMethod.swift
//  HostsShop
//
//  Created by Vishnu Vardhan PV on 22/01/17.
//  Copyright © 2017 vishnuvardhanpv. All rights reserved.
//

import Foundation
import ObjectMapper

class GetShippingMethod: NSObject, Mappable {
    var price: String?
    var label: String?
    var code: String?
    var selected: Int?

    required init?(map: Map) {
        selected = 0
    }

    func mapping(map: Map) {
        price <- map["price"]
        label <- map["label"]
        code <- map["code"]
    }
}
