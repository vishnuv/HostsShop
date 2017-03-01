//
//  ProductDetailLargeImageCell.swift
//  HostsShop
//
//  Created by Vishnu Vardhan PV on 10/01/17.
//  Copyright © 2017 vishnuvardhanpv. All rights reserved.
//

import Foundation

class ProductDetailsCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var shortDescriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var availabilityLabel: UILabel!

    var productDetail: ProductDetail? {
        didSet {
            self.nameLabel.text = productDetail?.name
            self.priceLabel.text = productDetail?.price
            self.shortDescriptionLabel.text = productDetail?.shortDescription
            self.availabilityLabel.text = "Availability: In stock"
        }
    }
}
