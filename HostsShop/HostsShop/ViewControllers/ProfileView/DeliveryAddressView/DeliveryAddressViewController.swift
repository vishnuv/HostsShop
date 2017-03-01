//
//  DeliveryAddressViewController.swift
//  HostsShop
//
//  Created by Vishnu Vardhan PV on 09/02/17.
//  Copyright © 2017 vishnuvardhanpv. All rights reserved.
//

import UIKit
import KRProgressHUD

class DeliveryAddressViewController: UITableViewController {

    var address: [GetShippingAddress]?
    var selectedIndex: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        Util.customizeNavigationBarWithTitle(title: "Address", rightButtons: [], rightButtonSelectors:[], leftButtons: [], leftButtonSelectors:[], forViewController: self)
        self.tableView?.estimatedRowHeight = 75.0
        self.tableView?.rowHeight = UITableViewAutomaticDimension
        callAPIToGetShippingAddress()
    }
}

extension DeliveryAddressViewController {
    func callAPIToGetShippingAddress() {
        self.showHUD()
        GetShippingAddressAPIManager.getShippingAddress(sessionId: AppDelegate.application().sessionId!, emailId: "vishnuvardhanpv@gmail.com") { (response, error) in
            self.address = response?.data!
            self.hideHUD()
            if (self.address?.count)! > 1 {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }

    func showHUD() {
        KRProgressHUD.set(style:.black)
        KRProgressHUD.show()
    }

    func hideHUD() {
        KRProgressHUD.dismiss()
    }
}

extension DeliveryAddressViewController {

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView.estimatedRowHeight
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let adr = address, adr.count > 0 {
            return adr.count - 1
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) 
        cell.selectionStyle = .none
        let addressObj = self.address?[indexPath.row]
        let addressLabel = cell.viewWithTag(100) as! UILabel
        addressLabel.text = addressObj?.label
        return cell
    }
}
