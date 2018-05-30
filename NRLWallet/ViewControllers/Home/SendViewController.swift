//
//  SendViewController.swift
//  NRLWallet
//
//  Created by admin on 29/05/2018.
//  Copyright © 2018 NoRestLabs. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class SendViewController: UIViewController, IndicatorInfoProvider {

    @IBOutlet weak var backgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title:"Send")
    }
    
    func setupViews() {
        self.backgroundView.layer.cornerRadius = 5
        self.backgroundView.layer.borderColor = Constants.Colors.BorderColor.cgColor
        self.backgroundView.layer.borderWidth = 3
    }
}
