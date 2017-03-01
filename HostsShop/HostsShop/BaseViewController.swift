//
//  BaseViewController.swift
//  HostsShop
//
//  Created by Vishnu Vardhan PV on 29/12/16.
//  Copyright © 2016 vishnuvardhanpv. All rights reserved.
//

import Foundation
import UIKit
import KRProgressHUD
import FBSDKLoginKit

struct SearchBarConstants {
    static let searchBarHeight: CGFloat = 20.0
    static let searchBarPlaceholder: String = "Search here"
}

class BaseViewController: UIViewController {

    var searchBar = UISearchBar()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func showHUD() {
        KRProgressHUD.set(style:.black)
        KRProgressHUD.show()
    }

    func hideHUD() {
        KRProgressHUD.dismiss()
    }

    func tappedProfileLogoutButton() {
        let alert = UIAlertController(title: "", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Profile", style: .default) { action in
            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController {
                if let navigator = self.navigationController {
                    navigator.pushViewController(viewController, animated: true)
                }
            }
        })
        alert.addAction(UIAlertAction(title: "Logout", style: .default) { action in

            Util.clearEmail()

            GIDSignIn.sharedInstance().signOut()

            let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
            fbLoginManager.logOut()

            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let homeView = storyboard.instantiateViewController(withIdentifier: "LoginSignUpNavigationController") as! UINavigationController
            AppDelegate.application().window?.rootViewController = homeView
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .default) { action in
            alert.dismiss(animated: true, completion: {
            })
        })
        self.present(alert, animated:true)
    }

    // MARK: Customise navigation bar to add search bar.
    func addSearchBar() {
        self.navigationItem.rightBarButtonItems = nil
        self.navigationItem.title = nil
        searchBar = UISearchBar(frame: CGRect(x:0, y:0, width:(self.navigationController?.navigationBar.frame.size.width)!, height:SearchBarConstants.searchBarHeight))
        searchBar.placeholder = SearchBarConstants.searchBarPlaceholder
        searchBar.showsCancelButton = true
        searchBar.becomeFirstResponder()
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
    }

    func customizeNavigationBar() {
    }
}

extension BaseViewController: UISearchBarDelegate {
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        searchActive = true
    }
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        searchActive = true
        print("Search tapped ..........****")
        self.performSegue(withIdentifier: "SearchResultsViewSegue", sender: nil)
    }
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        searchActive = false;
        customizeNavigationBar()
    }
}
