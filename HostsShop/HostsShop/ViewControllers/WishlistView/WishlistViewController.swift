//
//  WishlistViewController.swift
//  HostsShop
//
//  Created by Vishnu Vardhan PV on 15/01/17.
//  Copyright © 2017 vishnuvardhanpv. All rights reserved.
//

import Foundation

class WishlistViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    var wishListResponse: GetWishlistAPIResponse?

    override func viewDidLoad() {
        super.viewDidLoad()
        Util.customizeNavigationBarWithTitle(title: "Wishlist", rightButtons: ["user", "addNew"], rightButtonSelectors:[#selector(HomeViewController.hideHUD), #selector(HomeViewController.hideHUD)], leftButtons: [], leftButtonSelectors:[], forViewController: self)
        self.callLoginAPI()
    }
}

extension WishlistViewController {
    func callLoginAPI() {
        showHUD()
        LoginAPIManager.loginUser() { (response, error) in
            print("AHSJSHDKAHDKJAHSDKAHSDKHASDKJHS***********")
            print("session id \(response)")
            AppDelegate.application().sessionId = response
            self.callWishlistAPI()
        }
    }

    func callWishlistAPI() {
        print(AppDelegate.application().sessionId!)
        GetWishlistAPIManager.getWishlist(sessionId: AppDelegate.application().sessionId!, emailId: "vishnuvardhanpv@gmail.com") { (response, error) in
            print(response)
            self.wishListResponse = response
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.hideHUD()
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
}

extension WishlistViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let data = wishListResponse {
            return data.data!.count
        } else {
            return 0
        }
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"WishlistCustomCell", for: indexPath) as! WishlistCustomCell
        let wishListProduct: WishlistProduct = (wishListResponse! as GetWishlistAPIResponse).data! [indexPath.row]
        cell.wishlistProduct = wishListProduct
        cell.addToCartAction = { product in
            print(product)
        }
        cell.deleteAction = { product in
            print(product)
        }
        return cell
    }
}
