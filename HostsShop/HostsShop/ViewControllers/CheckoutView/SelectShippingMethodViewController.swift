//
//  SelectShippingMethod.swift
//  HostsShop
//
//  Created by Vishnu Vardhan PV on 25/01/17.
//  Copyright © 2017 vishnuvardhanpv. All rights reserved.
//

import Foundation

class SelectShippingMethodViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var shippingMethods: [GetShippingMethod]?
    var selectedIndex: Int? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Util.customizeNavigationBarWithTitle(title: "Select Shipping", rightButtons: [], rightButtonSelectors:[], leftButtons: [], leftButtonSelectors:[], forViewController: self)
        self.tableView?.estimatedRowHeight = 72.0
        self.tableView?.rowHeight = UITableViewAutomaticDimension
        callAPIToGetShippingMethod()
    }
}

extension SelectShippingMethodViewController {
    func callAPIToGetShippingMethod() {
        GetShippingMethodAPIManager.getShippingMethod(sessionId: AppDelegate.application().sessionId!, emailId: "vishnuvardhanpv@gmail.com") { (response, error) in
            if let shippingMethod = response {
                print(shippingMethod)
                self.shippingMethods = shippingMethod
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }

    @IBAction func tappedPlaceOrderButton() {
        print("tappedPlaceOrderButton")
        if let index = selectedIndex {
            let shippingObj = self.shippingMethods?[index]
            SaveShippingMethodAPIManager.saveShippingMethod(sessionId: AppDelegate.application().sessionId!, emailId: "vishnuvardhanpv@gmail.com", shippingMethod: (shippingObj?.code)!) { (response, error) in
                if response?["status"] == "success" {
                    Util.showAlertWithTitle(title: "Success", message: (response?["message"]!)!, forViewController: self, okButtonAction: { 
                        self.performSegue(withIdentifier: "SelectPaymentSegue", sender: nil)
                    })
                }
            }
        }
    }
}

extension SelectShippingMethodViewController: UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if shippingMethods != nil, (shippingMethods?.count)! > 0 {
                return shippingMethods!.count
            } else {
                return 0
            }
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SelectAddressCell
            cell.selectionStyle = .none
            let shipping = self.shippingMethods?[indexPath.row]
            cell.addressLabel.text = (shipping?.label)! + "(\((shipping?.price)!))"
            if shipping?.selected == 1 {
                cell.tickImage?.image = #imageLiteral(resourceName: "radioActive")
            } else {
                cell.tickImage?.image = #imageLiteral(resourceName: "radioInactive")
            }
            return cell
        }
}

extension SelectShippingMethodViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView.estimatedRowHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
         for shipping in self.shippingMethods! {
            shipping.selected = 0
         }
         let shippingObj = self.shippingMethods?[indexPath.row]
         shippingObj?.selected = 1
         selectedIndex = indexPath.row
         self.tableView.reloadData()
    }
}
