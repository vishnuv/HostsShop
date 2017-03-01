//
//  SearchResultsViewController.swift
//  HostsShop
//
//  Created by Vishnu Vardhan PV on 22/02/17.
//  Copyright © 2017 vishnuvardhanpv. All rights reserved.
//

import Foundation

class SearchResultsViewController: BaseViewController {

    var searchString: String?
    var dataResponse: Any?
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = false
        customizeNavigationBar()
        callSearchAPI()
    }

    override func customizeNavigationBar() {
        Util.customizeNavigationBarWithTitle(title: searchString!, rightButtons: ["user", "addNew", "search", "search"], rightButtonSelectors:[#selector(HomeViewController.tappedCartlistButton), #selector(HomeViewController.tappedWishlistButton), #selector(HomeViewController.tappedProfileLogoutButton), #selector(self.addSearchBar)], leftButtons: [], leftButtonSelectors:[], forViewController: self)
    }
}

extension SearchResultsViewController {
    func callSearchAPI() {
        self.showHUD()
        print(AppDelegate.application().sessionId!)
//        CatalogueDataAPIManager.getCatalogueData(sessionId: AppDelegate.application().sessionId!, categoryId:"4", sortBy: SortBy(rawValue: "asc"), sortOption: "") { (response, error) in
//            print(response)
//            if response is SubCategoryProductResponse {
//                self.dataResponse = response
//                DispatchQueue.main.async {
//                    self.collectionView.reloadData()
//                }
//            }
//            self.hideHUD()
//        }

        SearchAPIManager.getSearchedData(sessionId: AppDelegate.application().sessionId!, searchTerm: searchString!) { (response, error) in
            if response is SubCategoryProductResponse {
                self.dataResponse = response
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
            self.hideHUD()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SearchResultsProductDetailSegue" {
            let pro: ProductDetail = (sender as? ProductDetail)!
            let detailView = segue.destination as! ProductDetailViewController
            detailView.productDetail = pro
            print(pro.productId)
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

    override public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //        searchActive = true
        print("Search tapped ..........****")
        searchString = self.searchBar.text
        callSearchAPI()
    }

    override public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //        searchActive = false;
        customizeNavigationBar()
    }
}

extension SearchResultsViewController : UICollectionViewDataSource {
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

extension SearchResultsViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pro: ProductDetail = ((dataResponse as! SubCategoryProductResponse).data?[indexPath.row])!
        self.performSegue(withIdentifier: "SearchResultsProductDetailSegue", sender: pro)
    }
}

//extension SearchResultsViewController: UISearchBarDelegate {
//    override public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        //        searchActive = true
//    }
//    override public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//
//    }
//    override public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        //        searchActive = true
//        print("Search tapped ..........****")
//        self.performSegue(withIdentifier: "SearchResultsViewSegue", sender: nil)
//    }
//    override public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        //        searchActive = false;
//        customizeNavigationBar()
//    }
//}
