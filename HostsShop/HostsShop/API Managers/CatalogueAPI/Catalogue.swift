//
//  Catalogue.swift
//  HostsShop
//
//  Created by Vishnu Vardhan PV on 02/01/17.
//  Copyright © 2017 vishnuvardhanpv. All rights reserved.
//

import Foundation
import ObjectMapper

class Catalogue: NSObject, Mappable {
    var image: String?
    var url: String?
    var catalogueId: String?
    var name: String?
    var parentId: String?
    var position: String?

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        image <- map["image"]
        url <- map["url"]
        catalogueId <- map["id"]
        name <- map["name"]
        parentId <- map["parent_id"]
        position <- map["position"]
    }
}
