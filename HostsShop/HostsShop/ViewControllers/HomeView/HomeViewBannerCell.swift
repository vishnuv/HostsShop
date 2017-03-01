//
//  HomeViewBannerCell.swift
//  HostsShop
//
//  Created by Vishnu Vardhan PV on 03/01/17.
//  Copyright © 2017 vishnuvardhanpv. All rights reserved.
//

import Foundation
import UIKit
import AlamofireImage

class HomeViewBannerCell: UITableViewCell {

    @IBOutlet weak var bannerImageView: UIImageView?
    @IBOutlet weak var button1: UIButton?
    @IBOutlet weak var button2: UIButton?
    var banners:[Banner]?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setCellData(banners:[Banner]) {
            self.banners = banners
            DispatchQueue.main.async {
                let bannerObj: Banner = self.banners![0]
                self.bannerImageView?.af_setImage(withURL: URL(string:bannerObj.image!)!)
                self.button1?.setTitle(bannerObj.title!, for: .normal)

                let bannerObj2: Banner = self.banners![1]
                self.button2?.setTitle(bannerObj2.title!, for: .normal)
            }
    }

    @IBAction func tappedButton(sender:UIButton) {
        let bannerObj: Banner = banners![sender.tag]
        self.bannerImageView?.af_setImage(withURL: URL(string:bannerObj.image!)!)
    }
}
