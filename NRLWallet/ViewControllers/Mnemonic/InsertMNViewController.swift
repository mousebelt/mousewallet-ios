//
//  PinInsertViewController.swift
//  NRLWallet
//
//  Created by Daniel on 13/06/2018.
//  Copyright © 2018 NoRestLabs. All rights reserved.
//

import UIKit
import NRLWalletSDK
import TagListView

class InsertMNViewController: UIViewController, TagListViewDelegate  {
    
    @IBOutlet weak var mnemonicContainer: UIView!
    @IBOutlet weak var mnemonicTagList: TagListView!
    @IBOutlet weak var bttBack: UIButton!
    @IBOutlet weak var bttNext: UIButton!
    @IBOutlet weak var UIViewKey1: UIView!
    @IBOutlet weak var UIViewKey2: UIView!
    @IBOutlet weak var UIViewKey3: UIView!
    @IBOutlet weak var btt_Space: UIButton!
    @IBOutlet weak var btt_aToz: UIButton!
    
    @IBOutlet weak var bttRecommend1: UIButton!
    @IBOutlet weak var bttRecommend2: UIButton!
    @IBOutlet weak var bttRecommend3: UIButton!
    
    
    var inputString : String!
    let mnemonicWords = String.englishMnemonics as [String]
    var filterdArray = [String]()
    var mnemonicArray = [String]()
    
    @IBOutlet weak var inputLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
        self.setupKeyboard()
        
        self.mnemonicArray = ["target", "crater", "noble", "virus", "album", "surge", "kidney", "tennis", "snow", "click", "faculty", "robust"]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //UI setting
    func setupViews() {
        self.bttRecommend1.sizeToFit()
        self.bttRecommend2.sizeToFit()
        self.bttRecommend3.sizeToFit()
        self.bttRecommend1.addTarget(self, action: #selector(recommendClick(_:)), for: .touchUpInside)
        self.bttRecommend2.addTarget(self, action: #selector(recommendClick(_:)), for: .touchUpInside)
        self.bttRecommend3.addTarget(self, action: #selector(recommendClick(_:)), for: .touchUpInside)
        self.inputLabel.text = ""
        self.inputString = ""
        self.bttBack.layer.cornerRadius = Constants.Consts.CornerRadius3!
        self.bttBack.clipsToBounds = true
        self.bttNext.layer.cornerRadius = Constants.Consts.CornerRadius3!
        self.bttNext.clipsToBounds = true
        
        mnemonicTagList.delegate = self
        mnemonicTagList.textFont = UIFont(name: "SourceSansPro-Regular", size: 18.0)!
        //Mnemonic Tag list dotted border
        let viewBorder = CAShapeLayer()
        viewBorder.strokeColor = Constants.Colors.BorderColor.cgColor
        viewBorder.lineDashPattern = [8, 8]
        viewBorder.frame = mnemonicContainer.bounds
        viewBorder.fillColor = nil
        viewBorder.cornerRadius = Constants.Consts.CornerRadius!
        let rect = CGRect(x:0, y: 0, width:self.view.bounds.size.width - 36 * 2, height: mnemonicContainer.bounds.size.height)
        viewBorder.path = UIBezierPath(rect: rect).cgPath
        mnemonicContainer.layer.addSublayer(viewBorder)
    }
    //keyboard UI/Action setting
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
    
    //search mnemonic
    func searchWords(search: String) {
        filterdArray = mnemonicWords.filter { item in
            return item.lowercased().hasPrefix(search.lowercased())
        }
        if(filterdArray.count > 0) {
            self.bttRecommend1.setTitle(filterdArray[0], for: .normal)
            self.bttRecommend1.isHidden = false
        }else {
            self.bttRecommend1.setTitle("", for: .normal)
            self.bttRecommend1.isHidden = true
        }
        if(filterdArray.count > 1) {
            self.bttRecommend2.setTitle(filterdArray[1], for: .normal)
            self.bttRecommend2.isHidden = false
        }else {
            self.bttRecommend2.setTitle("", for: .normal)
            self.bttRecommend2.isHidden = true
        }
        if(filterdArray.count > 2) {
            self.bttRecommend3.setTitle(filterdArray[2], for: .normal)
            self.bttRecommend3.isHidden = false
        }else {
            self.bttRecommend3.setTitle("", for: .normal)
            self.bttRecommend3.isHidden = true
        }
    }
    //auto add mnemonic
    func autoAddMnemonic(search: String) {
        filterdArray = mnemonicWords.filter { item in
            return item.lowercased().hasPrefix(search.lowercased())
        }
        if (filterdArray.count == 0) {
            return
        }
        let str = filterdArray[0]
        if(filterdArray.count > 0 && mnemonicArray.count < 12) {
            if(!mnemonicArray.contains(str)) {
                mnemonicArray.append(str)
                mnemonicTagList.addTag(str)
                self.initWords()
            }
        }
    }
    //Initialize recommend buttons
    func initWords() {
        inputString.removeAll()
        self.inputLabel.text = ""
        self.bttRecommend1.setTitle("", for: [])
        self.bttRecommend2.setTitle("", for: [])
        self.bttRecommend3.setTitle("", for: [])
        self.bttRecommend1.isHidden = true
        self.bttRecommend2.isHidden = true
        self.bttRecommend3.isHidden = true
    }
    
    //Actions: Recommend button (3 buttons) action
    @IBAction func recommendClick(_ sender: UIButton) {
        if(mnemonicArray.count >= 12) {
            toastMessage(str: "Mnemonic must be consist of 12 words!")
            return
        }
        if(sender.isHidden) {
            return
        }
        let str = sender.titleLabel?.text
        if(!(str?.isEmpty)!){
            if(!mnemonicArray.contains(str!)) {
                mnemonicArray.append(str!)
                mnemonicTagList.addTag(str!)
                self.initWords()
            }
        }
    }
    //Actions: Back event. go to Tutorial Navigation
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
    
    //Actions: Back event. go to Tutorial Navigation
    @IBAction func clickBack(_ sender: Any) {
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
    
    //Actions: Verify input mnemonic list, go to PIN Navigation
    @IBAction func clickNext(_ sender: Any) {
        if( mnemonicArray.count != 12 ) {
            toastMessage(str: "Mnemonic must be consist of 12 words!")
        } else {
            //need check valid mnemonic
            var validate = false
            do {
                var seed: Data?
                seed = try NRLMnemonic.mnemonicToSeed(from: self.mnemonicArray, withPassphrase: "")
                if(seed?.isEmpty)!{
                    validate = false
                } else {
                    validate = true
                }
            } catch {
                print(error)
                validate = true
            }
            
            if(validate) {
                let storyboard = UIStoryboard(name: "Pin", bundle: nil)
                let PinViewController = storyboard.instantiateViewController(withIdentifier: "PinVC") as! PinViewController
                PinViewController.mnemonicInitial = self.mnemonicArray
                self.navigationController?.pushViewController(PinViewController, animated: true)
            } else {
                toastMessage(str: "Invalid Mnemonic!")
            }
            
        }
    }
    
    //Actions: Space button event, initializing the Recommend buttons
    @IBAction func clickSpace(_ sender: Any) {
        self.initWords()
    }
    
    //Actions: Backspace event
    @IBAction func clickBackspace(_ sender: Any) {
        if(inputString.count > 0){
            inputString.removeLast()
            self.inputLabel.text = inputString
            self.searchWords(search: inputString)
        }
    }
    
    //Actions: keypad click event
    @objc func KeyboardClick(_ sender: UIButton) {
        let str = sender.titleLabel?.text
        inputString.append(str!)
        self.inputLabel.text = inputString
        if(inputString.count > 0) {
            if(inputString.count == 4) {
                self.autoAddMnemonic(search: inputString)
            } else {
                self.searchWords(search: inputString)
            }
        }
    }
    //Action: mnemonic taglist click event
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        mnemonicTagList.removeTag(title)
        mnemonicArray = mnemonicArray.filter{$0 != title}
    }
}
