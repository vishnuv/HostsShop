//
//  CartListCustomCell.swift
//  HostsShop
//
//  Created by Vishnu Vardhan PV on 15/01/17.
//  Copyright © 2017 vishnuvardhanpv. All rights reserved.
//

import Foundation
import UIKit
import AlamofireImage

typealias MoveToWishlistAction = (CartlistProduct) -> ()
typealias RemoveAction = (CartlistProduct) -> ()

class CartListCustomCell: UITableViewCell {

    var moveToWishlistAction: MoveToWishlistAction?
    var removeAction: RemoveAction?
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
            print(cartlistProduct?.quantity)
            self.quantityLabel.text = String(describing: (cartlistProduct?.quantity)!)
            self.totalLabel.text = cartlistProduct?.rowTotal
            self.productImageView?.af_setImage(withURL: URL(string:(cartlistProduct?.image)!)!)
        }
    }

    @IBAction func tappedMoveToWishlist() {
        self.moveToWishlistAction!(self.cartlistProduct!)
    }

    @IBAction func tappedRemove() {
        self.removeAction!(self.cartlistProduct!)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
