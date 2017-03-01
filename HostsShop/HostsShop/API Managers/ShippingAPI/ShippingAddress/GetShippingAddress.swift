//
//  GetShippingAddress.swift
//  HostsShop
//
//  Created by Vishnu Vardhan PV on 21/01/17.
//  Copyright © 2017 vishnuvardhanpv. All rights reserved.
//

import Foundation
import ObjectMapper

class GetShippingAddress: NSObject, Mappable {
    var value: String?
    var label: String?
    var selected: Int

    required init?(map: Map) {
        selected = 0
    }

    func mapping(map: Map) {
        value <- map["value"]
        label <- map["label"]
    }
}
