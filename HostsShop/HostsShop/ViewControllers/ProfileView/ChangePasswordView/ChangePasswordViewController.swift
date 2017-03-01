//
//  ChangePasswordViewController.swift
//  HostsShop
//
//  Created by Vishnu Vardhan PV on 09/02/17.
//  Copyright © 2017 vishnuvardhanpv. All rights reserved.
//

import UIKit

class ChangePasswordViewController: BaseViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ChangePasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}

extension ChangePasswordViewController {
    @IBAction func tappedChangePwdButton() {
        if (emailField.text?.isEmpty)! {
            print("invalid email")
        } else if (passwordField.text?.isEmpty)! {
            print("invalid password")
        } else if emailField.text != passwordField.text {
            print("passwords do not match")
        } else {
            callLoginAPI()
        }
    }

    func callChangePwdAPI() {
        ChangePasswordAPIManager.changePassword(password: passwordField.text!, email: "vishnuvardhanpv@gmail.com", sessionId: AppDelegate.application().sessionId!) { (response, error) in
            self.hideHUD()
            Util.showAlertWithTitle(title: (response?["status"])!, message: (response?["message"])!, forViewController: self, okButtonAction: {
            })
        }
    }

    func callLoginAPI() {
        showHUD()
        LoginAPIManager.loginUser() { (response, error) in
            print("AHSJSHDKAHDKJAHSDKAHSDKHASDKJHS***********")
            print("session id \(response)")
            AppDelegate.application().sessionId = response
            self.callChangePwdAPI()
        }
    }
}
