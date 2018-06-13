//
//  PinEnterViewController.swift
//  NRLWallet
//
//  Created by cheera on 12/06/2018.
//  Copyright © 2018 NoRestLabs. All rights reserved.
//

import UIKit
import AudioToolbox

class PinEnterViewController: UIViewController {
    
    @IBOutlet weak var txtTitle: UILabel!
    @IBOutlet weak var pin1: UIImageView!
    @IBOutlet weak var pin2: UIImageView!
    @IBOutlet weak var pin3: UIImageView!
    @IBOutlet weak var pin4: UIImageView!
    @IBOutlet weak var pin5: UIImageView!
    @IBOutlet weak var pin6: UIImageView!
    
    @IBOutlet weak var num0: UIButton!
    @IBOutlet weak var num1: UIButton!
    @IBOutlet weak var num2: UIButton!
    @IBOutlet weak var num3: UIButton!
    @IBOutlet weak var num4: UIButton!
    @IBOutlet weak var num5: UIButton!
    @IBOutlet weak var num6: UIButton!
    @IBOutlet weak var num7: UIButton!
    @IBOutlet weak var num8: UIButton!
    @IBOutlet weak var num9: UIButton!
    @IBOutlet weak var cancel: UIButton!
    @IBOutlet weak var enter: UIButton!
    
    @IBOutlet weak var txtError: UILabel!

    //for pin view
    var pinArray : Array<UIImageView> = []
    var keyboardArray : Array<UIButton> = []
    var pincodeArray : Array<String> = []
    let PIN_MAX = 6
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.pinArray = [pin1, pin2, pin3, pin4, pin5, pin6]
        self.keyboardArray = [num0, num1, num2, num3, num4, num5, num6, num7, num8, num9, cancel, enter]
        self.setupViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setupViews() {
        txtTitle.text = "ENTER A PIN"
        txtError.isHidden = true
        txtTitle.textColor = Constants.Colors.BlackColor
        for i in 0 ... 9 {
            let tmpBtt = self.keyboardArray[i] as UIButton?
            tmpBtt?.layer.cornerRadius = (tmpBtt?.frame.size.height)!/2
            tmpBtt?.layer.borderWidth = Constants.Consts.BorderWidth!
            tmpBtt?.layer.borderColor = Constants.Colors.BorderColor.cgColor
            tmpBtt?.addTarget(self, action: #selector(KeyboardClick(_ :)), for: .touchUpInside)
        }
        cancel.addTarget(self, action: #selector(self.keyboardCancel(_ :)), for: .touchUpInside)
        enter.addTarget(self, action: #selector(self.keyboardEnter(_ :)), for: .touchUpInside)
        self.formatPinView()
    }

    func formatPinView() {
        for i in 0 ... PIN_MAX - 1 {
            let tmpPin = pinArray[i] as UIImageView?
            tmpPin?.image = UIImage.init(named: "unpass")
        }
    }
    
    @objc func KeyboardClick(_ sender: UIButton) {
        let strPin = sender.titleLabel?.text
        
        if(pincodeArray.count <= PIN_MAX) {
            pincodeArray.append(strPin!)
            self.changePinView()
        }
        if(pincodeArray.count == PIN_MAX) {
            if(self.checkWithSavedPinCode()){
                Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(self.gotoMainview), userInfo: nil, repeats: false)
            } else {
                txtTitle.text = "ERROR"
                txtError.isHidden = false
                txtTitle.textColor = Constants.Colors.MainColor
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            }
        }
    }
    @objc func keyboardCancel(_ sender: UIButton) {
        txtTitle.text = "ENTER A PIN"
        txtError.isHidden = true
        txtTitle.textColor = Constants.Colors.BlackColor
        pincodeArray.removeAll()
        self.changePinView()
    }
    @objc func keyboardEnter(_ sender: UIButton) {
        if(pincodeArray.count > 0) {
            pincodeArray.removeLast()
            self.changePinView()
        }
        if(pincodeArray.count < PIN_MAX){
            txtTitle.text = "ENTER A PIN"
            txtError.isHidden = true
            txtTitle.textColor = Constants.Colors.BlackColor
        }
    }
    
    func changePinView() {
        for i in 0 ... PIN_MAX - 1 {
            let tmpPin = pinArray[i] as UIImageView?
            if(i < pincodeArray.count) {
                tmpPin?.image = UIImage.init(named: "pass")
            }else {
                tmpPin?.image = UIImage.init(named: "unpass")
            }
        }
    }
    
    func checkWithSavedPinCode() -> Bool {
        var encryptionKey = String()
        for i in 0 ... self.pincodeArray.count - 1
        {
            encryptionKey.append(self.pincodeArray[i])
        }
        let savedKey = UserData.loadKeyData(Constants.DefaultsKeys.kKeyEncryptedKey)
        if(savedKey == encryptionKey){
            return true
        }
        return false
    }
    
    @objc func gotoMainview() {
        UserData.saveKeyData(Constants.DefaultsKeys.kKeyTutorialPass, value: Constants.YES)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeViewController = storyboard.instantiateViewController(withIdentifier: "SWRevealVC")
        
        let window = UIApplication.shared.keyWindow
        if let window = window {
            UIView.transition(with: window, duration: 0.5, options: .beginFromCurrentState, animations: {
                let oldState: Bool = UIView.areAnimationsEnabled
                UIView.setAnimationsEnabled(false)
                window.rootViewController = homeViewController
                UIView.setAnimationsEnabled(oldState)
            }, completion: nil)
        }
    }
    
    @IBAction func gotoBack(_ sender: Any) {        
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
}
