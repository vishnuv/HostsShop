//
//  CatalogueDataResponse.swift
//  HostsShop
//
//  Created by Vishnu Vardhan PV on 02/01/17.
//  Copyright © 2017 vishnuvardhanpv. All rights reserved.
//

import Foundation
import ObjectMapper

class CatalogueDataResponse: Mappable {
    var status: String?
    var message: String?
    var data: [Catalogue]?
    var model: String?

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
        data <- map["data"]
        model <- map["model"]
    }
}
