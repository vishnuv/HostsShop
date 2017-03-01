//
//  SelectPaymentMethodViewController.swift
//  HostsShop
//
//  Created by Vishnu Vardhan PV on 25/01/17.
//  Copyright © 2017 vishnuvardhanpv. All rights reserved.
//

import Foundation
import PayUmoney_SDK

enum PaymentType: String {
    case COD = "cashondelivery"
    case EBS = "secureebs_standard"
    case PayUMoney = "payucheckout_shared"
}

class SelectPaymentMethodViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var paymentMethods: [PaymentMethod]?
    var selectedIndex: Int? = nil

    // PayUMoney
    var params:PUMRequestParams?

    override func viewDidLoad() {
        super.viewDidLoad()
        Util.customizeNavigationBarWithTitle(title: "Select Payment", rightButtons: [], rightButtonSelectors:[], leftButtons: [], leftButtonSelectors:[], forViewController: self)
        self.tableView?.estimatedRowHeight = 72.0
        self.tableView?.rowHeight = UITableViewAutomaticDimension
        callAPIToGetPaymentMethod()
    }
}

extension SelectPaymentMethodViewController {
    func callAPIToGetPaymentMethod() {
        GetPaymentMethodsAPIManager.getPaymentMethods { (response, error) in
            if let paymentMethod = response {
                print(paymentMethod)
                self.paymentMethods = paymentMethod
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }

    @IBAction func tappedPlaceOrderButton() {
        print("tappedPlaceOrderButton")
        if let index = selectedIndex {
            let paymentObj = self.paymentMethods?[index]
            SavePaymentMethodAPIManager.savePaymentMethod(sessionId: AppDelegate.application().sessionId!, emailId: "vishnuvardhanpv@gmail.com", paymentMethod:(paymentObj?.code)!) { (response, error) in
                print(response?["message"]!)
                if response?["status"] == "success" {
                    Util.showAlertWithTitle(title: "Success", message: (response?["message"]!)!, forViewController: self, okButtonAction: {
                        // navigate to next
                        self.performSegue(withIdentifier: "FinalCheckoutViewSegue", sender: nil)
                    })
                }
            }

        }
    }

    func setPayUMoneyParams() {
        self.params = PUMRequestParams.shared()

        // Mandatory fields
        self.params?.environment = .production;
        self.params?.surl = "https://www.payumoney.com/mobileapp/payumoney/success.php"
        self.params?.furl = "https://www.payumoney.com/mobileapp/payumoney/failure.php"
        self.params?.amount = "100"
        self.params?.key = "pass your own key here"
        self.params?.merchantid = "pass your unique id here"
        self.params?.txnid = "pass random transaction id each time"
        self.params?.delegate = self

        // Custom
        self.params?.firstname = "Ashish"
        self.params?.productinfo = "iPhone"
        self.params?.email = "test@gmail.com"
        self.params?.phone = "9876543210"
        self.params?.udf1 = ""
        self.params?.udf2 = ""
        self.params?.udf3 = ""
        self.params?.udf4 = ""
        self.params?.udf5 = ""
        self.params?.udf6 = ""
        self.params?.udf7 = ""
        self.params?.udf8 = ""
        self.params?.udf9 = ""
        self.params?.udf10 = ""
    }

    func setSelectedPaymentType(paymentObj: PaymentMethod) {
        switch paymentObj.code {
        case PaymentType.COD.rawValue?:
            AppDelegate.application().selectedPaymentType = .COD
        case PaymentType.EBS.rawValue?:
            AppDelegate.application().selectedPaymentType = .EBS
        case PaymentType.PayUMoney.rawValue?:
            AppDelegate.application().selectedPaymentType = .PayUMoney
        default:
            print("")
        }
    }
}

extension SelectPaymentMethodViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if paymentMethods != nil, (paymentMethods?.count)! > 0 {
            return paymentMethods!.count
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SelectAddressCell
        cell.selectionStyle = .none
        let payment = self.paymentMethods?[indexPath.row]
        cell.addressLabel.text = (payment?.title)!
        if payment?.selected == 1 {
            cell.tickImage?.image = #imageLiteral(resourceName: "radioActive")
        } else {
            cell.tickImage?.image = #imageLiteral(resourceName: "radioInactive")
        }
        return cell
    }
}

extension SelectPaymentMethodViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView.estimatedRowHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        for payment in self.paymentMethods! {
            payment.selected = 0
        }
        let paymentObj = self.paymentMethods?[indexPath.row]
        paymentObj?.selected = 1
        selectedIndex = indexPath.row
        self.tableView.reloadData()
        self.setSelectedPaymentType(paymentObj: paymentObj!)
    }
}
