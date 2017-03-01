//
//  ProductsViewController.swift
//  HostsShop
//
//  Created by Vishnu Vardhan PV on 07/01/17.
//  Copyright © 2017 vishnuvardhanpv. All rights reserved.
//

import Foundation

fileprivate enum ListingStyle: Int {
    case collectionView, tableView
}

class ProductsViewController: BaseViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!

//    var catalogue: Catalogue?

    var catagoryId: String?
    var catagoryName: String?

    var dataResponse: Any?
    fileprivate var listingStyle: ListingStyle?
    var sortBy = SortBy.asc
    var sortOption: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        customizeNavigationBar()
        listingStyle = ListingStyle.collectionView
        collectionView.isHidden = false
        tableView.isHidden = true

        // set dataresponse from previous view
        if self.dataResponse != nil {
                self.collectionView.reloadData()
                self.tableView.reloadData()
        } else {
            self.callSubCategoryAPI()
        }
    }

    override func customizeNavigationBar() {
        Util.customizeNavigationBarWithTitle(title: catagoryName!, rightButtons: ["user", "addNew", "search", "search"], rightButtonSelectors:[#selector(HomeViewController.hideHUD), #selector(HomeViewController.hideHUD), #selector(HomeViewController.hideHUD), #selector(self.addSearchBar)], leftButtons: [], leftButtonSelectors:[#selector(HomeViewController.showSideMenu)], forViewController: self)
        self.navigationController?.navigationBar.barTintColor = UIColor.init(colorLiteralRed: 202.0/255.0, green: 224.0/255.0, blue: 51.0/255.0, alpha: 1)
    }
}

extension ProductsViewController {
    func callSubCategoryAPI() {
        self.showHUD()
        print(AppDelegate.application().sessionId!)
        CatalogueDataAPIManager.getCatalogueData(sessionId: AppDelegate.application().sessionId!, categoryId:catagoryId!, sortBy: sortBy, sortOption: sortOption) { (response, error) in
            print(response)
            if response is SubCategoryProductResponse {
                self.dataResponse = response
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.tableView.reloadData()
                }
            }
            self.hideHUD()
        }
    }

    @IBAction func tappedlistingStyleButton() {
        listingStyle = listingStyle == ListingStyle.collectionView ? ListingStyle.tableView:ListingStyle.collectionView
        if listingStyle == .collectionView {
            collectionView.isHidden = false
            tableView.isHidden = true
        } else {
            tableView.isHidden = false
            collectionView.isHidden = true
        }
    }

    @IBAction func tappedAscDscSortButton() {
        sortBy = sortBy == SortBy.asc ? SortBy.dsc: SortBy.asc
        callSubCategoryAPI()
    }

    @IBAction func tappedSortButton() {
        let alert = UIAlertController(title: "SORT BY", message: nil, preferredStyle: .actionSheet)
        if let sort = dataResponse, ((dataResponse as! SubCategoryProductResponse).sortingOptions?.count)! > 0 {
            for option: SortingOption in ((sort as! SubCategoryProductResponse).sortingOptions)! {
                alert.addAction(UIAlertAction(title: option.label, style: .default) { action in
                    self.sortOption = option.value!
                    self.callSubCategoryAPI()
                })
            }
            alert.addAction(UIAlertAction(title: "Cancel", style: .default) { action in
                alert.dismiss(animated: true, completion: { 
                })
            })
        }
        self.present(alert, animated:true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProductDetailSegue" {
            let pro: ProductDetail = (sender as? ProductDetail)!
            let detailView = segue.destination as! ProductDetailViewController
            detailView.productDetail = pro
            print(pro.productId)
        } else if segue.identifier == "SearchResultsViewSegue" {
            let searchView = segue.destination as! SearchResultsViewController
            searchView.searchString = self.searchBar.text
        }
    }

    func callAPIToAddToCart(productId: String) {
        self.showHUD()
        AddToCartAPIManager.addToCart(productId: productId, email: "vishnuvardhanpv@gmail.com", sessionId: AppDelegate.application().sessionId!) { (response, error) in
            if let data = response {
                Util.showAlertWithTitle(title: "", message: data["message"]!, forViewController: self, okButtonAction: {
                })
            }
            self.hideHUD()
        }
    }
    func callAPIToAddToWishlist(productId: String) {
        self.showHUD()
        AddToWishlistAPIManager.addToWishlist(productId: productId, type: "product", email: "vishnuvardhanpv@gmail.com", sessionId: AppDelegate.application().sessionId!) { (response, error) in
            if let data = response {
                Util.showAlertWithTitle(title: "", message: data["message"]!, forViewController: self, okButtonAction: {
                })
            }
            self.hideHUD()
        }
    }
}

extension ProductsViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let cat = dataResponse, ((dataResponse as! SubCategoryProductResponse).data?.count)! > 0 {
            return ((cat as! SubCategoryProductResponse).data?.count)!
        } else {
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"ProductsCollectionViewCell", for: indexPath) as! ProductsCollectionViewCell
        cell.productDetail = (dataResponse as! SubCategoryProductResponse).data?[indexPath.row]
        cell.addToCartCallBack = { productId in
            self.callAPIToAddToCart(productId: productId)
        }
        cell.addToWishlistCallBack = { productId in
            self.callAPIToAddToWishlist(productId: productId)
        }
        return cell
    }
}

extension ProductsViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pro: ProductDetail = ((dataResponse as! SubCategoryProductResponse).data?[indexPath.row])!
        self.performSegue(withIdentifier: "ProductDetailSegue", sender: pro)
    }
}

extension ProductsViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let cat = dataResponse, ((dataResponse as! SubCategoryProductResponse).data?.count)! > 0 {
            return ((cat as! SubCategoryProductResponse).data?.count)!
        } else {
            return 0
        }
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductsListViewCell", for: indexPath) as! ProductsListViewCell
        cell.productDetail = (dataResponse as! SubCategoryProductResponse).data?[indexPath.row]
        return cell
    }
}

extension ProductsViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 98.0
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let catelogue: Catalogue = (dataResponse as! CatalogueDataResponse).data! [indexPath.row]
//        self.performSegue(withIdentifier: "SubCategoryToProduct", sender: catelogue)
    }
}
