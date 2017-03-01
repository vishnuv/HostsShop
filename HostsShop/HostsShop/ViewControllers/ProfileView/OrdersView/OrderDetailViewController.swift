//
//  OrderDetailViewController.swift
//  HostsShop
//
//  Created by Vishnu Vardhan PV on 11/02/17.
//  Copyright © 2017 vishnuvardhanpv. All rights reserved.
//

import Foundation
import KRProgressHUD

class OrderDetailViewController: UITableViewController {

    var orderDetail: OrderDetail?
    var orderId: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 135.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        callLoginAPI()
    }
}

extension OrderDetailViewController {

    func showHUD() {
        KRProgressHUD.set(style:.black)
        KRProgressHUD.show()
    }

    func hideHUD() {
        KRProgressHUD.dismiss()
    }

    func callAPIToGetOrderDetail() {
        OrderDetailAPIManager.getOrderDetail(sessionId: AppDelegate.application().sessionId!, orderId: self.orderId!) { (response, error) in
            if let resData = response {
                self.orderDetail = resData.data
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
            self.callAPIToGetOrderDetail()
        }
    }

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let data = self.orderDetail {
            return data.orderItems!.count + 2
        } else {
            return 0
        }
    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier:"FinalCheckoutAddressCell", for: indexPath) as! FinalCheckoutAddressCell
            cell.emailLabel.text = "Email: vishnuvardhanpv@gmail.com"
            if let data = self.orderDetail {
                cell.addressLabel.text = data.shippingAddress
            }
            return cell
        } else if indexPath.row == (self.orderDetail!.orderItems!.count) + 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier:"FinalCheckoutPriceDetailsCell", for: indexPath) as! FinalCheckoutPriceDetailsCell
            if let data = self.orderDetail {
                cell.subTotalLabel.text = data.subTotal
                cell.shippingCostLabel.text = data.shippingAmount
                cell.grandTotalLabel.text = data.grandTotal
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier:"CartListCustomCell", for: indexPath) as! CartListCustomCell
            let order: OrderItem = self.orderDetail!.orderItems! [indexPath.row - 1]
            cell.nameLabel.text = order.name
            cell.quantityLabel.text = order.quantity
            cell.priceLabel.text = order.price
            cell.totalLabel.text = order.rowTotal
            cell.productImageView?.af_setImage(withURL: URL(string:(order.image)!)!)
            cell.moveToWishlistAction = { product in
                print(product)
            }
            cell.removeAction = { product in
                print(product)
            }
            return cell
        }
    }

    public override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return self.tableView.estimatedRowHeight
        } else if indexPath.row == (self.orderDetail!.orderItems!.count) + 1 {
            return 210.0
        } else {
            return 164.0
        }
    }
}

extension String {
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)

        return boundingBox.height
    }
}
