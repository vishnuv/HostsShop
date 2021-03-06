//
//  OptionDataValue.swift
//  HostsShop
//
//  Created by Vishnu Vardhan PV on 16/01/17.
//  Copyright © 2017 vishnuvardhanpv. All rights reserved.
//

import Foundation
import ObjectMapper

class OptionDataValue: NSObject, Mappable {
    var optionTypeId: String?
    var title: String?

    //    var entityTypeId: String?
    //    var attributeSetId: String?
    //    var typeId: String?
    //    var sku: String?
    //    var has_options: String?
    //    var shortDescription: String?
    //    var quantity: Int?
    //    var discountAmount: String?
    //    var taxAmount: String?
    //    var rowTotal: String?

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        optionTypeId <- map["option_type_id"]
        title <- map["title"]
        //        entityTypeId <- map["entity_type_id"]
        //        attributeSetId <- map["attribute_set_id"]
        //        typeId <- map["type_id"]
        //        sku <- map["sku"]
        //        hasOptions <- map["has_options"]
        //        quantity <- map["qty"]
        //        discountAmount <- map["discount_amount"]
        //        taxAmount <- map["tax_amount"]
        //        rowTotal <- map["row_total"]
        //        shortDescription <- map["short_description"]
    }
}
