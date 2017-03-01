//
//  ForgotPasswordViewController.swift
//  HostsShop
//
//  Created by Vishnu Vardhan PV on 28/12/16.
//  Copyright © 2016 vishnuvardhanpv. All rights reserved.
//

import Foundation
import UIKit
import KRProgressHUD

class ForgotPasswordViewController: UIViewController {

    @IBOutlet var emailField: UITextField?

    override func viewDidLoad() {
        super.viewDidLoad()
        emailField?.layer.borderColor = UIColor.orange.cgColor
    }

    @IBAction func tappedResetPasswordButton() {
        print("tapped \(emailField?.text)")
        if !isValidEmail(testStr: (emailField?.text)!) {
            print("invalid email")
        } else {
            print("call API")
            callLoginAPI()
        }
    }

    @IBAction func tappedCancelButton() {
        _ = self.navigationController?.popViewController(animated: true)
    }

    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }

    func showHUD() {
        KRProgressHUD.set(style:.black)
        KRProgressHUD.show()
    }

    func hideHUD() {
        KRProgressHUD.dismiss()
    }

    func callLoginAPI() {
        showHUD()
        LoginAPIManager.loginUser() { (response, error) in
            print("AHSJSHDKAHDKJAHSDKAHSDKHASDKJHS***********")
            print("session id \(response)")
            AppDelegate.application().sessionId = response
            self.callResetPasswordAPI()
        }
    }

    func callResetPasswordAPI() {
        ForgotPasswordAPIManager.forgotPassword(email: (emailField?.text)!, sessionId: AppDelegate.application().sessionId!) { (response, error) in
            if let dict = response {
                Util.showAlertWithTitle(title: dict["status"]!, message: dict["message"]!, forViewController: self, okButtonAction: {
                })
            }
            self.hideHUD()
        }
    }
}
