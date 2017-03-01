//
//  GetCityPincodesAPIResponse.swift
//  HostsShop
//
//  Created by Vishnu Vardhan PV on 16/02/17.
//  Copyright © 2017 vishnuvardhanpv. All rights reserved.
//

import Foundation
import ObjectMapper

class GetCityPincodesAPIResponse: NSObject, Mappable {
    var status: String?
    var type: String?
    var data: [Pincode]?

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        status <- map["status"]
        type <- map["type"]
        data <- map["data"]
    }
}
