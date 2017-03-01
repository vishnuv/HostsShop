//
//  SortingOption.swift
//  HostsShop
//
//  Created by Vishnu Vardhan PV on 08/01/17.
//  Copyright © 2017 vishnuvardhanpv. All rights reserved.
//

import Foundation
import ObjectMapper

class SortingOption: NSObject, Mappable {
    var value: String?
    var label: String?

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        value <- map["value"]
        label <- map["label"]
    }
}
