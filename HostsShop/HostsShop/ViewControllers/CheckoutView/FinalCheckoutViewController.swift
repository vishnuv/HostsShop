//
//  FinalCheckoutViewController.swift
//  HostsShop
//
//  Created by Vishnu Vardhan PV on 02/02/17.
//  Copyright © 2017 vishnuvardhanpv. All rights reserved.
//

import UIKit
import PayUmoney_SDK

extension Notification.Name {
    enum EBSPayment {
        static let backNotification = Notification.Name(rawValue: "backNotification")
        static let JSON_NEW = Notification.Name(rawValue: "JSON_NEW")
        static let JSON_DICT = Notification.Name(rawValue: "JSON_DICT")
    }
}

class FinalCheckoutViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    var cartListResponse: GetCartlistAPIResponse?
    var orderTotalResponse: GetOrderTotalAPIResponse?
    var params:PUMRequestParams?

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(getDetails), name: Notification.Name.EBSPayment.backNotification, object: nil)
        Util.customizeNavigationBarWithTitle(title: "Review Products", rightButtons: ["user", "addNew"], rightButtonSelectors:[#selector(HomeViewController.hideHUD), #selector(HomeViewController.hideHUD)], leftButtons: [], leftButtonSelectors:[], forViewController: self)
        self.tableView?.estimatedRowHeight = 164.0
        self.tableView?.rowHeight = UITableViewAutomaticDimension
        self.callLoginAPI()
    }
}

extension FinalCheckoutViewController {

    // MARK: EBS Payment method
    func getDetails(message: NSNotification)
    {
        print(message)
    }

    func callLoginAPI() {
        showHUD()
        LoginAPIManager.loginUser() { (response, error) in
            print("AHSJSHDKAHDKJAHSDKAHSDKHASDKJHS***********")
            print("session id \(response)")
            AppDelegate.application().sessionId = response
            self.callCartlistAPI()
        }
    }

    func callCartlistAPI() {
        GetCartlistAPIManager.getCartlist(sessionId: AppDelegate.application().sessionId!, emailId: "vishnuvardhanpv@gmail.com") { (response, error) in
            print(response)
            if response != nil {
                self.cartListResponse = response
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.callGetOrderTotalAPI()
                }
            } else {
                self.hideHUD()
            }
        }
    }

    func callGetOrderTotalAPI() {
        GetOrderTotalAPIManager.getOrderTotal(sessionId: AppDelegate.application().sessionId!, emailId: "vishnuvardhanpv@gmail.com") { (response, error) in
            if response != nil {
                self.orderTotalResponse = response
                DispatchQueue.main.async {
                    self.tableView.reloadRows(at: [IndexPath(row:(self.cartListResponse?.data!.count)! + 1, section:0)], with: .none)
                }
            }
            self.hideHUD()
        }
    }

    func callCreateOrderAPI(status:String) {
        CreateOrderAPIManager.createOrder(sessionId: AppDelegate.application().sessionId!, emailId: "vishnuvardhanpv@gmail.com", paymentStatus: status) { (response, error) in
            print(response!)
            if response?["status"] == "success" {
                // success
                self.callGetOrderMessageAPI(type:.success)
            } else {
                // failure
                self.callGetOrderMessageAPI(type:.failure)
            }
        }
    }

    func callGetOrderMessageAPI(type: MessageType) {
        GetOrderMessageAPIManager.getOrderMessage(messageType: type) { (response, error) in
            Util.showAlertWithTitle(title: "", message: (response?["title"]!)!, forViewController: self, okButtonAction: {
            })
        }
    }

    @IBAction func tappedPlaceOrderButton() {
        if self.orderTotalResponse != nil {
            if AppDelegate.application().selectedPaymentType == PaymentType.COD {
                self.callCreateOrderAPI(status: "Success")
            } else if AppDelegate.application().selectedPaymentType == PaymentType.EBS {
                setEBSPaymentParams()
            } else if AppDelegate.application().selectedPaymentType == PaymentType.PayUMoney {
                setPayUMoneyParams()
            }
        }
    }

    func setEBSPaymentParams() {
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

    // MARK:PayUMoney Params
    func setPayUMoneyParams() {
        self.params = PUMRequestParams.shared()

        // Mandatory fields
        self.params?.environment = .test;
        self.params?.surl = "https://www.payumoney.com/mobileapp/payumoney/success.php"
        self.params?.furl = "https://www.payumoney.com/mobileapp/payumoney/failure.php"

        var amountToBePayed = self.orderTotalResponse?.data?.grandTotal
        amountToBePayed = amountToBePayed?.replacingOccurrences(of: "₹", with: "")

        self.params?.amount = amountToBePayed
        self.params?.key = "MCSDMYXR"
        self.params?.merchantid = "4944364"
        self.params?.txnid = "671256312736517235"
        self.params?.delegate = self

        // Custom
        self.params?.firstname = "Vishnu Vardhan PV"
        self.params?.productinfo = "iPhone"
        self.params?.email = "vishnu@webtechnologycodes.com"
        self.params?.phone = "9633457464"
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

        if(self.params?.environment == PUMEnvironment.production){
            generateHashForProdAndNavigateToSDK()
        }
        else{
            calculateHashFromServer()
        }
    }

    // MARK:Hash Calculation

    /**
     * hash calculation strictly recommended to be done on your server end. This is just to show the hash sequence format and oe the api call for hash should be. Encryption is SHA-512.
     */
    func prepareHashBody()->NSString{
        return "key=\(params!.key!)&amount=\(params!.amount!)&txnid=\(params!.txnid!)&productinfo=\(params!.productinfo!)&email=\(params!.email!)&firstname=\(params!.firstname!)" as NSString;
    }

    func calculateHashFromServer(){
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        let url = URL(string: "https://test.payumoney.com/payment/op/v1/calculateHashForTest")!
        var request = URLRequest(url: url)
        request.httpBody = prepareHashBody().data(using: String.Encoding.utf8.rawValue)
        request.httpMethod = "POST"

        let task = session.dataTask(with: request, completionHandler: {
            (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]{
                        //Implement your logic
                        print(json)
                        let status : NSNumber = json["status"] as! NSNumber
                        if(status.intValue == 0)
                        {
                            self.params?.hashValue = json["result"] as! String!
                            OperationQueue.main.addOperation {
                                self.startPaymentFlow()
                            }
                        }
                        else{
                            OperationQueue.main.addOperation {
                                self.showAlertViewWithTitle(title: "Message", message: json["message"] as! String)
                            }
                        }
                    }
                } catch {
                    print("error in JSONSerialization")
                }
            }
        })
        task.resume()
    }

    func generateHashForProdAndNavigateToSDK() -> Void {
        let txnid = params?.txnid!
        //add your salt in place of 'salt' if you want to test on live environment.
        //We suggest to calculate hash from server and not to keep the salt in code as it is a severe of security vulnerability.
        let hashSequence : NSString = "\(params!.key)|\(txnid)|\(params!.amount)|\(params!.productinfo)|\(params!.firstname)|\(params!.email)|||||||||||salt" as NSString
        let data :NSString = "12763512367123567"
        params?.hashValue = data as String!;
        startPaymentFlow();
    }

    func startPaymentFlow() {
        let paymentVC: PUMMainVController = PUMMainVController.init()
        let paymentNavController: UINavigationController = UINavigationController.init(rootViewController: paymentVC)
        self.present(paymentNavController, animated: true) {
        }
    }

    func showAlertViewWithTitle(title : String,message:String) -> Void {
        let alertController : UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            NSLog("OK Pressed")
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
}

extension FinalCheckoutViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let data = cartListResponse {
            return data.data!.count + 2
        } else {
            return 0
        }
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier:"FinalCheckoutAddressCell", for: indexPath) as! FinalCheckoutAddressCell
            cell.emailLabel.text = "Email: vishnuvardhanpv@gmail.com"
            cell.addressLabel.text = AppDelegate.application().selectedAddress?.label
            cell.changeAddressAction = {
                print("tapped change address")
            }
            return cell
        } else if indexPath.row == (cartListResponse?.data!.count)! + 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier:"FinalCheckoutPriceDetailsCell", for: indexPath) as! FinalCheckoutPriceDetailsCell
            if let data = self.orderTotalResponse {
                cell.subTotalLabel.text = data.data?.subTotal
                cell.shippingCostLabel.text = data.data?.shippingCost
                cell.grandTotalLabel.text = data.data?.grandTotal
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier:"FinalCheckoutViewCustomCell", for: indexPath) as! FinalCheckoutViewCustomCell
            let cartListProduct: CartlistProduct = (cartListResponse! as GetCartlistAPIResponse).data! [indexPath.row - 1]
            cell.cartlistProduct = cartListProduct
            return cell
        }
    }
}

extension FinalCheckoutViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return UITableViewAutomaticDimension
        } else {
            return 164.0
        }
    }
}

extension FinalCheckoutViewController: TransactionCompeltionDelegate {
    public func transactinCanceledByUser() {
        print("transactinCanceledByUser")
        self.dismiss(animated: true){
            self.showAlertViewWithTitle(title: "Message", message: "Payment Cancelled ")
        }
    }

    public func transactinExpired(withResponse msg: String!) {
        print("transactinExpired")
        self.dismiss(animated: true){
            self.showAlertViewWithTitle(title: "Message", message: "Payment Expired ")
        }
    }

    public func transactinFailed(withResponse response: [AnyHashable : Any]!, errorDescription error: Error!) {
        print("transactinFailed")
        self.dismiss(animated: true){
            self.showAlertViewWithTitle(title: "Message", message: "Payment failed ")
            self.callCreateOrderAPI(status: "Failure")
        }
    }

    public func transactionCompleted(withResponse response: [AnyHashable : Any]!, errorDescription error: Error!) {
        print("transactionCompleted")
        self.dismiss(animated: true){
            self.showAlertViewWithTitle(title: "Message", message: "Payment Success")
            self.callCreateOrderAPI(status: "Success")
        }
    }
}

