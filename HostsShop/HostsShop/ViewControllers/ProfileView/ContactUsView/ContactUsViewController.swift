//
//  ContactUsViewController.swift
//  HostsShop
//
//  Created by Vishnu Vardhan PV on 09/02/17.
//  Copyright © 2017 vishnuvardhanpv. All rights reserved.
//

import UIKit

class ContactUsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        Util.customizeNavigationBarWithTitle(title: "Contact Us", rightButtons: [], rightButtonSelectors:[], leftButtons: [], leftButtonSelectors:[], forViewController: self)
    }
}
