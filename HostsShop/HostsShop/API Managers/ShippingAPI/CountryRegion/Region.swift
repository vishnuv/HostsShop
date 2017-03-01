//
//  Region.swift
//  HostsShop
//
//  Created by Vishnu Vardhan PV on 24/01/17.
//  Copyright © 2017 vishnuvardhanpv. All rights reserved.
//

import Foundation
import ObjectMapper

class Region: NSObject, Mappable {
    var regionId: String?
    var countryId: String?
    var code: String?
    var name: String?
    var defaultName: String?

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        regionId <- map["region_id"]
        countryId <- map["country_id"]
        code <- map["code"]
        name <- map["name"]
        defaultName <- map["default_name"]
    }
}
