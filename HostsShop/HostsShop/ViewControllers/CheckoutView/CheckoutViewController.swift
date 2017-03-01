//
//  CheckoutViewController.swift
//  HostsShop
//
//  Created by Vishnu Vardhan PV on 18/01/17.
//  Copyright © 2017 vishnuvardhanpv. All rights reserved.
//

import Foundation
import KRProgressHUD

private enum PickerConstants {
    static let pickerHeight:CGFloat = 220
    static let DoneTitle = "Done"
    static let CancelTitle = "Cancel"
}

enum PickerType {
    case countryType
    case regionType
    case cityType
    case pincodeType
}

class CheckoutViewController: UITableViewController {
    var firstName: String?
    var lastName: String?
    var address1: String?
    var address2: String?
    var contactNumber: String?
    var email: String?

    var country: Country?
    var region: Region?
    var city: City?
    var pin: Pincode?
    var countryRegionPicker: UIPickerView!
    var countryPickerData = [Country]()
    var regionPickerData = [Region]()
    var cityPickerData = [City]()
    var pincodePickerData = [Pincode]()

    var enableRegionTap: Bool = false
    var enableCityTap: Bool = false
    var enablePincodeTap: Bool = false
    var initialLoad: Bool = true

    @IBOutlet weak var countryButton: UIButton!

    var containerView = UIView()
    var pickerType: PickerType?
    var addressList: [GetShippingAddress]?

    override func viewDidLoad() {
         super.viewDidLoad()
        Util.customizeNavigationBarWithTitle(title: "Checkout", rightButtons: [], rightButtonSelectors:[], leftButtons: [], leftButtonSelectors:[], forViewController: self)
        self.tableView?.estimatedRowHeight = 72.0
        self.tableView?.rowHeight = UITableViewAutomaticDimension
        callLoginAPI()
    }
}

extension CheckoutViewController {
    // MARK: UITableView Delegate Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TitleCell", for: indexPath) as UITableViewCell
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DoubleTextFieldCell", for: indexPath) as! CheckoutDoubleTextFieldCell
            cell.firstField.placeholder = "First name"
            cell.secondField.placeholder = "Last name"
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextViewCell", for: indexPath) as! CheckoutTextViewCell
            cell.textView?.placeholder = "Address 1"
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextViewCell", for: indexPath) as! CheckoutTextViewCell
            cell.textView?.placeholder = "Address 2"
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextViewButtonCell", for: indexPath) as! CheckoutTextViewCell
            cell.textView.placeholder = "Country"
            cell.pickerButtonAction = {
                self.tappedCountryButton()
            }
            if let countryName = country {
                cell.textView.text = countryName.label
            }
            return cell
        case 5:
            if enableRegionTap {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TextViewButtonCell", for: indexPath) as! CheckoutTextViewCell
                cell.textView.placeholder = "State"
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
        case 6:
            if enableCityTap {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TextViewButtonCell", for: indexPath) as! CheckoutTextViewCell
                cell.textView.placeholder = "Place"
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
                cell.textView.placeholder = "Place"
                city?.name = cell.textView.text
                return cell
            }
        case 7:
            if enablePincodeTap {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DoubleTextFieldButtonCell", for: indexPath) as! CheckoutDoubleTextFieldCell
                cell.firstField.placeholder = "PIN"
                cell.secondField.placeholder = "Contact number"
                cell.pickerButAction = {
                    self.tappedPincodeButton()
                }
                if let pinCode = pin {
                    cell.firstField.text = pinCode.zipcode
                }
                if let contact = contactNumber {
                    cell.secondField.text = contact
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DoubleTextFieldCell", for: indexPath) as! CheckoutDoubleTextFieldCell
                cell.firstField.placeholder = "PIN"
                cell.secondField.placeholder = "Contact number"
                pin?.zipcode = cell.firstField.text
                if let contact = contactNumber {
                    cell.secondField.text = contact
                }
                return cell
            }
        case 8:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextViewCell", for: indexPath) as! CheckoutTextViewCell
            cell.textView.placeholder = "Email"
            return cell
        case 9:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath) as UITableViewCell
            let cancelButton: UIButton = cell.viewWithTag(100) as! UIButton
            cancelButton.addTarget(self, action: #selector(tappedCancelButton), for: .touchUpInside)
            let nextButton: UIButton = cell.viewWithTag(101) as! UIButton
            nextButton.addTarget(self, action: #selector(tappedNextButton), for: .touchUpInside)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath) as UITableViewCell
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 2:
            return UITableViewAutomaticDimension
        case 3:
            return UITableViewAutomaticDimension
        default:
            return 72.0
        }
    }

    func setTextViewData(textView:UITextView) {
        let cell = textView.superview?.superview as? UITableViewCell
        let indexPathOfCell = self.tableView?.indexPath(for: cell!)
        switch indexPathOfCell!.row {
        case 1:
            if textView.tag == 0 {
                firstName = textView.text
            } else {
                lastName = textView.text
            }
        case 2:
            address1 = textView.text
        case 3:
            address2 = textView.text
        case 4:
            break
//            country = textView.text
        case 5:
            if !enableRegionTap {
                region?.name = textView.text
            }
            break
        case 6:
            city?.name = textView.text
        case 7:
            if textView.tag == 0 {
                pin?.zipcode = textView.text
            } else {
                contactNumber = textView.text
            }
        case 8:
            email = textView.text
        default:
            print("Invalid")
        }
    }

    func tappedCancelButton() {
        print("cancel....")

    }

    func tappedNextButton() {
        print("next....")
        validateData()
//        showSelectAddressView()
    }

    func validateData() {
        if hasNoValue(property:firstName) {
            showValidationAlertFor(property: (#keyPath(firstName) as String).differentCamelCaps)
        } else if hasNoValue(property:lastName) {
            showValidationAlertFor(property: (#keyPath(lastName) as String).differentCamelCaps)
        } else if hasNoValue(property:address1) {
            showValidationAlertFor(property: (#keyPath(address1) as String).differentCamelCaps)
        } else if hasNoValue(property:address2) {
            showValidationAlertFor(property: (#keyPath(address2) as String).differentCamelCaps)
        } else if hasNoValue(property:region?.name) {
            showValidationAlertFor(property: (#keyPath(region) as String).differentCamelCaps)
        } else if hasNoValue(property:city?.name) {
            showValidationAlertFor(property: (#keyPath(city) as String).differentCamelCaps)
        } else if hasNoValue(property:pin?.zipcode) {
            showValidationAlertFor(property: (#keyPath(pin) as String).differentCamelCaps)
        } else if hasNoValue(property:contactNumber) {
            showValidationAlertFor(property: (#keyPath(contactNumber) as String).differentCamelCaps)
        } else if hasNoValue(property:email) {
            showValidationAlertFor(property: (#keyPath(email) as String).differentCamelCaps)
        } else {
            print("******************")
//            print(firstName!, lastName!, address1!, address2!, country!, state!, place!, pin! ,contactNumber!, email!)
            callAPIToAddDeliveryAddress()
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
            self.callAPIToGetCountryList()
        }
    }

    func callAPIToGetCountryList() {
        GetCountryListAPIManager.getCountryList { (response, error) in
            print(response!)
            if response?.count != 0 {
                self.countryPickerData = response!
                self.setCountryInitialValue()
                self.callAPIToGetRegionCode()
            }
        }
    }

    func callAPIToGetRegionCode() {
        GetRegionCodeAPIManager.getRegionCode(countryCode: (country?.value!)!) { (response, error) in
            if let res = response, res.data != nil {
                if res.type != "text" {
                    self.enableRegionTap = true
                    self.regionPickerData = (response?.data)!
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
                    self.tableView?.reloadRows(at: [IndexPath(row:5, section:0)], with: .none)
                }
                self.hideHUD()
            }
        }
    }

    ///////*******************

    func callAPIToGetRegionCities() {
        GetRegionCitiesAPIManager.getRegionCities(regionId: (self.region?.regionId)!, sessionId: AppDelegate.application().sessionId!) { (response, error) in
            if let res = response, res.data != nil {
                if res.type != "text" {
                    self.enableCityTap = true
                    self.cityPickerData = (res.data)!
                    self.city = self.cityPickerData[0]
                    DispatchQueue.main.async {
                        self.callAPIToGetCityPincodes()
                        self.tableView?.reloadRows(at: [IndexPath(row:6, section:0)], with: .none)
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
                        self.tableView?.reloadRows(at: [IndexPath(row:7, section:0)], with: .none)
                        if self.initialLoad {
                            self.callAPIToGetShippingAddress()
                            self.initialLoad = false
                        }
//                        self.hideHUD()
                    }
                }
            } else {
                self.enablePincodeTap = false
                DispatchQueue.main.async {
                    self.tableView?.reloadRows(at: [IndexPath(row:7, section:0)], with: .none)
                }
                self.hideHUD()
            }
        }
    }
    ///////*******************

    func callAPIToGetShippingAddress() {
        GetShippingAddressAPIManager.getShippingAddress(sessionId: AppDelegate.application().sessionId!, emailId: "vishnuvardhanpv@gmail.com") { (response, error) in
            print(response?.data!)
            self.addressList = response?.data!
            self.hideHUD()
            if (self.addressList?.count)! > 1 {
                DispatchQueue.main.async {
                    self.showSelectAddressView()
                }
            }
        }
    }

    func callAPIToAddDeliveryAddress() {
//        print(firstName!, lastName!, address1!, address2!, country!, state!, place!, pin! ,contactNumber!, email!)
        AddDeliveryAddressAPIManager.addDeliveryAddressAPIManager(sessionId: AppDelegate.application().sessionId!, emailId: email!, streetAddress: address1!+address2!, firstName: firstName!, lastName: lastName!, telephone: contactNumber!, countryId: (country?.value)!, region: (region?.name)!, city: (city?.name)!, zipCode: (pin?.zipcode)!) { (response, error) in
            if response?["status"] == "success" {
                // success
                self.performSegue(withIdentifier: "SelectShippingMethodFromCheckoutSegue", sender: nil)
            }
        }
    }
}

extension CheckoutViewController {
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
            self.tableView?.reloadRows(at: [IndexPath(row:4, section:0)], with: .none)
            callAPIToGetRegionCode()
        } else if pickerType == .regionType {
            print("\(self.regionPickerData[self.countryRegionPicker.selectedRow(inComponent: 0)])")
            region = self.regionPickerData[self.countryRegionPicker.selectedRow(inComponent: 0)]
            self.tableView?.reloadRows(at: [IndexPath(row:5, section:0)], with: .none)
            callAPIToGetRegionCities()
        } else if pickerType == .cityType {
            print("\(self.cityPickerData[self.countryRegionPicker.selectedRow(inComponent: 0)])")
            city = self.cityPickerData[self.countryRegionPicker.selectedRow(inComponent: 0)]
            self.tableView?.reloadRows(at: [IndexPath(row:6, section:0)], with: .none)
            callAPIToGetCityPincodes()
        } else if pickerType == .pincodeType {
            print("\(self.pincodePickerData[self.countryRegionPicker.selectedRow(inComponent: 0)])")
            pin = self.pincodePickerData[self.countryRegionPicker.selectedRow(inComponent: 0)]
            self.tableView?.reloadRows(at: [IndexPath(row:7, section:0)], with: .none)
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
                self.tableView?.reloadRows(at: [IndexPath(row:4, section:0)], with: .none)
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
                self.tableView?.reloadRows(at: [IndexPath(row:5, section:0)], with: .none)
            }
        }
    }

    func showSelectAddressView() {
        self.performSegue(withIdentifier: "SelectAddressSegue", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SelectAddressSegue" {
            let selectAddressView = segue.destination as! SelectAddressViewController
            selectAddressView.address = self.addressList
        }
    }
}

extension CheckoutViewController: UIPickerViewDataSource {

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

extension CheckoutViewController: UIPickerViewDelegate {
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

//    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        print("\(self.countryPickerData[row])")
//    }
}

extension CheckoutViewController: UITextViewDelegate {
    public func textViewDidChange(_ textView: UITextView) {
        print("############## "+textView.text)
        let currentOffset = self.tableView?.contentOffset
        UIView.setAnimationsEnabled(false)
        self.tableView?.beginUpdates()
        self.tableView?.endUpdates()
        UIView.setAnimationsEnabled(true)
        self.tableView?.setContentOffset(currentOffset!, animated: false)
        setTextViewData(textView: textView)
    }
}

extension String {
    var differentCamelCaps: String {
        var newString: String = ""
        for eachCharacter in self.characters {
            if (eachCharacter >= "A" && eachCharacter <= "Z") == true {
                newString.append(" ")
            }
            newString.append(eachCharacter)
        }
        return newString.capitalizingFirstLetter()
    }

    func capitalizingFirstLetter() -> String {
        let first = String(characters.prefix(1)).capitalized
        let other = String(characters.dropFirst())
        return first + other
    }
}
