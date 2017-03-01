 //
//  SubCategoryViewController.swift
//  HostsShop
//
//  Created by Vishnu Vardhan PV on 06/01/17.
//  Copyright © 2017 vishnuvardhanpv. All rights reserved.
//

import Foundation

class SubCategoryViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!

    var category: Category?
    var dataResponse: Any?
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeNavigationBar()
    }

    override func customizeNavigationBar() {
        Util.customizeNavigationBarWithTitle(title: category?.title, rightButtons: ["user", "addNew", "search", "search"], rightButtonSelectors:[#selector(HomeViewController.hideHUD), #selector(HomeViewController.hideHUD), #selector(HomeViewController.hideHUD), #selector(self.addSearchBar)], leftButtons: [], leftButtonSelectors:[#selector(HomeViewController.showSideMenu)], forViewController: self)
    }
}

extension SubCategoryViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SubCategoryToProduct" {
            let category: Catalogue = (sender as? Catalogue)!
            print(category.name!)
            print(category.catalogueId!)
            let productsView = segue.destination as! ProductsViewController
            productsView.catagoryId = category.catalogueId
            productsView.catagoryName = category.name
        } else if segue.identifier == "SubCategoryDirectlyToProduct" {
            let productsView = segue.destination as! ProductsViewController
            productsView.catagoryId = category?.categoryId
            productsView.catagoryName = category?.title
            productsView.dataResponse = (sender as? SubCategoryProductResponse)!
        } else if segue.identifier == "SearchResultsViewSegue" {
            let searchView = segue.destination as! SearchResultsViewController
            searchView.searchString = self.searchBar.text
        }
    }
}

extension SubCategoryViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let data = dataResponse {
            return (data as! CatalogueDataResponse).data!.count
        } else {
            return 0
        }
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        let catelogue: Catalogue = (dataResponse as! CatalogueDataResponse).data! [indexPath.row]
        cell.textLabel?.text = catelogue.name
        return cell
    }
}

extension SubCategoryViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let catelogue: Catalogue = (dataResponse as! CatalogueDataResponse).data! [indexPath.row]
        self.performSegue(withIdentifier: "SubCategoryToProduct", sender: catelogue)
    }
}
