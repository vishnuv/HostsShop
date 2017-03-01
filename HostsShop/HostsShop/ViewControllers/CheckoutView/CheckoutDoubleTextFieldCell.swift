//
//  CheckoutDoubleTextFieldCell.swift
//  HostsShop
//
//  Created by Vishnu Vardhan PV on 19/01/17.
//  Copyright © 2017 vishnuvardhanpv. All rights reserved.
//

import Foundation
import KMPlaceholderTextView

typealias PickerButAction = () -> ()

class CheckoutDoubleTextFieldCell: UITableViewCell {
    @IBOutlet weak var firstField: KMPlaceholderTextView!
    @IBOutlet weak var secondField: KMPlaceholderTextView!
    var pickerButAction: PickerButAction?

    override func awakeFromNib() {
        super.awakeFromNib()
        setUpTextViews(textView: firstField)
        setUpTextViews(textView: secondField)
    }

    func setUpTextViews(textView: KMPlaceholderTextView) {
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor.black.cgColor
        textView.font = UIFont.boldSystemFont(ofSize: 18.0)
        textView.placeholderFont = UIFont.systemFont(ofSize: 18.0)
        textView.textContainerInset = UIEdgeInsets(top: 15, left: 10, bottom: 0, right: 0)
    }

    @IBAction func tappedPickerButton() {
        self.pickerButAction!()
    }
}
