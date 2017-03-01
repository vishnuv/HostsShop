//
//  AppDelegate.swift
//  HostsShop
//
//  Created by Vishnu Vardhan PV on 21/12/16.
//  Copyright © 2016 vishnuvardhanpv. All rights reserved.
//

import UIKit
import FBSDKCoreKit

extension Notification.Name {
    static let callLoginAPI = Notification.Name("CallLoginAPI")
}

//@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var sessionId: String?
    var catalogueData: [Catalogue]?
    var selectedAddress: GetShippingAddress?
    var selectedPaymentType: PaymentType?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        // Google SignIn Configuration
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        GIDSignIn.sharedInstance().delegate = self

        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        if (FBSDKAccessToken.current() != nil) {
            // User is logged in, do work such as go to next view controller.
            print("User is logged in, do work such as go to next view controller.")
        }

        if Util.getEmail() != nil {
            print(Util.getEmail()!)
            // navigate to home
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let homeView = storyboard.instantiateViewController(withIdentifier: "HomeNavigationController") as! UINavigationController
            AppDelegate.application().window?.rootViewController = homeView

        }

        return true
    }

    public func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application,
            open: url as URL!,
            sourceApplication: sourceApplication,
            annotation: annotation)
    }

    public func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let googleDidHandle = GIDSignIn.sharedInstance().handle(url as URL!,
                                                                sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String,
                                                                annotation: options[UIApplicationOpenURLOptionsKey.annotation])

        let facebookDidHandle =  FBSDKApplicationDelegate.sharedInstance().application(
            app,
            open: url as URL!,
            sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String,
            annotation: options[UIApplicationOpenURLOptionsKey.annotation])

        return googleDidHandle || facebookDidHandle
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

extension AppDelegate {
    class func application() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate

    }
}

extension AppDelegate: GIDSignInDelegate {
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
//            let userId = user.userID                  // For client-side use only!
//            let idToken = user.authentication.idToken // Safe to send to the server
//            let fullName = user.profile.name
//            let givenName = user.profile.givenName
//            let familyName = user.profile.familyName
            let email = user.profile.email

            Util.saveEmail(email: email!)
            NotificationCenter.default.post(name: .callLoginAPI, object: nil)
            // ...
        } else {
            print("\(error.localizedDescription)")
        }
    }

    private func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!,
                withError error: NSError!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
}



