//
//  PinInsertViewController.swift
//  NRLWallet
//
//  Created by cheera on 13/06/2018.
//  Copyright © 2018 NoRestLabs. All rights reserved.
//

import UIKit
import TagListView
import NRLWalletSDK

class InsertMNViewController: UIViewController {
    
    @IBOutlet weak var mnemonicContainer: UIView!
    @IBOutlet weak var mnemonicTagList: TagListView!
    @IBOutlet weak var bttBack: UIButton!
    @IBOutlet weak var bttNext: UIButton!
    @IBOutlet weak var UIViewKey1: UIView!
    @IBOutlet weak var UIViewKey2: UIView!
    @IBOutlet weak var UIViewKey3: UIView!
    @IBOutlet weak var btt_Space: UIButton!
    @IBOutlet weak var btt_aToz: UIButton!
    
    var inputString : String!
    var mnemonicWords = [String]()
    
    @IBOutlet weak var inputLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
        self.setupKeyboard()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getMnemonicList() {
        NRLMnemonic.mnemonicString(from: "", language: .english)
    }
    
    func setupViews() {
        self.inputLabel.text = ""
        self.inputString = ""
        self.bttBack.layer.cornerRadius = Constants.Consts.CornerRadius3!
        self.bttBack.clipsToBounds = true
        self.bttNext.layer.cornerRadius = Constants.Consts.CornerRadius3!
        self.bttNext.clipsToBounds = true
    }
    func setupKeyboard() {
        let mykeys1 = self.UIViewKey1.subviews as! [UIButton]
        let mykeys2 = self.UIViewKey2.subviews as! [UIButton]
        let mykeys3 = self.UIViewKey3.subviews as! [UIButton]
        let mykeys = mykeys1 + mykeys2 + mykeys3
        for i in 0 ... mykeys.count - 1 {
            let bttkey = mykeys[i] as UIButton?
            bttkey?.layer.cornerRadius = Constants.Consts.CornerRadius!
            bttkey?.layer.shadowColor = Constants.Colors.FontColor.cgColor
            bttkey?.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
            bttkey?.layer.shadowOpacity = 1.0
            bttkey?.layer.shadowRadius = 1.0
            bttkey?.layer.masksToBounds = false            
            bttkey?.addTarget(self, action: #selector(KeyboardClick(_ :)), for: .touchUpInside)
        }
        btt_Space.layer.cornerRadius = Constants.Consts.CornerRadius!
        btt_Space.layer.shadowColor = Constants.Colors.FontColor.cgColor
        btt_Space.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        btt_Space.layer.shadowOpacity = 1.0
        btt_Space.layer.shadowRadius = 1.0
        btt_Space.layer.masksToBounds = false
        
        btt_aToz.layer.cornerRadius = Constants.Consts.CornerRadius!
        btt_aToz.layer.shadowColor = Constants.Colors.FontColor.cgColor
        btt_aToz.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        btt_aToz.layer.shadowOpacity = 1.0
        btt_aToz.layer.shadowRadius = 1.0
        btt_aToz.layer.masksToBounds = false
        
    }
    
    //Actions
    @IBAction func goBack(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Tutorial", bundle: nil)
        let tutorialViewController = storyboard.instantiateViewController(withIdentifier: "TutorialNavVC")
        let window = UIApplication.shared.keyWindow
        if let window = window {
            UIView.transition(with: window, duration: 0.5, options: .beginFromCurrentState, animations: {
                let oldState: Bool = UIView.areAnimationsEnabled
                UIView.setAnimationsEnabled(false)
                window.rootViewController = tutorialViewController
                UIView.setAnimationsEnabled(oldState)
            }, completion: nil)
        }
    }
    
    @IBAction func clickBack(_ sender: Any) {
    }
    
    @IBAction func clickNext(_ sender: Any) {
    }
    
    @IBAction func clickSpace(_ sender: Any) {
    }
    
    @IBAction func clickAZ(_ sender: Any) {
        if(inputString.count > 0){
            inputString.removeLast()
            self.inputLabel.text = inputString
        }
    }
    
    @objc func KeyboardClick(_ sender: UIButton) {
        let str = sender.titleLabel?.text
        inputString.append(str!)
        self.inputLabel.text = inputString
    }    
}
