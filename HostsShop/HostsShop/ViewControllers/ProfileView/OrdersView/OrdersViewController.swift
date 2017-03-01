//
//  OrdersViewController.swift
//  HostsShop
//
//  Created by Vishnu Vardhan PV on 10/02/17.
//  Copyright © 2017 vishnuvardhanpv. All rights reserved.
//

import UIKit

class OrdersViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    var orderList: [CustomerOrder]?

    override func viewDidLoad() {
        super.viewDidLoad()
        Util.customizeNavigationBarWithTitle(title: "My Orders", rightButtons: [], rightButtonSelectors:[], leftButtons: [], leftButtonSelectors:[], forViewController: self)
        callLoginAPI()
    }
}

extension OrdersViewController {
    func callAPIToGetOrders() {
        GetCustomerOrderListAPIManager.getCustomerOrderList(sessionId: AppDelegate.application().sessionId!, emailId: "vishnuvardhanpv@gmail.com") { (response, error) in
            if let resData = response {
                self.orderList = resData.data
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            self.hideHUD()
        }
    }

    func callLoginAPI() {
        showHUD()
        LoginAPIManager.loginUser() { (response, error) in
            print("AHSJSHDKAHDKJAHSDKAHSDKHASDKJHS***********")
            print("session id \(response)")
            AppDelegate.application().sessionId = response
            self.callAPIToGetOrders()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let order = orderList?[sender as! Int]
        let detail = segue.destination as! OrderDetailViewController
        detail.orderId = order?.incrementId
    }
}

extension OrdersViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let resData = orderList, resData.count > 0 {
            return resData.count
        }
        return 0
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCustomCell", for: indexPath) as! OrderCustomCell
        let order = orderList?[indexPath.row]
        cell.orderIdLabel.text = "Order Id: " + (order?.incrementId)!
        cell.statusLabel.text = "Status: " + (order?.status)!
        cell.totalLabel.text = "Total: " + (order?.grandTotal)!
        cell.orderDateLabel.text = "Order Date: " + (order?.orderDate)!
        return cell
    }
}

extension OrdersViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "OrderDetailSegue", sender: indexPath.row)
    }
}
