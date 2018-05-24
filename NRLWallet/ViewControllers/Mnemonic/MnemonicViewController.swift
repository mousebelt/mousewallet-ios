//
//  MnemonicViewController.swift
//  NRLWallet
//
//  Created by dev on 19/05/2018.
//  Copyright © 2018 NoRestLabs. All rights reserved.
//

import UIKit
import TagListView

class MnemonicViewController: UIViewController {
    
    let mnemonic = ["accident", "impose", "goat", "inhale", "vintage", "idle", "crazy", "reveal", "reopen", "chest", "picnic", "uphold"]
    
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var mnemonicList: TagListView!
    @IBOutlet weak var mnemonicListContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViews()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupViews() {
        self.btnContinue.layer.cornerRadius = 4
        
        mnemonicList.textFont = UIFont(name: "SourceSansPro-Regular", size: 14.0)!
        mnemonicList.addTags(self.mnemonic)
        
        let viewBorder = CAShapeLayer()
        viewBorder.strokeColor = UIColor(red: 214/255, green: 210/255, blue: 214/255, alpha: 1).cgColor
        viewBorder.lineDashPattern = [4, 4]
        viewBorder.frame = mnemonicListContainer.bounds
        viewBorder.fillColor = nil
        viewBorder.cornerRadius = 4
        viewBorder.path = UIBezierPath(rect: mnemonicListContainer.bounds).cgPath
        mnemonicListContainer.layer.addSublayer(viewBorder)
    }
    
    @IBAction func onContinue(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Mnemonic", bundle: nil)
        let verifyMnemonicViewController = storyboard.instantiateViewController(withIdentifier: "VerifyMnemonicVC")
//        let window = UIApplication.shared.keyWindow
//
//        if let window = window {
//            UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromLeft, animations: {
//                let oldState: Bool = UIView.areAnimationsEnabled
//                UIView.setAnimationsEnabled(true)
//                window.rootViewController = verifyMnemonicViewController
//                UIView.setAnimationsEnabled(oldState)
//            }, completion: nil)
//        }
        self.navigationController?.pushViewController(verifyMnemonicViewController, animated: true)
    }
    
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

