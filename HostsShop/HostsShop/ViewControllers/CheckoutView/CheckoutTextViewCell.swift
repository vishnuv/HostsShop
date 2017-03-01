//
//  CheckoutTextViewCell.swift
//  HostsShop
//
//  Created by Vishnu Vardhan PV on 19/01/17.
//  Copyright © 2017 vishnuvardhanpv. All rights reserved.
//

import Foundation
import KMPlaceholderTextView

typealias PickerButtonAction = () -> ()

class CheckoutTextViewCell: UITableViewCell {
    @IBOutlet weak var textView: KMPlaceholderTextView!
    @IBOutlet weak var textViewButton: UIButton!
    var pickerButtonAction: PickerButtonAction?

    override func awakeFromNib() {
        super.awakeFromNib()
        setUpTextViews(textView: textView)
    }

    func setUpTextViews(textView: KMPlaceholderTextView) {
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor.black.cgColor
        textView.font = UIFont.boldSystemFont(ofSize: 18.0)
        textView.placeholderFont = UIFont.systemFont(ofSize: 18.0)
        textView.textContainerInset = UIEdgeInsets(top: 15, left: 10, bottom: 0, right: 0)
    }

    @IBAction func tappedPickerButton() {
        self.pickerButtonAction!()
    }
}
