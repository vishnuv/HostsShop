//
//  FinalCheckoutAddressCell.swift
//  HostsShop
//
//  Created by Vishnu Vardhan PV on 02/02/17.
//  Copyright © 2017 vishnuvardhanpv. All rights reserved.
//

import Foundation
import UIKit
import AlamofireImage

typealias ChangeAddressAction = () -> ()

class FinalCheckoutAddressCell: UITableViewCell {

    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!

    var changeAddressAction: ChangeAddressAction?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func tappedChangeAddressButton() {
        self.changeAddressAction!()
    }
}
