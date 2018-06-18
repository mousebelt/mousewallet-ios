//
//  SendViewController.swift
//  NRLWallet
//
//  Created by Daniel on 29/05/2018.
//  Copyright © 2018 NoRestLabs. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import DropDown

class SendViewController: UIViewController, IndicatorInfoProvider {

    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var img_coin: UIImageView!
    @IBOutlet weak var btt_coinname: UIButton!
    
    @IBOutlet weak var txt_receiveAddress: UITextField!
    
    @IBOutlet weak var txt_fromCoin: UITextField!
    @IBOutlet weak var txt_toCoin: UITextField!
    
    @IBOutlet weak var lb_balance: UILabel!
    
    @IBOutlet weak var txt_memo: UITextField!
    
    @IBOutlet weak var lb_transactionFee: UILabel!
    @IBOutlet weak var slider_speed: UISlider!
    
    @IBOutlet weak var btt_send: UIButton!
    
    let dropDownCoin = DropDown()
    var baseCoinModel : CoinModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupDelegate()
        self.setupViews()
        self.addDoneCancelToolbar()
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title:"Send")
    }
    
    func setupDelegate() {
        self.txt_receiveAddress.delegate = self
        self.txt_memo.delegate = self
        self.txt_fromCoin.delegate = self
        self.txt_toCoin.delegate = self
    }
    
    func setupViews() {
        self.backgroundView.layer.cornerRadius = Constants.Consts.CornerRadius!
        self.backgroundView.layer.borderColor = Constants.Colors.BorderColor1.cgColor
        self.backgroundView.layer.borderWidth = Constants.Consts.BorderWidth!
        
        self.btt_send.layer.cornerRadius = Constants.Consts.CornerRadius!
        
        self.slider_speed.setThumbImage(UIImage(named: "oval"), for: .normal)
        self.slider_speed.setThumbImage(UIImage(named: "oval"), for: .selected)
        self.slider_speed.setThumbImage(UIImage(named: "oval"), for: .highlighted)
        
        dropDownCoin.anchorView = btt_coinname
        dropDownCoin.dataSource = ["Bitcoin", "Ethereum", "OmiseGo"]
        
        dropDownCoin.selectionAction = { [weak self] (index, item) in
            let coindata = AppController.shared.coinArray[index]
            self?.btt_coinname.titleLabel?.text = String(format:"%@(%@)", (coindata.symbol)!, (coindata.fullname)!)
            self?.img_coin.image = UIImage(named: coindata.image)
        }
    }
    
    
    @IBAction func clickCoin(_ sender: Any) {
        dropDownCoin.show()
    }
    
    @IBAction func clickSlow(_ sender: Any) {
        self.slider_speed.setValue(0.0, animated: true)
    }
    
    @IBAction func clickMedium(_ sender: Any) {
        self.slider_speed.setValue(0.5, animated: true)
    }
    
    @IBAction func clickFast(_ sender: Any) {
        self.slider_speed.setValue(1.0, animated: true)
    }
    
    @IBAction func clickSend(_ sender: Any) {
    }
    
    // Default actions:
    @objc func doneButtonTapped() {
        self.txt_fromCoin.resignFirstResponder()
        self.txt_toCoin.resignFirstResponder()
    }
    @objc func cancelButtonTapped() {
        self.txt_fromCoin.resignFirstResponder()
        self.txt_toCoin.resignFirstResponder()
    }
    func addDoneCancelToolbar(onDone: (target: Any, action: Selector)? = nil, onCancel: (target: Any, action: Selector)? = nil) {
        let onCancel = onCancel ?? (target: self, action: #selector(cancelButtonTapped))
        let onDone = onDone ?? (target: self, action: #selector(doneButtonTapped))
        
        let toolbar: UIToolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.items = [
            UIBarButtonItem(title: "Cancel", style: .plain, target: onCancel.target, action: onCancel.action),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: onDone.target, action: onDone.action)
        ]
        toolbar.sizeToFit()
        self.txt_fromCoin.inputAccessoryView = toolbar
        self.txt_toCoin.inputAccessoryView = toolbar
    }
}
// MARK: - TextFieldDelegate
//
extension SendViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()        
        return true
    }
}
