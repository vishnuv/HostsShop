//
//  ProductData.swift
//  HostsShop
//
//  Created by Vishnu Vardhan PV on 16/01/17.
//  Copyright © 2017 vishnuvardhanpv. All rights reserved.
//

import Foundation
import ObjectMapper

class ProductData: NSObject, Mappable {
    var entityId: String?
    var entityTypeId: String?
    var attributeSetId: String?
    var typeId: String?
    var sku: String?
    var hasOptions: String?
    var optionData: [OptionData]?

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        entityId <- map["entity_id"]
        entityTypeId <- map["entity_type_id"]
        attributeSetId <- map["attribute_set_id"]
        typeId <- map["type_id"]
        sku <- map["sku"]
        hasOptions <- map["has_options"]
        optionData <- map["optiondata"]
    }
}
