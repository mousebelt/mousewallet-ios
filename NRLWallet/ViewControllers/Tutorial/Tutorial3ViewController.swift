//
//  Tutorial3ViewController.swift
//  NRLWallet
//
//  Created by dev on 18/05/2018.
//  Copyright © 2018 NoRestLabs. All rights reserved.
//

import UIKit

class Tutorial3ViewController: UIViewController {
    
    @IBOutlet weak var btnCreateAccount: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var cardView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupViews() {
        self.btnCreateAccount.layer.cornerRadius = Constants.Consts.CornerRadius!
        self.pageControl.transform = CGAffineTransform(scaleX: 2, y:2)
        self.cardView.layer.borderWidth = Constants.Consts.BorderWidth!
        self.cardView.layer.borderColor = Constants.Colors.BorderColor.cgColor
    }
    @IBAction func onRestoreFromBackup(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Pin", bundle: nil)
        let pinNavigation = storyboard.instantiateViewController(withIdentifier: "PinEnterNavVC")
        let window = UIApplication.shared.keyWindow
        
        if let window = window {
            UIView.transition(with: window, duration: 0.0, options: .autoreverse, animations: {
                let oldState: Bool = UIView.areAnimationsEnabled
                UIView.setAnimationsEnabled(false)
                window.rootViewController = pinNavigation
                UIView.setAnimationsEnabled(oldState)
            }, completion: nil)
        }
    }
    
    @IBAction func onCreateAccount(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Mnemonic", bundle: nil)
        let mnemonicViewController = storyboard.instantiateViewController(withIdentifier: "MnemonicNavVC")
        let window = UIApplication.shared.keyWindow
        
        if let window = window {
            UIView.transition(with: window, duration: 0.0, options: .autoreverse, animations: {
                let oldState: Bool = UIView.areAnimationsEnabled
                UIView.setAnimationsEnabled(false)
                window.rootViewController = mnemonicViewController
                UIView.setAnimationsEnabled(oldState)
            }, completion: nil)
        }
    }
    
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
