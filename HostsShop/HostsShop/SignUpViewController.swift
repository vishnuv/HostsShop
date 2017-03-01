//
//  SignUpViewController.swift
//  HostsShop
//
//  Created by Vishnu Vardhan PV on 25/12/16.
//  Copyright © 2016 vishnuvardhanpv. All rights reserved.
//

import Foundation
import UIKit
import KRProgressHUD
import FBSDKLoginKit

class SignUpViewController: UIViewController, GIDSignInUIDelegate {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        let borderColor = UIColor.init(colorLiteralRed: 128.0/255.0, green: 142.0/255.0, blue: 59.0/255.0, alpha: 1)
        emailField.layer.borderColor = borderColor.cgColor
        passwordField.layer.borderColor = borderColor.cgColor
        confirmPasswordField.layer.borderColor = borderColor.cgColor

        GIDSignIn.sharedInstance().uiDelegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(callLoginAPIAfterGoogleLogin), name: .callLoginAPI, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
}

extension SignUpViewController {
    @IBAction func tappedSignUpButton() {
        if !isValidEmail(testStr: emailField.text!) {
            print("invalid email")
        } else if (passwordField.text?.isEmpty)! {
            print("invalid password")
        } else if passwordField.text != confirmPasswordField.text {
            print("password not match")
        } else {
            print("call API")
            callLoginAPI(isSocialLogin: false)
        }
    }

    func callLoginAPI(isSocialLogin: Bool) {
        showHUD()
        LoginAPIManager.loginUser() { (response, error) in
            print("AHSJSHDKAHDKJAHSDKAHSDKHASDKJHS***********")
            print("session id \(response)")
            AppDelegate.application().sessionId = response
            self.callRegisterAPI(isSocialLogin: isSocialLogin)
        }
    }

    func callLoginAPIAfterGoogleLogin() {
        callLoginAPI(isSocialLogin: true)
    }

    func callRegisterAPI(isSocialLogin: Bool) {
        var email: String
        var password: String
        var type: Int
        if isSocialLogin {
            email = Util.getEmail()!
            password = "qwert"
            type = 1
        } else {
            email = emailField.text!
            password = passwordField.text!
            type = 0
        }
        RegisterAPIManager.registerUser(email: email, password: password, type: type, sessionId: AppDelegate.application().sessionId!) { (response, error) in
            if let data = response {
                var dict: [String: String] = data
                if type == 1 {
                    if dict["status"]! == "success" || dict["status"]! == "registered" {
                        print("navigate to home")
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "LocationFromSignUpSegue", sender: nil)
                        }
                    } else {
                        Util.showAlertWithTitle(title: dict["status"]!, message: dict["message"]!, forViewController: self, okButtonAction: {
                        })
                    }
                } else {
                    Util.showAlertWithTitle(title: dict["status"]!, message: dict["message"]!, forViewController: self, okButtonAction: {
                        _ = self.navigationController?.popViewController(animated: true)
                    })
                }
            }
            self.hideHUD()
        }
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

    @IBAction func tappedFBLoginButton() {
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) -> Void in
            if (error == nil){
                if let fbloginresult : FBSDKLoginManagerLoginResult = result {
                    if(fbloginresult.grantedPermissions.contains("email")) {
                        self.getFBUserData()
                    }
                }
            }
        }
    }

    @IBAction func tappedGoogleSignInButton() {
        showHUD()
        // Initialize sign-in
//        var configureError: NSError?
//        GGLContext.sharedInstance().configureWithError(&configureError)
//        assert(configureError == nil, "Error configuring Google services: \(configureError)")
//
//        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signIn()
    }

    func getFBUserData() {
        if((FBSDKAccessToken.current()) != nil) {
            print(FBSDKAccessToken.current().tokenString)
            if (FBSDKAccessToken.current() != nil) {
                // User is logged in, do work such as go to next view controller.
                print("User is logged in, do work such as go to next view controller.")
            }

            // parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    print(result!)
                    var data = result as! [String : String]
                    print(data["email"]!)
                    print(FBSDKAccessToken.current().tokenString)
                    Util.saveEmail(email: data["email"]!)
                    self.callLoginAPI(isSocialLogin: true)
                }
            })
        }
    }
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        } else if textField == passwordField {
            confirmPasswordField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}
