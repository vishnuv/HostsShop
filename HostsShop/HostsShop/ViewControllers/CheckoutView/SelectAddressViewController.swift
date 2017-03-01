//
//  SelectAddressViewController.swift
//  HostsShop
//
//  Created by Vishnu Vardhan PV on 25/01/17.
//  Copyright © 2017 vishnuvardhanpv. All rights reserved.
//

import Foundation

class SelectAddressViewController: UITableViewController {

    var address: [GetShippingAddress]?
    var selectedIndex: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        Util.customizeNavigationBarWithTitle(title: "Select Address", rightButtons: ["tick"], rightButtonSelectors:[#selector(self.tappedDoneButton)], leftButtons: ["close"], leftButtonSelectors:[#selector(self.tappedCancelButton)], forViewController: self)
        self.tableView?.estimatedRowHeight = 75.0
        self.tableView?.rowHeight = UITableViewAutomaticDimension
    }
}

extension SelectAddressViewController {
    func tappedCancelButton() {
        _ = self.navigationController?.popViewController(animated: true)
    }

    func tappedDoneButton() {
        if let index = selectedIndex {
            if index == (address?.count)! - 1 {
                _ = self.navigationController?.popViewController(animated: true)
            } else {
                callAPIToSaveShippingAddress()
            }
        }
    }

    func callAPIToSaveShippingAddress() {
        let addressObj = self.address?[selectedIndex!]
        AddDeliveryAddressAPIManager.addDeliveryAddressWithAddressIdAPIManager(sessionId: AppDelegate.application().sessionId!, emailId: "vishnuvardhanpv@gmail.com", addressId: (addressObj?.value)!) { (response, error) in
            if response?["status"] == "success" {
                Util.showAlertWithTitle(title: "Success", message: (response?["message"]!)!, forViewController: self, okButtonAction: {
                    // navigate to selectshippingmethod screen
                    self.performSegue(withIdentifier: "SelectShippingMethodSegue", sender: nil)
                })
            }
        }
    }
}

extension SelectAddressViewController {

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView.estimatedRowHeight
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (address?.count)!
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SelectAddressCell
        cell.selectionStyle = .none
        let addressObj = self.address?[indexPath.row]
        cell.addressLabel.text = addressObj?.label
        if addressObj?.selected == 1 {
            cell.tickImage?.image = #imageLiteral(resourceName: "radioActive")
        } else {
            cell.tickImage?.image = #imageLiteral(resourceName: "radioInactive")
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        for add in self.address! {
            add.selected = 0
        }
        let addressObj = self.address?[indexPath.row]
        addressObj?.selected = 1
        selectedIndex = indexPath.row
        AppDelegate.application().selectedAddress = addressObj
        self.tableView.reloadData()
    }
}
