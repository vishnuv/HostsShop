//
//  Category.swift
//  HostsShop
//
//  Created by Vishnu Vardhan PV on 29/12/16.
//  Copyright © 2016 vishnuvardhanpv. All rights reserved.
//

import Foundation
import ObjectMapper

class Category: NSObject, Mappable {
    var title: String?
    var image: String?
    var categoryId: String?

//    required init?(map: Map) {
//    }

    override init() {
        super.init()
    }

    convenience required init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        title <- map["title"]
        image <- map["image"]
        categoryId <- map["category_id"]
    }
}
