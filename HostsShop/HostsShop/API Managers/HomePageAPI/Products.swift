//
//  Products.swift
//  HostsShop
//
//  Created by Vishnu Vardhan PV on 29/12/16.
//  Copyright © 2016 vishnuvardhanpv. All rights reserved.
//

import Foundation
import ObjectMapper

class Products: NSObject, Mappable {
    var products: [ProductDetail]?
    var section: Section?

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        section <- map["section"]
        products <- map["products"]
    }
}
