//
//  PaymentMethod.swift
//  HostsShop
//
//  Created by Vishnu Vardhan PV on 23/01/17.
//  Copyright © 2017 vishnuvardhanpv. All rights reserved.
//

import Foundation
import ObjectMapper

class PaymentMethod: NSObject, Mappable {
    var code: String?
    var title: String?
    var selected: Int?

    required init?(map: Map) {
        selected = 0
    }

    func mapping(map: Map) {
        code <- map["code"]
        title <- map["title"]
    }
}
