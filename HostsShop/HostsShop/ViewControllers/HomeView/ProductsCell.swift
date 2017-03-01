//
//  ProductsCell.swift
//  HostsShop
//
//  Created by Vishnu Vardhan PV on 04/01/17.
//  Copyright © 2017 vishnuvardhanpv. All rights reserved.
//

import Foundation
import UIKit

class ProductsCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!

    var products:Products? {
        didSet {
            titleLabel.text = products?.section?.name
            collectionView.reloadData()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension ProductsCell : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let product = products, (products?.products?.count)! > 0 {
            return (product.products?.count)!
        } else {
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"ProductsCollectionViewCell", for: indexPath) as! ProductsCollectionViewCell
        cell.productDetail = products?.products?[indexPath.row]
        return cell
    }
}
