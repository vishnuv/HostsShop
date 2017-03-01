//
//  Pincode.swift
//  HostsShop
//
//  Created by Vishnu Vardhan PV on 16/02/17.
//  Copyright © 2017 vishnuvardhanpv. All rights reserved.
//

import Foundation
import ObjectMapper

class Pincode: NSObject, Mappable {
    var zipcode: String?

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        zipcode <- map["zipcode"]
    }
}
