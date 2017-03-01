//
//  City.swift
//  HostsShop
//
//  Created by Vishnu Vardhan PV on 16/02/17.
//  Copyright © 2017 vishnuvardhanpv. All rights reserved.
//

import Foundation
import ObjectMapper

class City: NSObject, Mappable {
    var cityId: String?
    var name: String?

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        cityId <- map["city_id"]
        name <- map["name"]
    }
}
