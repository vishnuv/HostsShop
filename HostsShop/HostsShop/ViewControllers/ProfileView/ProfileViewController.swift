//
//  ProfileViewController.swift
//  HostsShop
//
//  Created by Vishnu Vardhan PV on 09/02/17.
//  Copyright © 2017 vishnuvardhanpv. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var dataSource: [String]?
    var profileImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Util.customizeNavigationBarWithTitle(title: "My Profile", rightButtons: [], rightButtonSelectors:[], leftButtons: [], leftButtonSelectors:[], forViewController: self)
        dataSource = ["", "Your Order", "Wishlist", "Delivery Address", "Change Password", "Contact Us"]
    }
}

extension ProfileViewController {
    @IBAction func showImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profileImage = pickedImage
            self.tableView.reloadData()
        }
        dismiss(animated: true, completion: nil)
    }

    internal func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension ProfileViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmailCell", for: indexPath) as UITableViewCell
            cell.selectionStyle = .none
            let profile = cell.viewWithTag(100) as! UIImageView
            profile.layer.cornerRadius = 55.0/2
            profile.clipsToBounds = true
            if let profilePicture = profileImage {
                profile.image = profilePicture
            }
            let emailLabel = cell.viewWithTag(101) as! UILabel
            emailLabel.text = "vishnuvardhanpv@gmail.com"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NormalCell", for: indexPath) as UITableViewCell
            cell.selectionStyle = .none
            let label = cell.viewWithTag(100) as! UILabel
            label.text = dataSource![indexPath.row]
            return cell
        }
    }
}

extension ProfileViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 1:
            self.performSegue(withIdentifier: "OrdersViewSegue", sender: nil)
            break
        case 2:
            self.performSegue(withIdentifier: "WishlistSegue", sender: nil)
            break
        case 3:
            self.performSegue(withIdentifier: "AddressSegue", sender: nil)
            break
        case 4:
            self.performSegue(withIdentifier: "ChangePasswordSegue", sender: nil)
            break
        case 5:
            self.performSegue(withIdentifier: "ContactUsSegue", sender: nil)
            break
        default:
            break
        }
    }
}
