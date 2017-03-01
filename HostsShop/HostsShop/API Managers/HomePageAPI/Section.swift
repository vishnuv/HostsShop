//
//  Section.swift
//  HostsShop
//
//  Created by Vishnu Vardhan PV on 29/12/16.
//  Copyright © 2016 vishnuvardhanpv. All rights reserved.
//

import Foundation
import ObjectMapper

class Section: NSObject, Mappable {
    var name: String?
    var sectionId: String?
    var sortOrder: String?

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        name <- map["name"]
        sectionId <- map["id"]
        sortOrder <- map["sort_order"]
    }
}
