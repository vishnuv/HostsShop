//
//  TopCategoriesCollectionViewCell.swift
//  HostsShop
//
//  Created by Vishnu Vardhan PV on 03/01/17.
//  Copyright © 2017 vishnuvardhanpv. All rights reserved.
//

import Foundation
import UIKit
import AlamofireImage

class TopCategoriesCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!

    var category: Category? {
        didSet {
            setData()
        }
    }

    func setData() {
        self.imageView .af_setImage(withURL: URL(string:(category?.image)!)!)
        self.label.text = (category?.title)!
    }
}
