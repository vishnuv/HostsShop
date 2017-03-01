//
//  FinalCheckoutViewCustomCell.swift
//  HostsShop
//
//  Created by Vishnu Vardhan PV on 02/02/17.
//  Copyright © 2017 vishnuvardhanpv. All rights reserved.
//

import Foundation
import UIKit
import AlamofireImage

class FinalCheckoutViewCustomCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var shortDescriptionLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView?

    var cartlistProduct:CartlistProduct? {
        didSet {
            self.nameLabel.text = cartlistProduct?.name
            self.priceLabel.text = cartlistProduct?.price
            self.shortDescriptionLabel.text = cartlistProduct?.shortDescription
            self.quantityLabel.text = String(describing: (cartlistProduct?.quantity)!)
            self.totalLabel.text = cartlistProduct?.rowTotal
            self.productImageView?.af_setImage(withURL: URL(string:(cartlistProduct?.image)!)!)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
