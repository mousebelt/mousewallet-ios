//
//  Tutorial1ViewController.swift
//  NRLWallet
//
//  Created by dev on 18/05/2018.
//  Copyright © 2018 NoRestLabs. All rights reserved.
//

import UIKit

class Tutorial1ViewController: UIViewController {

    @IBOutlet var btnGetStarted: UIView!
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
        self.btnGetStarted.layer.cornerRadius = Constants.Consts.CornerRadius!
        self.pageControl.transform = CGAffineTransform(scaleX: 2, y:2)
        self.cardView.layer.borderWidth = Constants.Consts.BorderWidth!
        self.cardView.layer.borderColor = Constants.Colors.BorderColor.cgColor
    }
    
    // Restore from backup
    @IBAction func onRestoreFromBackup(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Mnemonic", bundle: nil)
        let mnemonicNavigation = storyboard.instantiateViewController(withIdentifier: "InsertMnemonicNavVC")
        let window = UIApplication.shared.keyWindow
        
        if let window = window {
            UIView.transition(with: window, duration: 0.0, options: .autoreverse, animations: {
                let oldState: Bool = UIView.areAnimationsEnabled
                UIView.setAnimationsEnabled(false)
                window.rootViewController = mnemonicNavigation
                UIView.setAnimationsEnabled(oldState)
            }, completion: nil)
        }
    }
    
    
    @IBAction func onGetStarted(_ sender: Any) {
        self.performSegue(withIdentifier: "GetStartedSegue", sender: nil)
    }
    func dropShadow(opacity: Float = 0.5, radius: CGFloat = 1, scale: Bool = true) {
        self.cardView.clipsToBounds = false
        self.cardView.layer.shadowColor = Constants.Colors.BorderColor.cgColor
        self.cardView.layer.shadowOpacity = opacity
        self.cardView.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.cardView.layer.shadowRadius = radius
        
        self.cardView.layer.shadowPath = UIBezierPath(rect: self.view.bounds).cgPath
        self.cardView.layer.shouldRasterize = true
        self.cardView.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

