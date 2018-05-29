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

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - IndicatorInfoProvider
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title:"Send")
    }
}
