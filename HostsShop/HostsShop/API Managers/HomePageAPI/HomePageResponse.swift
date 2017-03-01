//
//  HomePageResponse.swift
//  HostsShop
//
//  Created by Vishnu Vardhan PV on 29/12/16.
//  Copyright © 2016 vishnuvardhanpv. All rights reserved.
//

import Foundation
import ObjectMapper

class HomePageResponse: Mappable {
    var status: String?
    var message: String?
    var model: String?
    var mainBanner: [Banner]?
    var topCategories: TopCategories?
    var moreCategories: Category?
    var staticBanner: [Banner]?
    var products: [Products]?
    var flashMessage: [Banner]?

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
        model <- map["model"]
        mainBanner <- map["main_banner"]
        topCategories <- map["top_categories"]
        moreCategories <- map["more_categories"]
        staticBanner <- map["static_banner"]
        products <- map["products"]
        flashMessage <- map["flash_message"]
    }
}
