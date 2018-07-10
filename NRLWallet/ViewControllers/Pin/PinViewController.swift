//
//  PinViewController.swift
//  NRLWallet
//
//  Created by Daniel on 25/05/2018.
//  Copyright © 2018 NoRestLabs. All rights reserved.
//

import UIKit
//import RNCryptor
//import NRLWalletSDK
import AudioToolbox

class PinViewController: UIViewController {
    
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
    
    //for wallet
    var mnemonicInitial : [String]!
    var encryptedMessage : String!
    var encryptedKey : String!
    
    //for pin view
    var pinArray : Array<UIImageView> = []
    var keyboardArray : Array<UIButton> = []
    var pincodeArray : Array<String> = []
    var pincodeConfirmArray : Array<String> = []
    let PIN_MAX = 6
    var PIN_STATE = 0 //0 : insert pin, 1 : confirm pin, 2 : match
    
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
    
    @objc func updateStateView() {
        txtTitle.text = "VERIFY YOUR PIN"
        txtError.isHidden = true
        txtTitle.textColor = Constants.Colors.BlackColor
        PIN_STATE = 1
        pincodeConfirmArray.removeAll()
        self.changePinView()
    }
    
    @objc func KeyboardClick(_ sender: UIButton) {
        let strPin = sender.titleLabel?.text
        if(PIN_STATE == 0) {
            if(pincodeArray.count <= PIN_MAX) {
                pincodeArray.append(strPin!)
                self.changePinView()
            }
            if(pincodeArray.count == PIN_MAX) {
                Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(self.updateStateView), userInfo: nil, repeats: false)
            }
        }else if(PIN_STATE == 1) {
            if(pincodeConfirmArray.count < PIN_MAX) {
                pincodeConfirmArray.append(strPin!)
                self.changePinView()
            }
            if(pincodeConfirmArray.count == PIN_MAX) {   //check confirm
                if(self.checkConfirmPin()) {
                    //success
                    PIN_STATE = 2
                    Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(self.gotoMainview), userInfo: nil, repeats: false)
                } else{
                    txtTitle.text = "ERROR"
                    txtError.isHidden = false
                    txtTitle.textColor = Constants.Colors.MainColor
                    AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                }
            } else {
                txtTitle.text = "VERIFY YOUR PIN"
                txtError.isHidden = true
                txtTitle.textColor = Constants.Colors.BlackColor
            }
        }
    }
    @objc func keyboardCancel(_ sender: UIButton) {
        txtTitle.text = "ENTER A PIN"
        txtError.isHidden = true
        txtTitle.textColor = Constants.Colors.BlackColor
        PIN_STATE = 0
        pincodeArray.removeAll()
        pincodeConfirmArray.removeAll()
        self.changePinView()
    }
    
    /// Backspace function
    ///
    /// - Parameter sender: UIButton
    @objc func keyboardEnter(_ sender: UIButton) {
        if(PIN_STATE == 0) {
            if(pincodeArray.count > 0) {
                pincodeArray.removeLast()
                self.changePinView()
            }
        }else if(PIN_STATE == 1) {
            txtTitle.text = "VERIFY YOUR PIN"
            txtError.isHidden = true
            txtTitle.textColor = Constants.Colors.BlackColor
            if(pincodeConfirmArray.count > 0) {
                pincodeConfirmArray.removeLast()
                self.changePinView()
            }
        }
    }
    
    func changePinView() {
        if(PIN_STATE == 0) {
            for i in 0 ... PIN_MAX - 1 {
                let tmpPin = pinArray[i] as UIImageView?
                if(i < pincodeArray.count) {
                    tmpPin?.image = UIImage.init(named: "pass")
                }else {
                    tmpPin?.image = UIImage.init(named: "unpass")
                }
            }
        }else if(PIN_STATE == 1) {
            for i in 0 ... PIN_MAX - 1 {
                let tmpPin = pinArray[i] as UIImageView?
                if(i < pincodeConfirmArray.count) {
                    tmpPin?.image = UIImage.init(named: "pass")
                }else {
                    tmpPin?.image = UIImage.init(named: "unpass")
                }
            }
        }
    }
    
    func formatPinView() {
        for i in 0 ... PIN_MAX - 1 {
            let tmpPin = pinArray[i] as UIImageView?
            tmpPin?.image = UIImage.init(named: "unpass")
        }
    }
    
    func checkConfirmPin() -> Bool {
        for i in 0 ... PIN_MAX - 1 {
            if(pincodeArray[i] != pincodeConfirmArray[i]) {
                return false
            }
        }
        return true
    }
    
    func prepairEncrypt() -> String {
        var encryptionKey = String()
        for i in 0 ... 5
        {
            encryptionKey.append(self.pincodeArray[i])
        }
        self.encryptedKey = encryptionKey
        var message = String()
        for i in 0 ... self.mnemonicInitial.count - 1
        {
            message.append(self.mnemonicInitial[i])
            if(i != self.mnemonicInitial.count-1){
                message.append(" ")                
            }
        }
        do {
            let encryptedMessage = try AppController.shared.encryptMessage(message: message, encryptionKey: encryptionKey)
            return encryptedMessage
        }
        catch {
            print(error)
            return ""
        }
    }
    
    @objc func gotoMainview() {
        self.encryptedMessage = self.prepairEncrypt()
        //save encrypted Message and Key to app storage
        UserData.saveKeyData(Constants.DefaultsKeys.kKeyTutorialPass, value: Constants.YES)
        UserData.saveKeyData(Constants.DefaultsKeys.kKeyEncryptedMessage, value: self.encryptedMessage)
        UserData.saveKeyData(Constants.DefaultsKeys.kKeyEncryptedKey, value: self.encryptedKey)
        UserData.saveKeyData(Constants.DefaultsKeys.kKeyIsNewAccount, value: Constants.YES)
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
    

}
