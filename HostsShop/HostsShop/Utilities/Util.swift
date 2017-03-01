//
//  Util.swift
//  HostsShop
//
//  Created by Vishnu Vardhan PV on 28/12/16.
//  Copyright © 2016 vishnuvardhanpv. All rights reserved.
//

import Foundation
import UIKit

class Util {
    // Shows an alert with a title and message with an Ok button
    static func showAlertWithTitle(title:String, message:String, forViewController:UIViewController, okButtonAction:@escaping () -> ()) {
        let alert = UIAlertController(title:title, message:message, preferredStyle: UIAlertControllerStyle.alert);
        let okAction = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction!) in
            okButtonAction()
        }
        alert.addAction(okAction)
        DispatchQueue.main.async {
            forViewController.present(alert, animated: true, completion: nil)
        }
    }

    // Customize navigation bar with title and buttons on passing button images and selectors as array.
    static func customizeNavigationBarWithTitle(title:String?, rightButtons:[String], rightButtonSelectors:[Selector], leftButtons:[String], leftButtonSelectors:[Selector], forViewController:UIViewController) {

        forViewController.navigationItem.rightBarButtonItem = nil
        forViewController.navigationItem.leftBarButtonItem = nil
        forViewController.navigationItem.titleView = nil
        forViewController.navigationItem.title = nil

        var rightBarButtons = [UIBarButtonItem]()
        for (button, selector) in zip(rightButtons, rightButtonSelectors) {
            var rightImage: UIImage = UIImage(named: button)!
            rightImage = rightImage.withRenderingMode(.alwaysOriginal)
            let rightButton = UIBarButtonItem(image: rightImage, style: .plain, target: forViewController, action: selector)
            rightBarButtons.append(rightButton)
        }

        var leftBarButtons = [UIBarButtonItem]()
        for (button, selector) in zip(leftButtons, leftButtonSelectors) {
            var leftImage: UIImage = UIImage(named: button)!
            leftImage = leftImage.withRenderingMode(.alwaysOriginal)
            let leftButton = UIBarButtonItem(image: leftImage, style: .plain, target: forViewController, action: selector)
            leftBarButtons.append(leftButton)
        }

        forViewController.navigationItem.setRightBarButtonItems(rightBarButtons, animated: true)
        forViewController.navigationItem.setLeftBarButtonItems(leftBarButtons, animated: true)
        forViewController.navigationItem.title = title
    }

    static func saveEmail(email: String) {
        let defaults = UserDefaults.standard
        defaults.set(email, forKey: "email")
    }

    static func getEmail() -> (String?) {
        return(UserDefaults.standard.object(forKey: "email") as? String)
    }

    static func clearEmail() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "email")
    }
}
