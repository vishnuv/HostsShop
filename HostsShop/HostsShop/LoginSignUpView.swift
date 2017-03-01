//
//  LoginSignUpView.swift
//  HostsShop
//
//  Created by Vishnu Vardhan PV on 24/12/16.
//  Copyright © 2016 vishnuvardhanpv. All rights reserved.
//

import Foundation
import UIKit

class LoginSignUpView: UIViewController {

    @IBOutlet var loginButton: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton?.layer.borderColor = UIColor.white.cgColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
}
