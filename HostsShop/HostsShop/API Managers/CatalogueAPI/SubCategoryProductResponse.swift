//
//  SubCategoryProductResponse.swift
//  HostsShop
//
//  Created by Vishnu Vardhan PV on 06/01/17.
//  Copyright © 2017 vishnuvardhanpv. All rights reserved.
//

import Foundation
import ObjectMapper

class SubCategoryProductResponse: Mappable {
    var status: String?
    var message: String?
    var totalPages: String?
    var productCount: String?
    var data:[ProductDetail]?
    var model: String?
    var sortingOptions: [SortingOption]?

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
        totalPages <- map["total_pages"]
        productCount <- map["product_count"]
        data <- map["data"]
        model <- map["model"]
        sortingOptions <- map["sorting_options"]
    }
}
