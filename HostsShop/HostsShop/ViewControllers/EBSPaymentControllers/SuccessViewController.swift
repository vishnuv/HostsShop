//
//  SuccessViewController.swift
//  EBSTest
//
//  Created by Vishnu Vardhan PV on 04/02/17.
//  Copyright © 2017 QBurst. All rights reserved.
//

import UIKit

class SuccessViewController: UIViewController {
    var jsondict=NSMutableDictionary()

    @IBOutlet var scrollView: UIScrollView!

    @IBOutlet var lbl1: UILabel!
    @IBOutlet var lbl2: UILabel!
    @IBOutlet var lbl3: UILabel!
    @IBOutlet var lbl4: UILabel!
    @IBOutlet var lbl5: UILabel!
    @IBOutlet var lbl6: UILabel!
    @IBOutlet var lbl7: UILabel!
    @IBOutlet var lbl8: UILabel!
    @IBOutlet var lbl9: UILabel!
    @IBOutlet var lbl10: UILabel!
    @IBOutlet var lbl11: UILabel!
    @IBOutlet var lbl12: UILabel!
    @IBOutlet var lbl13: UILabel!
    @IBOutlet var lbl14: UILabel!
    @IBOutlet var lbl15: UILabel!
    @IBOutlet var lbl16: UILabel!
    @IBOutlet var lbl17: UILabel!
    @IBOutlet var lbl18: UILabel!
    @IBOutlet var lbl19: UILabel!
    @IBOutlet var lbl20: UILabel!
    @IBOutlet var lbl21: UILabel!
    @IBOutlet var lbl22: UILabel!
    @IBOutlet var lbl23: UILabel!
    @IBOutlet var lbl24: UILabel!
    @IBOutlet var lbl25: UILabel!
    @IBOutlet var lbl26: UILabel!
    @IBOutlet var lbl27: UILabel!
    @IBOutlet var lbl28: UILabel!
    @IBOutlet var lbl29: UILabel!
    @IBOutlet var lbl30: UILabel!

    var error: NSError?

    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(ResponseNew), name: Notification.Name.MyNames.JSON_NEW, object: nil)
        NotificationCenter.default.post(name: Notification.Name.MyNames.JSON_DICT, object: nil)
        scrollView.contentSize = CGSize(width:0, height:2600)
    }

    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = true
    }

    override func viewWillDisappear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = false
    }

    func ResponseNew(message:NSNotification)
    {
        if (message.name.rawValue == "JSON_NEW") {
            print("Response = \(message.object!)", terminator: "")
            jsondict = message.object as! NSMutableDictionary
        }

        let accID:NSString = jsondict.value(forKey: "AccountId") as! NSString
        lbl1.text = accID as String

        let amtStr:NSString = jsondict.value(forKey: "Amount") as! NSString
        lbl2.text = amtStr as String

        let billAddStr:NSString = jsondict.value(forKey: "BillingAddress") as! NSString
        lbl3.text = billAddStr as String

        let billCityStr:NSString = jsondict.value(forKey: "BillingCity") as! NSString
        lbl4.text = billCityStr as String

        let billCounStr:NSString = jsondict.value(forKey: "BillingCountry") as! NSString
        lbl5.text = billCounStr as String

        let billNameStr:NSString = jsondict.value(forKey: "BillingName") as! NSString
        lbl6.text = billNameStr as String

        let billPhoneStr:NSString = jsondict.value(forKey: "BillingPhone") as! NSString
        lbl7.text = billPhoneStr as String

        let billPostalStr:NSString = jsondict.value(forKey: "BillingPostalCode") as! NSString
        lbl8.text = billPostalStr as String

        let billStateStr:NSString = jsondict.value(forKey: "BillingState") as! NSString
        lbl9.text = billStateStr as String

        let billEmailStr:NSString = jsondict.value(forKey: "BillingEmail") as! NSString
        lbl10.text = billEmailStr as String

        let dateCreStr:NSString = jsondict.value(forKey: "DateCreated") as! NSString
        lbl11.text = dateCreStr as String

        let delAddStr:NSString = jsondict.value(forKey: "DeliveryAddress") as! NSString
        lbl12.text = delAddStr as String

        let delCityStr:NSString = jsondict.value(forKey: "DeliveryCity") as! NSString
        lbl13.text = delCityStr as String

        let delCounStr:NSString = jsondict.value(forKey: "DeliveryCountry") as! NSString
        lbl14.text = delCounStr as String

        let delNameStr:NSString = jsondict.value(forKey: "DeliveryName") as! NSString
        lbl15.text = delNameStr as String

        let delPhStr:NSString = jsondict.value(forKey: "DeliveryPhone") as! NSString
        lbl16.text = delPhStr as String

        let delPostStr:NSString = jsondict.value(forKey: "DeliveryPostalCode") as! NSString
        lbl17.text = delPostStr as String

        let delStateStr:NSString = jsondict.value(forKey: "DeliveryState") as! NSString
        lbl18.text = delStateStr as String

        let descStr:NSString = jsondict.value(forKey: "Description") as! NSString
        lbl19.text = descStr as String

        let isFlagStr:NSString = jsondict.value(forKey: "IsFlagged") as! NSString
        lbl20.text = isFlagStr as String

        let mercStr:NSString = jsondict.value(forKey: "MerchantRefNo") as! NSString
        lbl21.text = mercStr as String

        let modeStr:NSString = jsondict.value(forKey: "Mode") as! NSString
        lbl22.text = modeStr as String

        let payIDStr:NSString = jsondict.value(forKey: "PaymentId") as! NSString
        lbl23.text = payIDStr as String

        let payModeStr:NSString = jsondict.value(forKey: "PaymentMode") as! NSString
        lbl24.text = payModeStr as String

        let payStautsStr:NSString = jsondict.value(forKey: "PaymentStatus") as! NSString
        lbl25.text = payStautsStr as String

        //let resCodeStr:NSString = jsondict.valueForKey("ResponseCode") as! NSString
        // let resCodeStr:NSInteger = jsondict.valueForKey("ResponseCode") as! NSInteger
        // lbl26.text = resCodeStr as String

        lbl26.text = ""

        let reMsgStr:NSString = jsondict.value(forKey: "ResponseMessage") as! NSString
        lbl27.text = reMsgStr as String

        let secHashStr:NSString = jsondict.value(forKey: "SecureHash") as! NSString
        lbl28.text = secHashStr as String

        let transStr:NSString = jsondict.value(forKey: "TransactionId") as! NSString
        lbl29.text = transStr as String

    }

    @IBAction func submitClk(sender: AnyObject) {
        for var nav in (self.navigationController?.viewControllers)! {
            if nav is TestViewController {
                _ = self.navigationController?.popToViewController(nav, animated: true)
                break
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}
