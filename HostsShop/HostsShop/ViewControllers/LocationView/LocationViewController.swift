//
//  LocationViewController.swift
//  HostsShop
//
//  Created by Vishnu Vardhan PV on 16/02/17.
//  Copyright © 2017 vishnuvardhanpv. All rights reserved.
//

import Foundation
import KRProgressHUD

private enum PickerConstants {
    static let pickerHeight:CGFloat = 220
    static let DoneTitle = "Done"
    static let CancelTitle = "Cancel"
}

enum PickerTypes {
    case countryType
    case regionType
    case cityType
    case pincodeType
}

class LocationViewController: UITableViewController {
    var country: Country?
    var region: Region?
    var city: City?
    var pin: Pincode?
    var countryRegionPicker: UIPickerView!
    var countryPickerData = [Country]()
    var regionPickerData = [Region]()
    var cityPickerData = [City]()
    var pincodePickerData = [Pincode]()
    var containerView = UIView()
    var pickerType: PickerTypes?
    var enableRegionTap: Bool = false
    var enableCityTap: Bool = false
    var enablePincodeTap: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        Util.customizeNavigationBarWithTitle(title: "Apna Kirana", rightButtons: [], rightButtonSelectors:[], leftButtons: [], leftButtonSelectors:[], forViewController: self)
        self.navigationController?.navigationBar.barTintColor = UIColor.init(colorLiteralRed: 202.0/255.0, green: 224.0/255.0, blue: 51.0/255.0, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        self.navigationItem.setHidesBackButton(true, animated: false)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        callLoginAPI()
    }
}

extension LocationViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TitleCell", for: indexPath) as UITableViewCell
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextViewButtonCell", for: indexPath) as! CheckoutTextViewCell
            cell.textView.placeholder = "Country"
//            cell.textViewButton.addTarget(self, action: #selector(tappedCountryButton), for: .touchUpInside)
            cell.pickerButtonAction = {
                self.tappedCountryButton()
            }
            if let countryName = country {
                cell.textView.text = countryName.label
            }
            return cell
        case 2:
            if enableRegionTap {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TextViewButtonCell", for: indexPath) as! CheckoutTextViewCell
                cell.textView.placeholder = "State"
//                cell.textViewButton.addTarget(self, action: #selector(tappedRegionButton), for: .touchUpInside)
                cell.pickerButtonAction = {
                    self.tappedRegionButton()
                }
                if let regionName = region {
                    cell.textView.text = regionName.name
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TextViewCell", for: indexPath) as! CheckoutTextViewCell
                cell.textView.placeholder = "State"
                region?.name = cell.textView.text
                return cell
            }
        case 3:
            if enableCityTap {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TextViewButtonCell", for: indexPath) as! CheckoutTextViewCell
                cell.textView.placeholder = "City"
//                cell.textViewButton.addTarget(self, action: #selector(tappedCityButton), for: .touchUpInside)
                cell.pickerButtonAction = {
                    self.tappedCityButton()
                }
                if let cityName = city {
                    cell.textView.text = cityName.name
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TextViewCell", for: indexPath) as! CheckoutTextViewCell
                cell.textView.placeholder = "City"
                city?.name = cell.textView.text
                return cell
            }
        case 4:
            if enablePincodeTap {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TextViewButtonCell", for: indexPath) as! CheckoutTextViewCell
                cell.textView.placeholder = "Zip"
//                cell.textViewButton.addTarget(self, action: #selector(tappedPincodeButton), for: .touchUpInside)
                cell.pickerButtonAction = {
                    self.tappedPincodeButton()
                }
                if let pinCode = pin {
                    cell.textView.text = pinCode.zipcode
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TextViewCell", for: indexPath) as! CheckoutTextViewCell
                cell.textView.placeholder = "Zip"
                pin?.zipcode = cell.textView.text
                return cell
            }
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath) as UITableViewCell
            let submitButton: UIButton = cell.viewWithTag(100) as! UIButton
            submitButton.addTarget(self, action: #selector(tappedSubmitButton), for: .touchUpInside)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath) as UITableViewCell
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72.0
    }
}

extension LocationViewController {
    @IBAction func tappedCountryButton() {
        self.view.endEditing(true)
        pickerType = .countryType
        initialisePicker()
        showPickerView()
    }

    @IBAction func tappedRegionButton() {
        self.view.endEditing(true)
        pickerType = .regionType
        initialisePicker()
        showPickerView()
    }

    @IBAction func tappedCityButton() {
        self.view.endEditing(true)
        pickerType = .cityType
        initialisePicker()
        showPickerView()
    }

    @IBAction func tappedPincodeButton() {
        self.view.endEditing(true)
        pickerType = .pincodeType
        initialisePicker()
        showPickerView()
    }

    @IBAction func tappedSubmitButton() {
        print("tappedSubmitButton")

//        print(country?.value!, region?.name!, city?.name!, pin?.zipcode!)
        validateData()
    }

    func validateData() {
        if hasNoValue(property:country?.label) {
            showValidationAlertFor(property: (#keyPath(country) as String).differentCamelCaps)
        } else if hasNoValue(property:region?.name) {
            showValidationAlertFor(property: (#keyPath(region) as String).differentCamelCaps)
        } else if hasNoValue(property:city?.name) {
            showValidationAlertFor(property: (#keyPath(city) as String).differentCamelCaps)
        } else if hasNoValue(property:pin?.zipcode) {
            showValidationAlertFor(property: (#keyPath(pin) as String).differentCamelCaps)
        } else {
            print("******************")
            callAPIToUpdateAddress()
        }
    }

    func hasNoValue(property: String?) -> Bool {
        let trimmedString = property?.trimmingCharacters(in: .whitespaces)
        guard let _ = trimmedString, (trimmedString?.characters.count)! > 0 else {
            print("first name empty trimmed")
            return true
        }
        return false
    }

    func showValidationAlertFor(property: String) {
        Util.showAlertWithTitle(title: "Error", message: "Enter valid \(property)", forViewController: self) {}
    }

    func initialisePicker() {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.frame = CGRect(x:0, y:0, width: self.view.frame.size.width, height:toolBar.frame.size.height)
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(title:PickerConstants.DoneTitle, style: UIBarButtonItemStyle.plain, target: self, action: #selector(CheckoutViewController.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title:PickerConstants.CancelTitle, style: UIBarButtonItemStyle.plain, target: self, action: #selector(CheckoutViewController.hidePickerView))

        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true

        self.countryRegionPicker = UIPickerView(frame: CGRect(x:0, y:toolBar.frame.size.height, width:self.view.frame.width, height:PickerConstants.pickerHeight))
        self.countryRegionPicker.backgroundColor = UIColor.white
        self.countryRegionPicker.showsSelectionIndicator = true
        self.countryRegionPicker.delegate = self
        self.countryRegionPicker.dataSource = self

        self.containerView = UIView.init(frame: CGRect(x:0, y:self.view.frame.size.height, width:self.view.frame.size.width, height:self.countryRegionPicker.frame.size.height))
        containerView.addSubview(toolBar)
        containerView.addSubview(self.countryRegionPicker)
        self.view.addSubview(containerView)
        containerView.isHidden = true
    }

    func donePicker() {
        if pickerType == .countryType {
            print("\(self.countryPickerData[self.countryRegionPicker.selectedRow(inComponent: 0)])")
            country = self.countryPickerData[self.countryRegionPicker.selectedRow(inComponent: 0)]
            self.tableView?.reloadRows(at: [IndexPath(row:1, section:0)], with: .none)
            callAPIToGetRegionCode()
        } else if pickerType == .regionType {
            print("\(self.regionPickerData[self.countryRegionPicker.selectedRow(inComponent: 0)])")
            region = self.regionPickerData[self.countryRegionPicker.selectedRow(inComponent: 0)]
            self.tableView?.reloadRows(at: [IndexPath(row:2, section:0)], with: .none)
            callAPIToGetRegionCities()
        } else if pickerType == .cityType {
            print("\(self.cityPickerData[self.countryRegionPicker.selectedRow(inComponent: 0)])")
            city = self.cityPickerData[self.countryRegionPicker.selectedRow(inComponent: 0)]
            self.tableView?.reloadRows(at: [IndexPath(row:3, section:0)], with: .none)
            callAPIToGetCityPincodes()
        } else if pickerType == .pincodeType {
            print("\(self.pincodePickerData[self.countryRegionPicker.selectedRow(inComponent: 0)])")
            pin = self.pincodePickerData[self.countryRegionPicker.selectedRow(inComponent: 0)]
            self.tableView?.reloadRows(at: [IndexPath(row:4, section:0)], with: .none)
        }
        hidePickerView()
    }

    func showPickerView() {
        containerView.isHidden = false
        UIView.animate(withDuration: 0.25) {
            var temp = self.containerView.frame;
            temp.origin.y = self.view.frame.size.height-(self.countryRegionPicker.frame.size.height)
            self.containerView.frame = temp;
        }
    }

    func hidePickerView() {
        UIView.animate(withDuration: 0.25, animations: {
            var temp = self.containerView.frame;
            temp.origin.y = self.view.frame.size.height
            self.containerView.frame = temp;

        }) { (bool) in
            self.containerView.isHidden = true
        }
    }

    func setCountryInitialValue() {
        let predicate:NSPredicate = NSPredicate(format:"label == \"India\"")
        let subPredicate = [predicate]
        let finalPredicate = NSCompoundPredicate.init(orPredicateWithSubpredicates: subPredicate)

        let filteredArray = (self.countryPickerData as NSArray).filtered(using: finalPredicate) as! [Country]
        if filteredArray.count > 0 {
            country = filteredArray[0] as Country
            DispatchQueue.main.async {
                self.tableView?.reloadRows(at: [IndexPath(row:1, section:0)], with: .none)
            }
        }
    }

    func setRegionInitialValue() {
        let predicate:NSPredicate = NSPredicate(format:"name == \"Uttar Pradesh\"")
        let subPredicate = [predicate]
        let finalPredicate = NSCompoundPredicate.init(orPredicateWithSubpredicates: subPredicate)

        let filteredArray = (self.regionPickerData as NSArray).filtered(using: finalPredicate) as! [Region]
        if filteredArray.count > 0 {
            region = filteredArray[0] as Region
            DispatchQueue.main.async {
                self.tableView?.reloadRows(at: [IndexPath(row:2, section:0)], with: .none)
            }
        }
    }

    func showHUD() {
        KRProgressHUD.set(style:.black)
        KRProgressHUD.show()
    }

    func hideHUD() {
        KRProgressHUD.dismiss()
    }

    func callLoginAPI() {
        showHUD()
        LoginAPIManager.loginUser() { (response, error) in
            print("AHSJSHDKAHDKJAHSDKAHSDKHASDKJHS***********")
            print("session id \(response)")
            AppDelegate.application().sessionId = response
            DispatchQueue.main.async {
                self.callAPIToGetCountryList()
            }
        }
    }

    func callAPIToGetCountryList() {
        GetCountryListAPIManager.getCountryList { (response, error) in
            if response?.count != 0 {
                self.countryPickerData = response!
                self.setCountryInitialValue()
                DispatchQueue.main.async {
                    self.callAPIToGetRegionCode()
                }
            }
        }
    }

    func callAPIToGetRegionCode() {
        GetRegionCodeAPIManager.getRegionCode(countryCode: (country?.value!)!) { (response, error) in
            if let res = response, res.data != nil {
                if res.type != "text" {
                    self.enableRegionTap = true
                    self.regionPickerData = (res.data)!
                    self.setRegionInitialValue()
                    DispatchQueue.main.async {
                        self.callAPIToGetRegionCities()
                    }
                }
            } else {
                self.enableRegionTap = false
                self.enableCityTap = false
                self.enablePincodeTap = false
                DispatchQueue.main.async {
//                    self.tableView?.reloadRows(at: [IndexPath(row:2, section:0)], with: .none)
                    self.tableView.reloadData()
                }
                self.hideHUD()
            }
        }
    }

    func callAPIToGetRegionCities() {
        GetRegionCitiesAPIManager.getRegionCities(regionId: (self.region?.regionId)!, sessionId: AppDelegate.application().sessionId!) { (response, error) in
            if let res = response, res.data != nil {
                if res.type != "text" {
                    self.enableCityTap = true
                    self.cityPickerData = (res.data)!
                    self.city = self.cityPickerData[0]
                    DispatchQueue.main.async {
                        self.callAPIToGetCityPincodes()
                        self.tableView?.reloadRows(at: [IndexPath(row:3, section:0)], with: .none)
                    }
                }
            } else {
                self.enableCityTap = false
                self.enablePincodeTap = false
                DispatchQueue.main.async {
                    //                    self.tableView?.reloadRows(at: [IndexPath(row:2, section:0)], with: .none)
                    self.tableView.reloadData()
                }
                self.hideHUD()
            }
        }
    }

    func callAPIToGetCityPincodes() {
        GetCityPincodesAPIManager.getCityPincodes(cityId: (self.city?.cityId)!, sessionId: AppDelegate.application().sessionId!) { (response, error) in
            if let res = response, res.data != nil {
                if res.type != "text" {
                    self.enablePincodeTap = true
                    self.pincodePickerData = (response?.data)!
                    self.pin = self.pincodePickerData[0]
                    DispatchQueue.main.async {
                        self.tableView?.reloadRows(at: [IndexPath(row:4, section:0)], with: .none)
                        self.hideHUD()
                    }
                }
            } else {
                self.enablePincodeTap = false
                DispatchQueue.main.async {
                    self.tableView?.reloadRows(at: [IndexPath(row:4, section:0)], with: .none)
                }
                self.hideHUD()
            }
        }
    }

    func callAPIToUpdateAddress() {
        showHUD()
        UpdateCustomerAddressAPIManager.updateCustomerAddress(sessionId: AppDelegate.application().sessionId!, countryId: (country?.value)!, region: (region?.name)!, city: (city?.name)!, pincode: (pin?.zipcode)!) { (response, error) in
            self.hideHUD()
            Util.showAlertWithTitle(title: (response?["status"])!, message: (response?["message"])!, forViewController: self, okButtonAction: {
                if response?["status"] == "success" {
                    // move to home
                    let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                    let homeView = storyboard.instantiateViewController(withIdentifier: "HomeNavigationController") as! UINavigationController
                    AppDelegate.application().window?.rootViewController = homeView
                }
            })
        }
    }

    func setTextViewData(textView:UITextView) {
        let cell = textView.superview?.superview as? UITableViewCell
        let indexPathOfCell = self.tableView?.indexPath(for: cell!)
        switch indexPathOfCell!.row {
        case 2:
            region?.name = textView.text
        case 3:
            city?.name = textView.text
        case 4:
            pin?.zipcode = textView.text
        default:
            print("Invalid")
        }
    }
}

extension LocationViewController: UIPickerViewDataSource {

    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerType == .countryType {
            return self.countryPickerData.count
        } else if pickerType == .regionType {
            return self.regionPickerData.count
        } else if pickerType == .cityType {
            return self.cityPickerData.count
        } else {
            return self.pincodePickerData.count
        }
    }
}

extension LocationViewController: UIPickerViewDelegate {
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerType == .countryType {
            let countryObj = self.countryPickerData[row]
            return countryObj.label
        } else if pickerType == .regionType {
            let regionObj = self.regionPickerData[row]
            return regionObj.name
        } else if pickerType == .cityType {
            let cityObj = self.cityPickerData[row]
            return cityObj.name
        } else {
            let pincodeObj = self.pincodePickerData[row]
            return pincodeObj.zipcode
        }
    }
}

extension LocationViewController: UITextViewDelegate {
    public func textViewDidChange(_ textView: UITextView) {
        print("############## "+textView.text)
        setTextViewData(textView: textView)
    }
}
