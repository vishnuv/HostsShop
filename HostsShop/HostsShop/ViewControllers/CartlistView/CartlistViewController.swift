//
//  CartlistViewController.swift
//  HostsShop
//
//  Created by Vishnu Vardhan PV on 15/01/17.
//  Copyright © 2017 vishnuvardhanpv. All rights reserved.
//

import Foundation

class CartlistViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalLabel: UILabel!
    var cartListResponse: GetCartlistAPIResponse?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        Util.customizeNavigationBarWithTitle(title: "Cart", rightButtons: ["user", "addNew"], rightButtonSelectors:[#selector(HomeViewController.hideHUD), #selector(HomeViewController.hideHUD)], leftButtons: [], leftButtonSelectors:[], forViewController: self)
        self.callLoginAPI()
    }
}

extension CartlistViewController {
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
        print(AppDelegate.application().sessionId!)
        GetCartlistAPIManager.getCartlist(sessionId: AppDelegate.application().sessionId!, emailId: "vishnuvardhanpv@gmail.com") { (response, error) in
            print(response)
            self.cartListResponse = response
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.totalLabel.text = self.cartListResponse?.cartTotal
                self.hideHUD()
            }
        }
    }

    @IBAction func tappedCheckout() {
        print("tappedCheckout")
        if (cartListResponse?.data!.count)! > 0 {
            self.performSegue(withIdentifier: "CheckoutSegue", sender: nil)
        }
    }

    @IBAction func tappedContinueShopping() {
        print("tappedContinueShopping")
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
}

extension CartlistViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let data = cartListResponse {
            return data.data!.count
        } else {
            return 0
        }
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"CartListCustomCell", for: indexPath) as! CartListCustomCell
        let cartListProduct: CartlistProduct = (cartListResponse! as GetCartlistAPIResponse).data! [indexPath.row]
        cell.cartlistProduct = cartListProduct
        cell.moveToWishlistAction = { product in
            print(product)
        }
        cell.removeAction = { product in
            print(product)
        }
        return cell
    }
}
