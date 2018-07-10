//
//  SendViewController.swift
//  NRLWallet
//
//  Created by Daniel on 29/05/2018.
//  Copyright © 2018 NoRestLabs. All rights reserved.
//

import UIKit
//import NRLWalletSDK
import XLPagerTabStrip
import DropDown
import Alamofire
import BigInt

class SendViewController: UIViewController, IndicatorInfoProvider {
    
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var img_coin: UIImageView!
    @IBOutlet weak var btt_coinname: UIButton!
    
    @IBOutlet weak var txt_receiveAddress: UITextField!
    
    @IBOutlet weak var txt_fromCoin: UITextField!
    @IBOutlet weak var txt_toCoin: UITextField!
    
    @IBOutlet weak var lb_balance: UILabel!
    
    @IBOutlet weak var txt_memo: UITextField!
    
    @IBOutlet weak var viewTransactionFee: UIView!
    @IBOutlet weak var lb_transactionFee: UILabel!
    @IBOutlet weak var slider_speed: UISlider!
    
    @IBOutlet weak var btt_send: UIButton!
    
    let dropDownCoin = DropDown()
    var baseCoinModel : CoinModel?
    
    var feeSlow : Float = 0.0
    var feeFast : Float = 0.0
    var feeMedium : Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initViews()
        self.setupDelegate()
        self.setupViews()
        self.getConversionRate()
        self.getTransferFee()
        self.addDoneCancelToolbar()
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title:"Send")
    }
    
    func initViews() {
        //        self.btt_coinname.titleLabel?.text = String(format:"%@(%@)", (baseCoinModel?.symbol)!, (baseCoinModel?.fullname)!)
        self.btt_coinname.setTitle(String(format:"%@(%@)", (baseCoinModel?.symbol)!, (baseCoinModel?.fullname)!), for: [])
        self.img_coin.image = UIImage(named: (baseCoinModel?.image)!)
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
        
        self.txt_fromCoin.placeholder = self.baseCoinModel?.symbol
        
        dropDownCoin.anchorView = btt_coinname
        //        dropDownCoin.dataSource = ["Bitcoin", "Ethereum", "OmiseGo"]
        //
        //        dropDownCoin.selectionAction = { [weak self] (index, item) in
        //            let coindata = AppController.shared.coinArray[index]
        //            self?.btt_coinname.titleLabel?.text = String(format:"%@(%@)", (coindata.symbol)!, (coindata.fullname)!)
        //            self?.img_coin.image = UIImage(named: coindata.image)
        //        }
    }
    
    
    @IBAction func clickCoin(_ sender: Any) {
        dropDownCoin.show()
    }
    
    @IBAction func clickSlow(_ sender: Any) {
        self.slider_speed.setValue(self.feeSlow, animated: true)
        self.calculateFee()
    }
    
    @IBAction func clickMedium(_ sender: Any) {
        self.slider_speed.setValue((self.feeFast+self.feeSlow)/2.0, animated: true)
        self.calculateFee()
    }
    
    @IBAction func clickFast(_ sender: Any) {
        self.slider_speed.setValue(self.feeFast, animated: true)
        self.calculateFee()
    }
    
    func getFeeValue(value: Float) -> BigUInt {
        var dCount: Int = 0;
        var tVal = value;
        while(tVal != Float(Int(tVal))) {
            tVal *= 10.0;
            dCount = dCount + 1
        }
        return ((BigUInt("10")?.power(9-dCount))! * BigUInt(Int(tVal)))
    }
    
    func getAmountValue(value: Float, decimal: Int) -> BigUInt {
        var dCount: Int = 0;
        var tVal = value;
        while(tVal != Float(Int(tVal))) {
            tVal *= 10.0;
            dCount = dCount + 1
        }
        return ((BigUInt("10")?.power(decimal-dCount))! * BigUInt(Int(tVal)))
    }
    
    @IBAction func clickSend(_ sender: Any) {
        let to = txt_receiveAddress.text
        let value = (txt_fromCoin.text as! NSString).floatValue
        let fee = self.slider_speed.value
        
        self.baseCoinModel?.wallet.sendTransaction(contractHash: "0x1f573d6fb3f13d689ff844b4ce37794d79a7ff1c", to: to!, value: self.getFeeValue(value: fee), fee: self.getAmountValue(value: value, decimal: 18)) { (err, tx) -> () in
            print(err, tx)
        }
        //        guard let wallet = coinWallet else {
        //            print("setStellarWallet Error: cannot init wallet!")
        //            return
        //        }
        //
        //        wallet.sendTransaction(to: to!, value: value!, fee: fee!) { (err, tx) -> () in
        //            switch (err) {
        //            case NRLWalletSDKError.nrlSuccess:
        //                self.textTransaction.text = "Successfully sent transaction. tx: \(tx)"
        //            default:
        //                self.textTransaction.text = "Failed: \(err)"
        //            }
        //
        //        }
    }
    
    @IBAction func onFeeChange(_ sender: Any) {
        self.calculateFee()
    }
    
    func calculateFee() {
        let fee = self.slider_speed.value
        self.lb_transactionFee.text = String(format: "%f %@=%f %@", fee, (self.baseCoinModel?.symbol)!, 0.0, "USD")
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
    
    func getConversionRate() {
        Alamofire.request(Constants.URL_GET_CONVERSION_RATE, method: .get).responseJSON { (response) in
            
            switch response.result {
            case .success:
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    print("Conversion rates: \(utf8Text)")
                }
                break
            case .failure:
                break
            }
        }
    }
    
    func getTransferFee() {
        if(self.baseCoinModel?.symbol == "BTC") {
            Alamofire.request(Constants.URL_GET_BTC_FEE, method: .get).responseJSON { (response) in
                
                switch response.result {
                case .success:
                    if let json = try? JSONSerialization.jsonObject(with: response.data!, options: []) {
                        if let dict = json as? [String: Any] {
                            self.feeFast = dict["fastestFee"] as! Float
                            self.feeMedium = dict["halfHourFee"] as! Float
                            self.feeSlow = dict["hourFee"] as! Float
                            self.slider_speed.maximumValue = self.feeFast
                            self.slider_speed.minimumValue = self.feeSlow
                            self.slider_speed.value = self.feeMedium
                            self.calculateFee()
                            self.viewTransactionFee.isHidden = false
                        }
                    }
                    break
                case .failure:
                    break
                }
            }
        } else if(self.baseCoinModel?.symbol == "ETH") {
            Alamofire.request(Constants.URL_GET_ETH_FEE, method: .get).responseJSON { (response) in
                switch response.result {
                case .success:
                    if let json = try? JSONSerialization.jsonObject(with: response.data!, options: []) {
                        if let dict = json as? [String: Any] {
                            self.feeFast = Float(dict["fastest"] as! String)!
                            self.feeMedium = Float(dict["standard"] as! String)!
                            self.feeSlow = Float(dict["safeLow"] as! String)!
                            self.slider_speed.maximumValue = self.feeFast
                            self.slider_speed.minimumValue = self.feeSlow
                            self.slider_speed.value = self.feeMedium
                            self.calculateFee()
                            self.viewTransactionFee.isHidden = false
                        }
                    }
                    break
                case .failure:
                    break
                }
            }
        }
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
