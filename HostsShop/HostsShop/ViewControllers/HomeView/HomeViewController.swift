//
//  HomeViewController.swift
//  HostsShop
//
//  Created by Vishnu Vardhan PV on 29/12/16.
//  Copyright © 2016 vishnuvardhanpv. All rights reserved.
//

import Foundation
import UIKit
import KRProgressHUD
import SideMenu
import MarqueeLabel
import AlamofireImage

class HomeViewController: BaseViewController {

    @IBOutlet var tableView: UITableView?
    var homePageResponse: HomePageResponse?
    var isFirstAppearance: Bool?
    var subCategoryDataResponse: Any?

    override func viewDidLoad() {
        super.viewDidLoad()
        isFirstAppearance = true
        customizeNavigationBar()
        callLoginAPI()
        SideMenuManager.menuPresentMode = .menuSlideIn
        SideMenuManager.menuFadeStatusBar = false

        NotificationCenter.default.addObserver(self, selector: #selector(sideMenuSelected), name: Notification.Name.sideMenuCategorySelected, object: nil)
    }

    override func customizeNavigationBar() {
        Util.customizeNavigationBarWithTitle(title: "Apna Kirana", rightButtons: ["user", "addNew", "search", "search"], rightButtonSelectors:[#selector(HomeViewController.tappedCartlistButton), #selector(HomeViewController.tappedWishlistButton), #selector(HomeViewController.tappedProfileLogoutButton), #selector(self.addSearchBar)], leftButtons: ["menu"], leftButtonSelectors:[#selector(HomeViewController.showSideMenu)], forViewController: self)
        self.navigationController?.navigationBar.barTintColor = UIColor.init(colorLiteralRed: 202.0/255.0, green: 224.0/255.0, blue: 51.0/255.0, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isFirstAppearance! {
            self.showHUD()
            isFirstAppearance = false
        }
    }
}

extension HomeViewController {

    func sideMenuSelected(notification:NSNotification) {
        print(notification.userInfo?["catalogue"]!)
        let catalogue:Catalogue = notification.userInfo?["catalogue"]! as! Catalogue
        print(catalogue)
        let category: Category = Category()
        category.categoryId = catalogue.catalogueId!
        category.title = catalogue.name!
        print(category.title!)
        self.callSubCategoryAPI(category: category)

    }

    func callLoginAPI() {
        LoginAPIManager.loginUser() { (response, error) in
            print("AHSJSHDKAHDKJAHSDKAHSDKHASDKJHS***********")
            print("session id \(response)")
            AppDelegate.application().sessionId = response
            self.callGetHomePageAPI()
        }
    }

    func callGetHomePageAPI() {
        GetHomePageAPIManager.getHomePage(sessionId: AppDelegate.application().sessionId!) { (response, error) in
            self.homePageResponse = response

            DispatchQueue.main.async {
                self.tableView?.reloadData()
            }
            // Side Menu API
            self.callGetCatalogueDataAPI()
        }
    }

    func callGetCatalogueDataAPI() {
        CatalogueDataAPIManager.getCatalogueData(sessionId: AppDelegate.application().sessionId!) { (response, error) in
            AppDelegate.application().catalogueData = (response as! CatalogueDataResponse).data
            self.hideHUD()
        }
    }

    func callSubCategoryAPI(category: Category) {
        self.showHUD()
        print(AppDelegate.application().sessionId!)
        CatalogueDataAPIManager.getCatalogueData(sessionId: AppDelegate.application().sessionId!, categoryId:category.categoryId!) { (response, error) in
            print(response)
            self.subCategoryDataResponse = response
            if response is CatalogueDataResponse {
                print("*****HSHSHSHSHHS******")
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "DetailViewSegue", sender: category)
                }
            } else {
                print("*****GGGGGGG******")
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "SubCategoryDirectlyToProduct", sender: category)
                }
            }
            self.hideHUD()
        }
    }

    func tappedWishlistButton() {
        self.performSegue(withIdentifier: "WishlistSegue", sender: nil)
    }

    func tappedCartlistButton() {
        self.performSegue(withIdentifier: "CartlistSegue", sender: nil)
    }

    func showSideMenu() {
        self.performSegue(withIdentifier: "showSideMenu", sender: nil)

    }

    override func showHUD() {
        KRProgressHUD.set(style:.black)
        KRProgressHUD.show()
    }

    override func hideHUD() {
        KRProgressHUD.dismiss()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailViewSegue" {
            let category: Category = (sender as? Category)!
            let detailView = segue.destination as! SubCategoryViewController
            detailView.category = category
            detailView.dataResponse = subCategoryDataResponse
        } else if segue.identifier == "SearchResultsViewSegue" {
            let searchView = segue.destination as! SearchResultsViewController
            searchView.searchString = self.searchBar.text
        } else if segue.identifier == "SubCategoryDirectlyToProduct" {
            let category: Category = (sender as? Category)!
            let productsView = segue.destination as! ProductsViewController
            productsView.catagoryId = category.categoryId
            productsView.catagoryName = category.title
            productsView.dataResponse = subCategoryDataResponse
        }
    }
}

extension HomeViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let response = homePageResponse, (homePageResponse?.products?.count)! > 0 {
            return 4 + (response.products?.count)!
        } else {
            return 4
        }
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let flashMessageCell = tableView.dequeueReusableCell(withIdentifier: "FlashMessageCell", for: indexPath) as UITableViewCell
            let marqueeLabel = flashMessageCell.viewWithTag(100) as? MarqueeLabel
            if let response = homePageResponse {
                let array:[Banner] = response.flashMessage!
                let messages = array.map { $0.title }
                var flashMessage: String = ""
                for string in messages {
                    flashMessage.append(string!)
                    flashMessage.append("          ")
                }
                marqueeLabel?.text = flashMessage
                marqueeLabel?.restartLabel()
            }
            return flashMessageCell
        } else if indexPath.row == 1 {
            let homeViewBannerCell: HomeViewBannerCell! = tableView.dequeueReusableCell(withIdentifier:"HomeViewBannerCell") as? HomeViewBannerCell
            if let response = homePageResponse {
                homeViewBannerCell.setCellData(banners: (response.mainBanner)!)
            }
            return homeViewBannerCell
        } else if indexPath.row == 2 {
            let topCategoriesCell = tableView.dequeueReusableCell(withIdentifier:"TopCategoriesCell") as? TopCategoriesCell
            if let response = homePageResponse?.topCategories {
                topCategoriesCell?.topCategories = response.topCategories
                topCategoriesCell?.categoriesCallBack = { category in
                    print(category.title!)
                    self.callSubCategoryAPI(category: category)
                }
            }
            return topCategoriesCell!
        } else if indexPath.row == 3 {
            if let response = homePageResponse?.products, (homePageResponse?.products?.count)! > 0 {
                let productsCell = tableView.dequeueReusableCell(withIdentifier: "ProductsCell", for: indexPath) as! ProductsCell
                productsCell.products = response[0]
                return productsCell
            } else {
                let staticBannerCell = tableView.dequeueReusableCell(withIdentifier: "StaticBannerCell", for: indexPath) as UITableViewCell
                let staticBannerImage = staticBannerCell.viewWithTag(100) as? UIImageView
                if let response = homePageResponse {
                    let banner: Banner = response.staticBanner![0]
                    staticBannerImage?.af_setImage(withURL: URL(string: banner.image!)!)
                }
                return staticBannerCell
            }
        } else if indexPath.row == 4 {
            let staticBannerCell = tableView.dequeueReusableCell(withIdentifier: "StaticBannerCell", for: indexPath) as UITableViewCell
            let staticBannerImage = staticBannerCell.viewWithTag(100) as? UIImageView
            if let response = homePageResponse {
                let banner: Banner = response.staticBanner![0]
                staticBannerImage?.af_setImage(withURL: URL(string: banner.image!)!)
            }
            return staticBannerCell
        } else {
            let productsCell = tableView.dequeueReusableCell(withIdentifier: "ProductsCell", for: indexPath) as! ProductsCell
            if let response = homePageResponse?.products {
                productsCell.products = response[indexPath.row - 4]
            }
            return productsCell
        }
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 35.0
        } else if indexPath.row == 1 {
            return 185.0
        } else if indexPath.row == 2 {
            return 215.0
        } else if indexPath.row == 3 {
            if let _ = homePageResponse?.products, (homePageResponse?.products?.count)! > 0 {
                return 280.0
            } else {
                return 150.0
            }
        } else if indexPath.row == 4 {
            return 150.0
        } else {
            return 280.0
        }
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}
