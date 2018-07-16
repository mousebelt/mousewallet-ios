//
//  SideMenuViewController.swift
//  NRLWallet
//
//  Created by Daniel on 27/05/2018.
//  Copyright © 2018 NoRestLabs. All rights reserved.
//

import UIKit
import Contacts
import SWRevealViewController

class SideMenuViewController: UIViewController {
    @IBOutlet weak var vi_Home: UIView!
    @IBOutlet weak var vi_Settings: UIView!
    @IBOutlet weak var vi_About: UIView!
    
    @IBOutlet weak var img_Settings: UIImageView!
    
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
        img_Settings.image = img_Settings.image!.withRenderingMode(.alwaysTemplate)
        img_Settings.tintColor = UIColor(red: 115.0/255.0, green: 110.0/255.0, blue: 109.0/255.0, alpha: 1)
    }
    
    func setDefaultBackground() {
        self.vi_Home.layer.backgroundColor = Constants.Colors.WhiteColor.cgColor
        self.vi_About.layer.backgroundColor = Constants.Colors.WhiteColor.cgColor
        self.vi_Settings.layer.backgroundColor = Constants.Colors.WhiteColor.cgColor
        
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
    
    @IBAction func ActionAbout(_ sender: Any) {
        self.setDefaultBackground()
        self.vi_About.layer.backgroundColor = Constants.Colors.ActiveLayerBackgroundColor.cgColor
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let aboutVC = storyboard.instantiateViewController(withIdentifier: "AboutNav") as! UINavigationController
        self.revealViewController().setFront(aboutVC, animated: false)
        self.revealViewController().revealToggle(animated:true)
    }
    
    @IBAction func ActionSettings(_ sender: Any) {
        
        self.setDefaultBackground()
        self.vi_About.layer.backgroundColor = Constants.Colors.ActiveLayerBackgroundColor.cgColor
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let settingsVC = storyboard.instantiateViewController(withIdentifier: "SettingsNav") as! UINavigationController
        self.revealViewController().setFront(settingsVC, animated: false)
        self.revealViewController().revealToggle(animated:true)
    }
    

}
