//
//  SideMenuViewController.swift
//  NRLWallet
//
//  Created by admin on 27/05/2018.
//  Copyright © 2018 NoRestLabs. All rights reserved.
//

import UIKit
import Contacts
import SWRevealViewController

class SideMenuViewController: UIViewController {
    
    @IBOutlet weak var imgUserAvatar: UIImageView!
    @IBOutlet weak var lb_UserBalance: UILabel!
    @IBOutlet weak var lb_UserName: UILabel!
    
    @IBOutlet weak var vi_Home: UIView!
    @IBOutlet weak var vi_Send: UIView!
    @IBOutlet weak var vi_Received: UIView!
    @IBOutlet weak var vi_Swap: UIView!
    @IBOutlet weak var vi_Mnemonic: UIView!
    @IBOutlet weak var vi_Logout: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
        self.addSwipeLeftGesture()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func addSwipeLeftGesture() {
        let leftSwipe = UISwipeGestureRecognizer(target: self.revealViewController(), action: #selector(self.revealViewController().revealToggle(_:)))
        leftSwipe.direction = .left
        self.view.addGestureRecognizer(leftSwipe)
    }

    func setupViews() {
        self.imgUserAvatar.layer.cornerRadius = self.imgUserAvatar.frame.size.height/2
        self.imgUserAvatar.clipsToBounds = true
    }
    func setDefaultBackground() {
        self.vi_Home.layer.backgroundColor = Constants.Colors.WhiteColor.cgColor
        self.vi_Send.layer.backgroundColor = Constants.Colors.WhiteColor.cgColor
        self.vi_Received.layer.backgroundColor = Constants.Colors.WhiteColor.cgColor
        self.vi_Swap.layer.backgroundColor = Constants.Colors.WhiteColor.cgColor
        self.vi_Mnemonic.layer.backgroundColor = Constants.Colors.WhiteColor.cgColor
        self.vi_Logout.layer.backgroundColor = Constants.Colors.WhiteColor.cgColor
        
    }
//    Actions
    @IBAction func ActionHome(_ sender: Any) {
        self.setDefaultBackground()
        self.vi_Home.layer.backgroundColor = Constants.Colors.ActiveLayerBackgroundColor.cgColor
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeVC = storyboard.instantiateViewController(withIdentifier: "BaseNav") as! UINavigationController
        self.revealViewController().setFront(homeVC, animated: false)
        self.revealViewController().revealToggle(animated:true)
    }
    
    @IBAction func ActionSend(_ sender: Any) {
        self.setDefaultBackground()
        self.vi_Send.layer.backgroundColor = Constants.Colors.ActiveLayerBackgroundColor.cgColor
        self.revealViewController().revealToggle(animated:true)
    }
    
    @IBAction func ActionReceived(_ sender: Any) {
        self.setDefaultBackground()
        self.vi_Received.layer.backgroundColor = Constants.Colors.ActiveLayerBackgroundColor.cgColor
        self.revealViewController().revealToggle(animated:true)
    }
    
    @IBAction func ActionSwap(_ sender: Any) {
        self.setDefaultBackground()
        self.vi_Swap.layer.backgroundColor = Constants.Colors.ActiveLayerBackgroundColor.cgColor
        self.revealViewController().revealToggle(animated:true)
    }
    
    @IBAction func ActionMnemonic(_ sender: Any) {
        self.setDefaultBackground()
        self.vi_Mnemonic.layer.backgroundColor = Constants.Colors.ActiveLayerBackgroundColor.cgColor
        self.revealViewController().revealToggle(animated:true)
    }
    
    @IBAction func ActionLogout(_ sender: Any) {
        self.setDefaultBackground()
        UserData.saveKeyData(Constants.DefaultsKeys.kKeyTutorialPass, value: Constants.NO)
        self.vi_Logout.layer.backgroundColor = Constants.Colors.ActiveLayerBackgroundColor.cgColor
        self.revealViewController().revealToggle(animated:true)
        
        let storyboard = UIStoryboard(name: "Tutorial", bundle: nil)
        let tutorialViewController = storyboard.instantiateViewController(withIdentifier: "TutorialNavVC")
        let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDel.window?.rootViewController = tutorialViewController
    }
    

}
