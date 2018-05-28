//
//  BaseViewController.swift
//  NRLWallet
//
//  Created by admin on 27/05/2018.
//  Copyright © 2018 NoRestLabs. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLeftMenu()
    }
    
    func setLeftMenu() {
        self.revealViewController().rearViewRevealWidth = view.frame.size.width * 0.8
        self.revealViewController().panGestureRecognizer()
        self.revealViewController().tapGestureRecognizer()
    }
}
