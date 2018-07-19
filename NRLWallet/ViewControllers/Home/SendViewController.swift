//
//  SendViewController.swift
//  NRLWallet
//
//  Created by Daniel on 29/05/2018.
//  Copyright © 2018 NoRestLabs. All rights reserved.
//

import UIKit
import NRLWalletSDK
import XLPagerTabStrip
import DropDown
import Alamofire
import BigInt
import SVProgressHUD
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
    
    var baseCoinModel : CoinModel?
    
    var feeSlow : Float = 0.0
    var feeFast : Float = 0.0
    var feeMedium : Float = 0.0
    var dropDown = DropDown()
    var ethTokens : [ETHToken] = []
    var curToken : ETHToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initETHTokens()
        self.initViews()
        self.setupDelegate()
        self.setupViews()
        self.getETHBallances()
        self.fetchConversionRates()
        self.getTransferFee()
        self.addDoneCancelToolbar()
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title:"Send")
    }
    
    func initETHTokens () {
        self.ethTokens.append(ETHToken(name: "Ethereum", symbol: "ETH", address: "", decimal: 18))
        self.ethTokens.append(ETHToken(name: "TRONix", symbol: "TRON", address: "0xf230b790e05390fc8295f4d3f60332c93bed42e2", decimal: 6))
        self.ethTokens.append(ETHToken(name: "VeChain", symbol: "VEN", address: "0xd850942ef8811f2a866692a623011bde52a462c1", decimal: 18))
        self.ethTokens.append(ETHToken(name: "Binance Coin", symbol: "BNB", address: "0xB8c77482e45F1F44dE1745F52C74426C631bDD52", decimal: 18))
        self.ethTokens.append(ETHToken(name: "OmiseGO", symbol: "OMG", address: "0xd26114cd6EE289AccF82350c8d8487fedB8A0C07", decimal: 18))
        self.ethTokens.append(ETHToken(name: "Zilliqa", symbol: "ZIL", address: "0x05f4a42e251f2d52b8ed15e9fedaacfcef1fad27", decimal: 12))
        self.ethTokens.append(ETHToken(name: "Aeternity", symbol: "AE", address: "0x5ca9a71b1d01849c0a95490cc00559717fcf0d1d", decimal: 18))
        self.ethTokens.append(ETHToken(name: "ZRX", symbol: "ZRX", address: "0xe41d2489571d322189246dafa5ebde1f4699f498", decimal: 18))
        self.ethTokens.append(ETHToken(name: "Bytom", symbol: "BTM", address: "0xcb97e65f07da24d46bcdd078ebebd7c6e6e3d750", decimal: 8))
        self.ethTokens.append(ETHToken(name: "RHOC", symbol: "RHOC", address: "0x168296bb09e24a88805cb9c33356536b980d3fc5", decimal: 8))
        self.ethTokens.append(ETHToken(name: "REP", symbol: "REP", address: "0xe94327d07fc17907b4db788e5adf2ed424addff6", decimal: 18))
        self.ethTokens.append(ETHToken(name: "Maker", symbol: "MKR", address: "0x9f8f72aa9304c8b593d555f12ef6589cc3a579a2", decimal: 18))
        self.ethTokens.append(ETHToken(name: "Populous", symbol: "PPT", address: "0xd4fa1460f537bb9085d22c7bccb5dd450ef28e3a", decimal: 8))
        self.ethTokens.append(ETHToken(name: "Golem", symbol: "GNT", address: "0xa74476443119A942dE498590Fe1f2454d7D4aC0d", decimal: 18))
        self.ethTokens.append(ETHToken(name: "IOSToken", symbol: "IOST", address: "0xfa1a856cfa3409cfa145fa4e20eb270df3eb21ab", decimal: 18))
        self.ethTokens.append(ETHToken(name: "StatusNetwork", symbol: "SNT", address: "0x744d70fdbe2ba4cf95131626614a1763df805b9e", decimal: 18))
        self.ethTokens.append(ETHToken(name: "Walton", symbol: "WTC", address: "0xb7cb1c96db6b22b0d3d9536e0108d062bd488f74", decimal: 18))
        self.ethTokens.append(ETHToken(name: "AION", symbol: "AION", address: "0x4CEdA7906a5Ed2179785Cd3A40A69ee8bc99C466", decimal: 8))
        self.ethTokens.append(ETHToken(name: "DigixDAO", symbol: "DGD", address: "0xe0b7927c4af23765cb51314a0e0521a9645f0e2a", decimal: 9))
        self.ethTokens.append(ETHToken(name: "Nebulas", symbol: "NAS", address: "0x5d65D971895Edc438f465c17DB6992698a52318D", decimal: 18))
        self.ethTokens.append(ETHToken(name: "Loopring", symbol: "LRC", address: "0xef68e7c694f40c8202821edf525de3782458639f", decimal: 18))
        self.ethTokens.append(ETHToken(name: "BAT", symbol: "BAT", address: "0x0d8775f648430679a709e98d2b0cb6250d2887ef", decimal: 18))
        self.ethTokens.append(ETHToken(name: "ELF", symbol: "ELF", address: "0xbf2179859fc6d5bee9bf9158632dc51678a4100e", decimal: 18))
        self.ethTokens.append(ETHToken(name: "Dentacoin", symbol: "DCN", address: "0x08d32b0da63e2C3bcF8019c9c5d849d7a9d791e6", decimal: 0))
        self.ethTokens.append(ETHToken(name: "Loom", symbol: "LOOM", address: "0xa4e8c3ec456107ea67d3075bf9e3df3a75823db0", decimal: 18))
        self.ethTokens.append(ETHToken(name: "KyberNetwork", symbol: "KNC", address: "0xdd974d5c2e2928dea5f71b9825b8b646686bd200", decimal: 18))
        self.ethTokens.append(ETHToken(name: "Ethos", symbol: "ETHOS", address: "0x5af2be193a6abca9c8817001f45744777db30756", decimal: 8))
        self.ethTokens.append(ETHToken(name: "Substratum", symbol: "SUB", address: "0x12480e24eb5bec1a9d4369cab6a80cad3c0a377a", decimal: 2))
        self.ethTokens.append(ETHToken(name: "Bancor", symbol: "BNT", address: "0x1f573d6fb3f13d689ff844b4ce37794d79a7ff1c", decimal: 18))
        self.ethTokens.append(ETHToken(name: "Polymath", symbol: "POLY", address: "0x9992ec3cf6a55b00978cddf2b27bc6882d88d1ec", decimal: 18))
        self.ethTokens.append(ETHToken(name: "QASH", symbol: "QASH", address: "0x618e75ac90b12c6049ba3b27f5d5f8651b0037f6", decimal: 6))
        self.ethTokens.append(ETHToken(name: "FunFair", symbol: "FUN", address: "0x419d0d8bdd9af5e606ae2232ed285aff190e711b", decimal: 8))
        self.ethTokens.append(ETHToken(name: "Fusion", symbol: "FSN", address: "0xd0352a019e9ab9d757776f532377aaebd36fd541", decimal: 18))
        self.ethTokens.append(ETHToken(name: "Dragon", symbol: "DRGN", address: "0x419c4db4b9e25d6db2ad9691ccb832c8d9fda05e", decimal: 18))
        self.ethTokens.append(ETHToken(name: "Cortex Coin", symbol: "CTXC", address: "0xea11755ae41d889ceec39a63e6ff75a02bc1c00d", decimal: 18))
        self.ethTokens.append(ETHToken(name: "Enigma", symbol: "ENG", address: "0xf0ee6b27b759c9893ce4f094b49ad28fd15a23e4", decimal: 8))
        self.ethTokens.append(ETHToken(name: "HuobiToken", symbol: "HT", address: "0x6f259637dcd74c767781e37bc6133cd6a68aa161", decimal: 18))
        self.ethTokens.append(ETHToken(name: "Nexo", symbol: "NEXO", address: "0xb62132e35a6c13ee1ee0f84dc5d40bad8d815206", decimal: 18))
        self.ethTokens.append(ETHToken(name: "Storm", symbol: "STORM", address: "0xd0a4b8946cb52f0661273bfbc6fd0e0c75fc6433", decimal: 18))
        self.ethTokens.append(ETHToken(name: "Nuls", symbol: "NULS", address: "0xb91318f35bdb262e9423bc7c7c2a3a93dd93c92c", decimal: 18))
        self.ethTokens.append(ETHToken(name: "Salt", symbol: "SALT", address: "0x4156D3342D5c385a87D264F90653733592000581", decimal: 8))
        self.ethTokens.append(ETHToken(name: "ICON", symbol: "ICX", address: "0xb5a5f22694352c15b00323844ad545abb2b11028", decimal: 18))
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
        
        dropDown.anchorView = btt_coinname
        dropDown.width = 200
        dropDown.cellNib = UINib(nibName: "BalanceDropDownCell", bundle: nil)
        dropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            guard let cell = cell as? BalanceDropDownCell else { return }
            var imageName = "ethereum"
            if(self.baseCoinModel?.symbol == "ETH") {
                imageName = "ethereum"
            } else if(self.baseCoinModel?.symbol == "NEO") {
                imageName = "neo"
            } else if (self.baseCoinModel?.symbol == "XLM") {
                imageName = "stellar"
            }
            cell.optionImage.image = UIImage(named: imageName)
            // Setup your custom UI components
        }
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.selectETHToken(symbol: item)
        }
    }
    
    func selectETHToken(symbol: String) {
        for token in self.ethTokens {
            if(token.symbol == symbol) {
                self.curToken = token
                self.btt_coinname.titleLabel?.text = String(format: "%@(%@)", token.name, token.symbol)
            }
        }
    }
    
    
    @IBAction func clickCoin(_ sender: Any) {
        dropDown.show()
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
    
    @IBAction func clickSend(_ sender: Any) {
        let to = txt_receiveAddress.text
        let value = txt_fromCoin.text
        
        if(to?.isEmpty ?? true) {
            print("Plaese input address")
            return
        }
        
        if(value?.isEmpty ?? true) {
            print("Please input value")
            return
        }
        
        if(self.baseCoinModel?.symbol == "BTC" || self.baseCoinModel?.symbol == "LTC") {
            let amount = Decimal(string: txt_fromCoin.text!)
            let unitDecimal = Decimal(sign: FloatingPointSign.plus, exponent: 8, significand: Decimal(1))
            print((amount!*unitDecimal).description)
            
            SVProgressHUD.show()
            self.baseCoinModel?.wallet.sendTransaction(to: to!, value: UInt64((amount! * unitDecimal).description)!, fee: UInt64(slider_speed.value)) { (err, tx) -> () in
                switch (err) {
                case .nrlSuccess:
                    SVProgressHUD.dismiss()
                    self.toastMessage(str: "Successfully sent transaction. tx: \(tx)")
                default:
                    SVProgressHUD.dismiss()
                    self.toastMessage(str: "Failed transaction: \(err)")
                }
            }
        } else if(self.baseCoinModel?.symbol == "ETH") {
            if(self.curToken != nil) {
                let amount = Decimal(string: txt_fromCoin.text!)
                let fee = Decimal(Double(slider_speed.value))
                let amountUnit = Decimal(sign: FloatingPointSign.plus, exponent: (self.curToken?.decimal)!, significand: Decimal(1))
                let feeUnit = Decimal(sign: FloatingPointSign.plus, exponent: 9, significand: Decimal(1))
                
                SVProgressHUD.show()
                self.baseCoinModel?.wallet.sendTransaction(contractHash: (self.curToken?.address)!, to: to!, value: BigUInt((amount! * amountUnit).description)! , fee: BigUInt((fee * feeUnit).description)!) { (err, tx) -> () in
                    switch (err) {
                    case .nrlSuccess:
                        SVProgressHUD.dismiss()
                        self.toastMessage(str: "Successfully sent transaction. tx: \(tx)")
                    default:
                        SVProgressHUD.dismiss()
                        self.toastMessage(str: "Failed transaction: \(err)")
                    }
                }
            } else {
                print("Please choose a ERC20 Token")
            }
            
            
        } else if(self.baseCoinModel?.symbol == "XLM") {
            SVProgressHUD.show()
            self.baseCoinModel?.wallet.sendTransaction(to: to!, value: (value as! NSString).doubleValue, fee: 0.0) { (err, tx) -> () in
                switch (err) {
                case .nrlSuccess:
                    SVProgressHUD.dismiss()
                    self.toastMessage(str: "Successfully sent transaction. tx: \(tx)")
                default:
                    SVProgressHUD.dismiss()
                    self.toastMessage(str: "Failed transaction: \(err)")
                }
                
            }
        } else if(self.baseCoinModel?.symbol == "NEO") {
            
            if let valueDecimal  = Decimal(string: value!) {
                SVProgressHUD.show()
                self.baseCoinModel?.wallet.sendTransaction(asset: AssetId.neoAssetId , to: to!, value: valueDecimal, fee: Decimal(floatLiteral: 0.0)) { (err, tx) -> () in
                    switch (err) {
                    case .nrlSuccess:
                        SVProgressHUD.dismiss()
                        self.toastMessage(str: "Successfully sent transaction. tx: \(tx)")
                    default:
                        SVProgressHUD.dismiss()
                        self.toastMessage(str: "Failed transaction: \(err)")
                    }
                }
            } else {
                print("Invalid value input")
            }
        }
    }
    
    @IBAction func onFeeChange(_ sender: Any) {
        self.calculateFee()
    }
    
    func calculateFee() {
        //        let fee = Decimal(Double(self.slider_speed.value))
        //        var feeUnit = Decimal(0)
        //        if(self.baseCoinModel?.symbol == "BTC") {
        //            feeUnit = Decimal(sign: FloatingPointSign.plus, exponent: -8, significand: Decimal(1))
        //        } else if(self.baseCoinModel?.symbol == "ETH") {
        //            feeUnit = Decimal(sign: FloatingPointSign.plus, exponent: -9, significand: Decimal(1))
        //        }
        //
        //        print(fee.description, feeUnit.description, (fee * feeUnit).description)
        //        self.lb_transactionFee.text = String(format: "%@ %@", (fee * feeUnit).description, (self.baseCoinModel?.symbol)!)
        if(self.baseCoinModel?.symbol == "BTC") {
            self.lb_transactionFee.text = String(format: "%f %@", self.slider_speed.value, "sat")
        } else if(self.baseCoinModel?.symbol == "ETH") {
            self.lb_transactionFee.text = String(format: "%f %@", self.slider_speed.value, "gwei")
        }
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
    
    @IBAction func amountChanged(_ sender: Any) {
        if let amount = Double(self.txt_fromCoin.text!) {
            var price : Double = 0.0
            if(self.baseCoinModel?.symbol == "ETH") {
                price = AppController.shared.getConversionRate(symbol: (self.curToken?.symbol)!)
            } else {
                price = AppController.shared.getConversionRate(symbol: (self.baseCoinModel?.symbol)!)
            }
            let usdAmount = amount * price
            self.txt_toCoin.text = String(usdAmount)
        }
    }
    
    @IBAction func usdAmountChanged(_ sender: Any) {
        if let usdAmount = Double(self.txt_toCoin.text!) {
            var price : Double = 0.0
            if(self.baseCoinModel?.symbol == "ETH") {
                price = AppController.shared.getConversionRate(symbol: (self.curToken?.symbol)!)
            } else {
                price = AppController.shared.getConversionRate(symbol: (self.baseCoinModel?.symbol)!)
            }
            let coinAmount = usdAmount / price
            self.txt_fromCoin.text = String(coinAmount)
        }
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
    
    func getETHBallances() {
        if(self.baseCoinModel?.symbol == "ETH") {
            self.baseCoinModel?.wallet?.getWalletBalance() { (err, value) -> () in
                switch (err) {
                case .nrlSuccess:
                    let balances = value as! NSArray
                    
                    var dropdownDataSource: [String] = []
                    for item in balances {
                        let balanceItem = item as! ETHGetBalanceMap
                        dropdownDataSource.append(balanceItem.symbol!)
                    }
                    self.dropDown.dataSource = dropdownDataSource
                    self.selectETHToken(symbol: dropdownDataSource[0])
                    print("Success")
                case .responseError(.unexpected(let error)):
                    print("Server request error: \(error)")
                case .responseError(.connectionError(let error)):
                    print("Server connection error: \(error)")
                default:
                    print("Failed: \(String(describing: err))")
                }
            }
        }
    }
    
    func fetchConversionRates() {
        Alamofire.request(Constants.URL_GET_CONVERSION_RATE, method: .get).responseJSON { (response) in
            switch response.result {
            case .success:
                if let json = try? JSONSerialization.jsonObject(with: response.data!, options: []) {
                    if let dict = json as? [String: Any], let dataDict = dict["data"] as? [String: Any] {
                        AppController.shared.conversionRates.removeAll()
                        for (id, item) in dataDict {
                            if let itemDict = item as? [String: Any] {
                                let price = ((itemDict["quotes"] as! [String:Any])["USD"] as! [String:Any])["price"]
                                print(itemDict, price)
                                AppController.shared.conversionRates.append(ConversionRate(id: itemDict["id"] as! Int, name: itemDict["name"] as! String, symbol: itemDict["symbol"] as! String, price: (price as! NSNumber).doubleValue))
                            }
                        }
                    }
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
