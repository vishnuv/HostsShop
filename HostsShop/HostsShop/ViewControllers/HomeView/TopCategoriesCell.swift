//
//  TopCategoriesCell.swift
//  HostsShop
//
//  Created by Vishnu Vardhan PV on 03/01/17.
//  Copyright © 2017 vishnuvardhanpv. All rights reserved.
//

import Foundation
import UIKit 

typealias CategoriesCallBack = (Category) -> ()

class TopCategoriesCell: UITableViewCell {

    var categoriesCallBack: CategoriesCallBack?
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var moreCategoriesButton: UIButton!

    var topCategories:[Category]? {
        didSet {
            collectionView.reloadData()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension TopCategoriesCell : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let cat = topCategories, (topCategories?.count)! > 0 {
            return cat.count
        } else {
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"TopCategoriesCollectionViewCell", for: indexPath) as! TopCategoriesCollectionViewCell
        cell.category = topCategories?[indexPath.row]
        return cell
    }
}

extension TopCategoriesCell : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category: Category = (topCategories?[indexPath.row])!
        print(category.title!)
        categoriesCallBack!(category)
    }
}
