//
//  ProductDetail.swift
//  HostsShop
//
//  Created by Vishnu Vardhan PV on 29/12/16.
//  Copyright © 2016 vishnuvardhanpv. All rights reserved.
//

import Foundation
import ObjectMapper

class ProductDetail: NSObject, Mappable {
    var productId: String?
    var name: String?
    var shortDescription: String?
    var url: String?
    var sku: String?
    var price: String?
    var finalPrice: String?
    var image: String?
    var hasOptions: String?

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        productId <- map["id"]
        name <- map["name"]
        shortDescription <- map["short_description"]
        url <- map["url"]
        sku <- map["sku"]
        price <- map["price"]
        finalPrice <- map["final_price"]
        image <- map["image"]
        hasOptions <- map["has_options"]
    }
}
