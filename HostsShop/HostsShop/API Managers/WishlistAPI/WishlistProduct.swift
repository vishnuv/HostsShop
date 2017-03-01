//
//  WishlistProduct.swift
//  HostsShop
//
//  Created by Vishnu Vardhan PV on 15/01/17.
//  Copyright © 2017 vishnuvardhanpv. All rights reserved.
//

import Foundation
import ObjectMapper

class WishlistProduct: NSObject, Mappable {
    var wishlistId: String?
    var productId: String?
    var name: String?
    var price: String?
    var finalPrice: String?
    var image: String?

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        wishlistId <- map["wishlist_id"]
        productId <- map["product_id"]
        price <- map["price"]
        name <- map["name"]
        finalPrice <- map["final_price"]
        image <- map["image"]
    }
}
