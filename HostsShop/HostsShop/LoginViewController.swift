//
//  ViewController.swift
//  HostsShop
//
//  Created by Vishnu Vardhan PV on 21/12/16.
//  Copyright © 2016 vishnuvardhanpv. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import KRProgressHUD

class LoginViewController: UIViewController, GIDSignInUIDelegate {

    @IBOutlet weak var signInButton: GIDSignInButton!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = false
        // Do any additional setup after loading the view, typically from a nib.

//        let loginButton: FBSDKLoginButton = FBSDKLoginButton()
//        loginButton.center = self.view.center
//        self.view.addSubview(loginButton)

        GIDSignIn.sharedInstance().uiDelegate = self

        let borderColor = UIColor.init(colorLiteralRed: 128.0/255.0, green: 142.0/255.0, blue: 59.0/255.0, alpha: 1)
        emailField.layer.borderColor = borderColor.cgColor
        passwordField.layer.borderColor = borderColor.cgColor

        NotificationCenter.default.addObserver(self, selector: #selector(callLoginAPIAfterGoogleLogin), name: .callLoginAPI, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
//        GIDSignIn.sharedInstance().signIn()
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

                    self.callLoginAPI(isLogin: false)
                }
            })
        }
    }
}

extension LoginViewController {
    @IBAction func tappedLoginButton() {
        if !isValidEmail(testStr: emailField.text!) {
            print("invalid email")
        } else if (passwordField.text?.isEmpty)! {
            print("invalid password")
        } else {
            print("call API")
            callLoginAPI(isLogin: true)
        }
    }

    func callLoginAPI(isLogin: Bool) {
        showHUD()
        LoginAPIManager.loginUser() { (response, error) in
            print("AHSJSHDKAHDKJAHSDKAHSDKHASDKJHS***********")
            print("session id \(response)")
            AppDelegate.application().sessionId = response
            if isLogin {
                self.callValidateCustomerAPI()
            } else {
                self.callRegisterAPI()
            }
        }
    }

    func callLoginAPIAfterGoogleLogin() {
        callLoginAPI(isLogin: false)
    }

    func callValidateCustomerAPI() {
        ValidateCustomerAPIManager.validateCustomer(email: emailField.text!, password: passwordField.text!, session: AppDelegate.application().sessionId!) { (response, error) in
            if let data = response {
                var dict: [String: String] = data
                if dict["status"]! == "success" {
                    print("navigate to home")

                    DispatchQueue.main.async {
//                        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
//                        let homeView = storyboard.instantiateViewController(withIdentifier: "HomeNavigationController") as! UINavigationController
//                        AppDelegate.application().window?.rootViewController = homeView
                        self.performSegue(withIdentifier: "LocationViewSegue", sender: nil)
                    }
                } else {
                    Util.showAlertWithTitle(title: dict["status"]!, message: dict["message"]!, forViewController: self, okButtonAction: {
                    })
                }
                self.hideHUD()
            }
        }
    }

    func callRegisterAPI() {
        RegisterAPIManager.registerUser(email: Util.getEmail()!, password: "qwerty", type: 1, sessionId: AppDelegate.application().sessionId!) { (response, error) in
            self.hideHUD()
            if let data = response {
                var dict: [String: String] = data
                if dict["status"]! == "success" || dict["status"]! == "registered" {
                    print("navigate to home")
                    DispatchQueue.main.async {

//                        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
//                        let homeView = storyboard.instantiateViewController(withIdentifier: "HomeNavigationController") as! UINavigationController
//                        AppDelegate.application().window?.rootViewController = homeView

                        self.performSegue(withIdentifier: "LocationViewSegue", sender: nil)
                    }
                } else {
                    Util.showAlertWithTitle(title: dict["status"]!, message: dict["message"]!, forViewController: self, okButtonAction: {
                    })
                }
            }
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
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}
