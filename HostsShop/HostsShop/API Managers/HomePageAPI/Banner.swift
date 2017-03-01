//
//  MainBanner.swift
//  HostsShop
//
//  Created by Vishnu Vardhan PV on 29/12/16.
//  Copyright © 2016 vishnuvardhanpv. All rights reserved.
//

import Foundation
import ObjectMapper

class Banner: NSObject, Mappable {
    var image: String?
    var url: String?
    var title: String?

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        image <- map["image"]
        url <- map["url"]
        title <- map["title"]
    }
}
