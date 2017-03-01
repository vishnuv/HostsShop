//
//  TestViewController.swift
//  HostsShop
//
//  Created by Vishnu Vardhan PV on 10/01/17.
//  Copyright © 2017 vishnuvardhanpv. All rights reserved.
//

import Foundation

extension Notification.Name {
    enum MyNames {
        static let backNotification = Notification.Name(rawValue: "backNotification")
        static let JSON_NEW = Notification.Name(rawValue: "JSON_NEW")
        static let JSON_DICT = Notification.Name(rawValue: "JSON_DICT")
    }
}

class TestViewController: UIViewController {
    @IBOutlet var seg: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(getDetails), name: Notification.Name.MyNames.backNotification, object: nil)
    }

    func getDetails(message: NSNotification)
    {
        print(message)
    }

    @IBAction func buyBtnAction(sender: UIButton)
    {
        let paymentView = PaymentModeViewController(nibName: "PaymentModeViewController", bundle: nil)
        paymentView.paymentAmtString = "1.00";
        paymentView.strSaleAmount = "1.00";
        paymentView.strCurrency = "INR";
        paymentView.strDisplayCurrency = "USD";
        //Reference no has to be configured
        paymentView.reference_no = "223";
        paymentView.strDescription = "Test Description";
        paymentView.strBillingName = "Test";
        paymentView.strBillingAddress = "Bill address";
        paymentView.strBillingCity = "Bill City";
        paymentView.strBillingState = "TN";
        paymentView.strBillingPostal = "625000";
        paymentView.strBillingCountry = "IND";
        paymentView.strBillingEmail = "test@testmail.com";
        paymentView.strBillingTelephone = "9363469999";
        // Non mandatory parameters
        paymentView.strDeliveryName = "";
        paymentView.strDeliveryAddress = "";
        paymentView.strDeliveryCity = "";
        paymentView.strDeliveryState = "";
        paymentView.strDeliveryPostal = "";
        paymentView.strDeliveryCountry = "";
        paymentView.strDeliveryTelephone = "";
        //Dynamic Values configuration
        //var dynamicKeyValueDictionary: NSMutableDictionary = NSMutableDictionary()
        // NSMutableDictionary *dynamicKeyValueDictionary = [[NSMutableDictionary alloc]init];
        // dynamicKeyValueDictionary.setValue("savings", forKey: "account_detail")
        //  dynamicKeyValueDictionary.setValue("gold", forKey: "merchant_type")
        //  paymentView.dynamicKeyValueDictionary = dynamicKeyValueDictionary
        self.navigationController!.pushViewController(paymentView, animated: true)
    }
}
