//
//  ProductsCollectionViewCell.swift
//  HostsShop
//
//  Created by Vishnu Vardhan PV on 04/01/17.
//  Copyright © 2017 vishnuvardhanpv. All rights reserved.
//

import Foundation
import UIKit
import AlamofireImage

typealias AddToCartCallBack = (String) -> ()
typealias AddToWishlistCallBack = (String) -> ()

class ProductsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var shortDescriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    var addToCartCallBack: AddToCartCallBack?
    var addToWishlistCallBack: AddToWishlistCallBack?

    var productDetail: ProductDetail? {
        didSet {
            setData()
        }
    }

    func setData() {
        self.imageView .af_setImage(withURL: URL(string:(productDetail?.image)!)!)
        self.nameLabel.text = (productDetail?.name)!
        self.shortDescriptionLabel.text = (productDetail?.shortDescription)!
        self.priceLabel.text = (productDetail?.finalPrice)! + "(" + (productDetail?.price)! + ")"
    }

    @IBAction func tappedWishListButton() {
        print("tappedWishListButton")
        self.addToWishlistCallBack!((self.productDetail?.productId)!)
    }

    @IBAction func tappedAddToCartButton() {
        print("tappedAddToCartButton")
        self.addToCartCallBack!((self.productDetail?.productId)!)
    }
}
