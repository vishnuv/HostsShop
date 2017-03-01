//
//  TopCategories.swift
//  HostsShop
//
//  Created by Vishnu Vardhan PV on 29/12/16.
//  Copyright © 2016 vishnuvardhanpv. All rights reserved.
//

import Foundation
import ObjectMapper

class TopCategories: NSObject, Mappable {
    var topCategories: [Category]?
    var section: Section?

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        section <- map["section"]
        topCategories <- map["top_categories"]
    }
}
