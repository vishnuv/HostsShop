//
//  ProductDetailViewController.swift
//  HostsShop
//
//  Created by Vishnu Vardhan PV on 10/01/17.
//  Copyright © 2017 vishnuvardhanpv. All rights reserved.
//

import Foundation
import ObjectMapper
import SwiftyJSON

enum SelectedSegment: Int {
    case Highlights, AdditionalInfo
}

private enum QuantityPicker {
    static let pickerHeight:CGFloat = 220
    static let DoneTitle = "Done"
    static let CancelTitle = "Cancel"
}

class ProductDetailViewController: BaseViewController {
    var productDetail: ProductDetail?
    var segment: SelectedSegment = .Highlights
    var selectedQuantity = "Qty 1"
    var selectQuantityPicker: UIPickerView!
    var pickerData = [String]()
    var containerView = UIView()

    @IBOutlet var tableView: UITableView?

    override func viewDidLoad() {
        super.viewDidLoad()
        customizeNavigationBar()
        self.callGetProductDataAPI()
        pickerData = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5", "Item 6"]
        initialisePicker()
    }

    override func customizeNavigationBar() {
        Util.customizeNavigationBarWithTitle(title: "Apna Kirana", rightButtons: ["user", "addNew", "search", "search"], rightButtonSelectors:[#selector(HomeViewController.hideHUD), #selector(HomeViewController.hideHUD), #selector(HomeViewController.hideHUD), #selector(self.addSearchBar)], leftButtons: [], leftButtonSelectors:[#selector(HomeViewController.showSideMenu)], forViewController: self)
        self.navigationController?.navigationBar.barTintColor = UIColor.init(colorLiteralRed: 202.0/255.0, green: 224.0/255.0, blue: 51.0/255.0, alpha: 1)
    }
}

extension ProductDetailViewController {

    func callGetProductDataAPI() {
        GetProductDataAPIManager.getProductData(productId: (productDetail?.productId)!, sessionId: AppDelegate.application().sessionId!) { (response, error) in
//            print((response?.data!.optionData?.count)!)
//            if let responseData = response, (response?.data!.optionData?.count)! > 0 {
//                let optionData: OptionData = responseData.data!.optionData![0]
//                print(optionData.values!)
//            }
        }
    }

    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }


    func segmentAction(sender: UISegmentedControl) {
//        sender.setImage(UIImage.init(named: "wishList"), forSegmentAt: sender.selectedSegmentIndex)
//        sender.setImage(UIImage.init(named: "addToCart"), forSegmentAt: abs(sender.selectedSegmentIndex - 1))
        segment = SelectedSegment.init(rawValue: sender.selectedSegmentIndex)!
        self.tableView?.reloadRows(at: [IndexPath(row:4, section:0)], with: .none)

    }

    func initialisePicker() {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.frame = CGRect(x:0, y:0, width: self.view.frame.size.width, height:toolBar.frame.size.height)
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(title:QuantityPicker.DoneTitle, style: UIBarButtonItemStyle.plain, target: self, action: #selector(ProductDetailViewController.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title:QuantityPicker.CancelTitle, style: UIBarButtonItemStyle.plain, target: self, action: #selector(ProductDetailViewController.hidePickerView))

        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true

        self.selectQuantityPicker = UIPickerView(frame: CGRect(x:0, y:toolBar.frame.size.height, width:self.view.frame.width, height:QuantityPicker.pickerHeight))
        self.selectQuantityPicker.backgroundColor = UIColor.white
        self.selectQuantityPicker.showsSelectionIndicator = true
        self.selectQuantityPicker.delegate = self
        self.selectQuantityPicker.dataSource = self

        self.containerView = UIView.init(frame: CGRect(x:0, y:self.view.frame.size.height, width:self.view.frame.size.width, height:self.selectQuantityPicker.frame.size.height))
        containerView.addSubview(toolBar)
        containerView.addSubview(self.selectQuantityPicker)
        self.view.addSubview(containerView)
    }

    func donePicker() {
        print("\(self.pickerData[self.selectQuantityPicker.selectedRow(inComponent: 0)])")
        selectedQuantity = self.pickerData[self.selectQuantityPicker.selectedRow(inComponent: 0)]
        self.tableView?.reloadRows(at: [IndexPath(row:5, section:0)], with: .none)
        hidePickerView()
    }

    func showPickerView() {
        UIView.animate(withDuration: 0.25) {
            var temp = self.containerView.frame;
            temp.origin.y = self.view.frame.size.height-(self.selectQuantityPicker.frame.size.height)
            self.containerView.frame = temp;
        }
    }

    func hidePickerView() {
        UIView.animate(withDuration: 0.25) {
            var temp = self.containerView.frame;
            temp.origin.y = self.view.frame.size.height
            self.containerView.frame = temp;
        }
    }

    func selectQuantity() {
        print("tapped selectQuantity")
        showPickerView()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SearchResultsViewSegue" {
            let searchView = segue.destination as! SearchResultsViewController
            searchView.searchString = self.searchBar.text
        }
    }
}

extension ProductDetailViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let largeImageCell = tableView.dequeueReusableCell(withIdentifier: "LargeImageCell", for: indexPath) as UITableViewCell
            let largeImage = largeImageCell.viewWithTag(100) as? UIImageView
            largeImage?.af_setImage(withURL: URL(string: (productDetail?.image!)!)!)
            return largeImageCell
        } else if indexPath.row == 1 {
            let smallImageCell = tableView.dequeueReusableCell(withIdentifier: "SmallImageCell", for: indexPath) as UITableViewCell
            let smallImage = smallImageCell.viewWithTag(100) as? UIImageView
            smallImage?.af_setImage(withURL: URL(string: (productDetail?.image!)!)!)
            return smallImageCell
        } else if indexPath.row == 2 {
            let productDetailsCell = tableView.dequeueReusableCell(withIdentifier: "ProductDetailsCell", for: indexPath) as! ProductDetailsCell
            productDetailsCell.productDetail = self.productDetail
            return productDetailsCell
        } else if indexPath.row == 3 {
            let segmentedCell = tableView.dequeueReusableCell(withIdentifier: "SegmentedCell", for: indexPath) as UITableViewCell
            let segment = segmentedCell.viewWithTag(100) as? UISegmentedControl
            segment?.addTarget(self, action: #selector(segmentAction), for: .valueChanged)
            let frame: CGRect = CGRect(x:0,y:0,width:segmentedCell.frame.size.width,height:50)
            segment?.frame = frame
            return segmentedCell
        } else if indexPath.row == 4 {
            if segment == .Highlights {
                let highlightsCell = tableView.dequeueReusableCell(withIdentifier: "HighlightsCell", for: indexPath) as UITableViewCell
                let label = highlightsCell.viewWithTag(100) as? UILabel
                label?.text = self.productDetail?.name
                return highlightsCell
            } else {
                let additionalInfoCell = tableView.dequeueReusableCell(withIdentifier: "AdditionalInfoCell", for: indexPath) as UITableViewCell
                let label1 = additionalInfoCell.viewWithTag(100) as? UILabel
                label1?.text = "Product Weight : "+(self.productDetail?.shortDescription)!
                let label2 = additionalInfoCell.viewWithTag(101) as? UILabel
                label2?.text = "Brand : No"
                return additionalInfoCell
            }
        } else {
            let selectQuantityCell = tableView.dequeueReusableCell(withIdentifier: "SelectQuantityCell", for: indexPath) as! SelectQuantityCell
            selectQuantityCell.quantityLabel?.text = selectedQuantity
            selectQuantityCell.quantityButton?.addTarget(self, action: #selector(selectQuantity), for: .touchUpInside)
            return selectQuantityCell
        }
    }
}

extension ProductDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 228.0
        } else if indexPath.row == 1 {
            return 96.0
        } else if indexPath.row == 2 {
            return 122.0
        } else if indexPath.row == 5 {
            return 80.0
        } else {
            return 50.0
        }
    }
}

extension ProductDetailViewController: UIPickerViewDataSource {

    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerData.count
    }
}

extension ProductDetailViewController: UIPickerViewDelegate {
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pickerData[row]
    }

    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("\(self.pickerData[row])")
    }
}
