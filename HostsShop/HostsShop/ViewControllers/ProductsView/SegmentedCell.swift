//
//  SegmentedCell.swift
//  HostsShop
//
//  Created by Vishnu Vardhan PV on 10/01/17.
//  Copyright © 2017 vishnuvardhanpv. All rights reserved.
//

import Foundation

class SegmentedCell: UITableViewCell {
    @IBOutlet var segmentedHeight: NSLayoutConstraint?
    @IBOutlet var segmentedControl: UISegmentedControl?

    override func awakeFromNib() {
        super.awakeFromNib()
        segmentedHeight?.constant = 50.0
        stylizeFonts()

    }

    func stylizeFonts(){
//        let normalFont = UIFont(name: "Helvetica", size: 16.0)
        let boldFont = UIFont(name: "Helvetica-Bold", size: 16.0)

        let normalTextAttributes: [NSObject : AnyObject] = [
            NSForegroundColorAttributeName as NSObject: UIColor.orange,
            NSFontAttributeName as NSObject: boldFont!
        ]

//        let boldTextAttributes: [NSObject : AnyObject] = [
//            NSForegroundColorAttributeName : UIColor.whiteColor(),
//            NSFontAttributeName : boldFont!,
//            ]

        segmentedControl?.setTitleTextAttributes(normalTextAttributes, for: .normal)
        segmentedControl?.setTitleTextAttributes(normalTextAttributes, for: .highlighted)
        segmentedControl?.setTitleTextAttributes(normalTextAttributes, for: .selected)
    }
}
