//
//  OrderCustomCell.swift
//  HostsShop
//
//  Created by Vishnu Vardhan PV on 10/02/17.
//  Copyright © 2017 vishnuvardhanpv. All rights reserved.
//

import Foundation

class OrderCustomCell: UITableViewCell {

    @IBOutlet weak var orderIdLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var orderDateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
