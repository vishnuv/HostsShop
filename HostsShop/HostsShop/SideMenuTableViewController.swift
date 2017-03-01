//
//  SideMenuTableViewController.swift
//  HostsShop
//
//  Created by Vishnu Vardhan PV on 02/01/17.
//  Copyright © 2017 vishnuvardhanpv. All rights reserved.
//

import Foundation
import UIKit

extension Notification.Name {
    static let sideMenuCategorySelected = Notification.Name("SideMenuCategorySelected")
}

class SideMenuTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
    }
}

extension SideMenuTableViewController {
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (AppDelegate.application().catalogueData?.count)! + 1
    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell

        if indexPath.row == 0 {
            let bgColor = UIColor.init(colorLiteralRed: 202.0/255.0, green: 224.0/255.0, blue: 51.0/255.0, alpha: 1)
            cell.backgroundColor = bgColor
            cell.textLabel?.text = "Home"
        } else {
            let catalogue:Catalogue = (AppDelegate.application().catalogueData?[indexPath.row - 1])!
            cell.textLabel?.text = catalogue.name
        }
        return cell
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != 0 {
            let catalogue:Catalogue = (AppDelegate.application().catalogueData?[indexPath.row - 1])!
            NotificationCenter.default.post(name: .sideMenuCategorySelected, object: nil, userInfo: ["catalogue":catalogue])
        }
        dismiss(animated: true, completion: nil)
    }
}
