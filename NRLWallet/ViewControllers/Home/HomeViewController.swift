//
//  HomeViewController.swift
//  NRLWallet
//
//  Created by admin on 25/05/2018.
//  Copyright © 2018 NoRestLabs. All rights reserved.
//

import UIKit
import SWRevealViewController

class HomeViewController: BaseViewController {

    @IBOutlet weak var bttMenu: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addMenuAction()
        // Do any additional setup after loading the view.
    }
    
    func addMenuAction() {
        if self.revealViewController() != nil {
            self.bttMenu.target = self.revealViewController()
            self.bttMenu.action = #selector(SWRevealViewController.revealToggle(_:))
        }
    }
}
