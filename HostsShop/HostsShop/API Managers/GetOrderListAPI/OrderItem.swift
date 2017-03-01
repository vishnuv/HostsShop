//
//  OrderItem.swift
//  HostsShop
//
//  Created by Vishnu Vardhan PV on 13/02/17.
//  Copyright © 2017 vishnuvardhanpv. All rights reserved.
//

import Foundation

import ObjectMapper

class OrderItem: NSObject, Mappable {
    var productId: String?
    var itemId: String?
    var name: String?
    var price: String?
    var finalPrice: String?
    var image: String?
    var quantity: String?
    var discountAmount: String?
    var taxAmount: String?
    var rowTotal: String?

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        productId <- map["product_id"]
        itemId <- map["item_id"]
        price <- map["price"]
        name <- map["name"]
        finalPrice <- map["final_price"]
        image <- map["image"]
        quantity <- map["ordered_qty"]
        discountAmount <- map["discount_amount"]
        taxAmount <- map["tax_amount"]
        rowTotal <- map["row_total"]
    }
}
