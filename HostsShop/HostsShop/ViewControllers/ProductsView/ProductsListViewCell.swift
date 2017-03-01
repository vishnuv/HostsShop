//
//  ProductsListViewCell.swift
//  HostsShop
//
//  Created by Vishnu Vardhan PV on 07/01/17.
//  Copyright © 2017 vishnuvardhanpv. All rights reserved.
//

import Foundation

class ProductsListViewCell: UITableViewCell {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var shortDescriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    var productDetail: ProductDetail? {
        didSet {
            setData()
        }
    }

    func setData() {
        self.productImageView.af_setImage(withURL: URL(string:(productDetail?.image)!)!)
        self.nameLabel.text = (productDetail?.name)!
        self.shortDescriptionLabel.text = (productDetail?.shortDescription)!
        self.priceLabel.text = (productDetail?.finalPrice)! + "(" + (productDetail?.price)! + ")"
    }

    @IBAction func tappedWishListButton() {
        print("tappedWishListButton")
    }

    @IBAction func tappedAddToCartButton() {
        print("tappedAddToCartButton")
    }
}
