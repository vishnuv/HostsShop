//
//  WishlistCustomCell.swift
//  HostsShop
//
//  Created by Vishnu Vardhan PV on 15/01/17.
//  Copyright © 2017 vishnuvardhanpv. All rights reserved.
//

import Foundation
import UIKit
import AlamofireImage

typealias AddToCartAction = (WishlistProduct) -> ()
typealias DeleteAction = (WishlistProduct) -> ()

class WishlistCustomCell: UITableViewCell {

    var addToCartAction: AddToCartAction?
    var deleteAction: DeleteAction?
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView?

    var wishlistProduct:WishlistProduct? {
        didSet {
            self.nameLabel.text = wishlistProduct?.name
            self.priceLabel.text = wishlistProduct?.price
            self.productImageView?.af_setImage(withURL: URL(string:(wishlistProduct?.image)!)!)
        }
    }

    @IBAction func tappedAddToCart() {
        self.addToCartAction!(self.wishlistProduct!)
    }

    @IBAction func tappedDelete() {
        self.deleteAction!(self.wishlistProduct!)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
