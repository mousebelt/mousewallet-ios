//
//  SettingsViewController.swift
//  NRLWallet
//
//  Created by cub on 16/07/2018.
//  Copyright © 2018 NoRestLabs. All rights reserved.
//

import UIKit
import SWRevealViewController

class SettingsViewController : UIViewController {
    
    @IBOutlet weak var btn_deleteAccount: UIButton!
    @IBOutlet weak var btn_menu: UIBarButtonItem!
    @IBAction func onDeleteAccount(_ sender: Any) {
        
        let alert = UIAlertController(title: "Delete Account", message: "Are you sure? You can only recover from your mnemonic", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (alert: UIAlertAction!) -> Void in
            UserData.saveKeyData(Constants.DefaultsKeys.kKeyTutorialPass, value: Constants.NO)
            
            for coinModel in AppController.shared.coinArray {
                if(coinModel.symbol == "BTC" || coinModel.symbol == "LTC") {
                    coinModel.wallet.disConnectPeers()
                }
            }
            AppController.shared.coinArray.removeAll()
            self.revealViewController().revealToggle(animated:true)
            
            let storyboard = UIStoryboard(name: "Tutorial", bundle: nil)
            let tutorialViewController = storyboard.instantiateViewController(withIdentifier: "TutorialNavVC")
            let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            appDel.window?.rootViewController = tutorialViewController
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (alert: UIAlertAction!) -> Void in
            print("You pressed Cancel")
        }
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion:nil)
    }
    
    override func viewDidLoad() {
        setupViews()
        addMenuAction()
        setLeftMenu()
    }
    
    func setupViews() {
        self.btn_deleteAccount.layer.cornerRadius = Constants.Consts.CornerRadius!
    }
    
    func setLeftMenu() {
        self.revealViewController().rearViewRevealWidth = view.frame.size.width * 0.8
        self.revealViewController().panGestureRecognizer()
        self.revealViewController().tapGestureRecognizer()
    }
    func addMenuAction() {
        if self.revealViewController() != nil {
            self.btn_menu.target = self.revealViewController()
            self.btn_menu.action = #selector(SWRevealViewController.revealToggle(_:))
        }
    }
}
