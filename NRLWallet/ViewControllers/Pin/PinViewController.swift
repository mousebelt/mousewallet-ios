//
//  PinViewController.swift
//  NRLWallet
//
//  Created by admin on 25/05/2018.
//  Copyright © 2018 NoRestLabs. All rights reserved.
//

import UIKit

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
        for i in 0 ... 9 {
            let tmpBtt = self.keyboardArray[i] as UIButton!
            tmpBtt?.layer.cornerRadius = (tmpBtt?.frame.size.height)!/2
            tmpBtt?.layer.borderWidth = 1
            tmpBtt?.layer.borderColor = Constants.Colors.BorderColor.cgColor
            tmpBtt?.addTarget(self, action: #selector(KeyboardClick(_ :)), for: .touchUpInside)
        }
        cancel.addTarget(self, action: #selector(self.keyboardCancel(_ :)), for: .touchUpInside)
        enter.addTarget(self, action: #selector(self.keyboardEnter(_ :)), for: .touchUpInside)
        self.formatPinView()
        
    }
    
    @objc func KeyboardClick(_ sender: UIButton) {
        let strPin = sender.titleLabel?.text
        if(PIN_STATE == 0) {
            if(pincodeArray.count <= PIN_MAX) {
                pincodeArray.append(strPin!)
                self.changePinView()
            }
        }else if(PIN_STATE == 1) {
            if(pincodeConfirmArray.count <= PIN_MAX) {
                pincodeConfirmArray.append(strPin!)
                self.changePinView()
            }
            if(pincodeConfirmArray.count == PIN_MAX) {   //check confirm
                if(self.checkConfirmPin()) {
                    //success
                    self.gotoMainview()
                } else{
                    txtTitle.text = "ERROR"
                    txtTitle.textColor = Constants.Colors.ErrorColor
                }
            } else {
                txtTitle.text = "VERIFY YOUR PIN"
                txtTitle.textColor = Constants.Colors.BlackColor
                
            }
        }
    }
    @objc func keyboardCancel(_ sender: UIButton) {
        if(PIN_STATE == 0) {
            if(pincodeArray.count > 0) {
                pincodeArray.removeLast()
                self.changePinView()
            }
        }else if(PIN_STATE == 1) {
            if(pincodeConfirmArray.count > 0) {
                pincodeConfirmArray.removeLast()
                self.changePinView()
            }
            
        }
        
    }
    @objc func keyboardEnter(_ sender: UIButton) {
        if(pincodeArray.count == PIN_MAX){
            if(PIN_STATE == 0) {
                PIN_STATE = 1
                txtTitle.text = "VERIFY YOUR PIN"
                pincodeConfirmArray.removeAll()
                self.formatPinView()
            }else if(PIN_STATE == 1) {

            }
        }
        
    }
    
    func changePinView() {
        if(PIN_STATE == 0) {
            for i in 0 ... PIN_MAX - 1 {
                let tmpPin = pinArray[i] as UIImageView!
                if(i < pincodeArray.count) {
                    tmpPin?.image = UIImage.init(named: "pass")
                }else {
                    tmpPin?.image = UIImage.init(named: "unpass")
                }
            }
        }else if(PIN_STATE == 1) {
            for i in 0 ... PIN_MAX - 1 {
                let tmpPin = pinArray[i] as UIImageView!
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
            let tmpPin = pinArray[i] as UIImageView!
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
    
    func gotoMainview() {        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeViewController = storyboard.instantiateViewController(withIdentifier: "SWRevealVC")
        
        let window = UIApplication.shared.keyWindow
        if let window = window {
            UIView.transition(with: window, duration: 0.0, options: .transitionFlipFromBottom, animations: {
                let oldState: Bool = UIView.areAnimationsEnabled
                UIView.setAnimationsEnabled(true)
                window.rootViewController = homeViewController
                UIView.setAnimationsEnabled(oldState)
            }, completion: nil)
        }
    }
    

}
