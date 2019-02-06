//
//  SwapViewController.swift
//  NRLWallet
//
//  Created by Daniel on 29/05/2018.
//  Copyright © 2018 NoRestLabs. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import DropDown
import Alamofire
import SVProgressHUD
import BigInt

class SwapViewController: UIViewController, IndicatorInfoProvider {
    
    @IBOutlet weak var background_view: UIView!
    //From Coin
    @IBOutlet weak var img_fromCoin: UIImageView!
    @IBOutlet weak var btt_fromCoinName: UIButton!
    @IBOutlet weak var lb_fromCoinSymbol: UILabel!
    @IBOutlet weak var lb_fromCoinBalance: UILabel!
    //To Coin
    @IBOutlet weak var img_toCoin: UIImageView!
    @IBOutlet weak var btt_toCoinName: UIButton!
    @IBOutlet weak var lb_toCoinSymbol: UILabel!
    @IBOutlet weak var lb_toCoinBalance: UILabel!
    //Coin Balance
    @IBOutlet weak var lb_CoinBalance: UILabel!
    @IBOutlet weak var lb_CoinPowered: UILabel!
    @IBOutlet weak var lb_ExchangeAvailable: UILabel!
    //Input Coin Value
    @IBOutlet weak var txt_fromCoin: UITextField!
    @IBOutlet weak var txt_toCoin: UITextField!
    //Min/Max Value
    @IBOutlet weak var lb_minMax: UILabel!
    //Transaction Fee
    @IBOutlet weak var lb_transactionFee: UILabel!
    //Slider
    @IBOutlet weak var slider_speed: UISlider!
    //Speed Buttons
    @IBOutlet weak var btt_slow: UIButton!
    @IBOutlet weak var btt_medium: UIButton!
    @IBOutlet weak var btt_fast: UIButton!
    //Send Button
    @IBOutlet weak var btt_send: UIButton!
    
    @IBOutlet weak var viewTransactionFee: UIView!
    @IBOutlet weak var viewAmount: UIView!
    let dropDownFromCoin = DropDown()
    let dropDownToCoin = DropDown()
    var baseCoinModel : CoinModel?
    var isAvailable : Bool = false
    var toCoinArray:  [CoinModel] = [CoinModel]()
    var selectedToCoinIndex = 0
    var marketModel : MarketModel?
    
    var feeSlow : Float = 0.0
    var feeFast : Float = 0.0
    var feeMedium : Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initCoinSetting()
        self.setupViews()
        self.addDoneCancelToolbar()
    }
    
    // MARK: - IndicatorInfoProvider
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title:"Swap")
    }
    
    func initCoinSetting() {
        for coin in AppController.shared.coinArray {
            if(coin.fullname != baseCoinModel?.fullname) {
                toCoinArray.append(coin)
            }
        }
        
        self.getTransferFee()
    }
    
    func setupViews() {
        isAvailable = false
        self.background_view.layer.cornerRadius = Constants.Consts.CornerRadius!
        self.background_view.layer.borderColor = Constants.Colors.BorderColor1.cgColor
        self.background_view.layer.borderWidth = Constants.Consts.BorderWidth!
        
        self.btt_send.layer.cornerRadius = Constants.Consts.CornerRadius!
        
        self.slider_speed.setThumbImage(UIImage(named: "oval"), for: .normal)
        self.slider_speed.setThumbImage(UIImage(named: "oval"), for: .selected)
        self.slider_speed.setThumbImage(UIImage(named: "oval"), for: .highlighted)
        
        self.EnableView()
        self.setupFromView()
        self.setupToView()
    }
    
    func EnableView() {
        if(isAvailable) {
            self.slider_speed.isHidden = false
            self.btt_send.backgroundColor = Constants.Colors.MainColor
        } else {
            self.slider_speed.isHidden = true
            self.btt_send.backgroundColor = Constants.Colors.FontColor
        }
    }
    
    func setupFromView() {
        
        self.img_fromCoin.contentMode = .scaleAspectFit
        self.img_fromCoin.image = UIImage(named: (baseCoinModel?.image)!)
        self.btt_fromCoinName.setTitle(baseCoinModel?.fullname, for: [])
        self.lb_fromCoinSymbol.text = baseCoinModel?.symbol
        self.lb_fromCoinBalance.text = String(format:"$%@",(baseCoinModel?.balance)!)
        
        dropDownFromCoin.anchorView = btt_fromCoinName
        dropDownFromCoin.dataSource = [self.baseCoinModel?.fullname] as! [String]
        
        dropDownFromCoin.selectionAction = { [weak self] (index, item) in
            let coindata = AppController.shared.coinArray[index]
            self?.btt_fromCoinName.titleLabel?.text = coindata.fullname
            self?.lb_fromCoinBalance.text = coindata.balance
            self?.lb_fromCoinSymbol.text = coindata.symbol
            self?.img_fromCoin.image = UIImage(named: coindata.image)
        }
        self.txt_fromCoin.delegate = self
        self.txt_fromCoin.placeholder = self.baseCoinModel?.symbol
        self.txt_fromCoin.text = ""
    }
    
    func setupToView() {
        dropDownToCoin.anchorView = btt_toCoinName
        dropDownToCoin.dataSource = AppController.shared.appCoinModels.filter{$0 != baseCoinModel?.fullname}
        
        dropDownFromCoin.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            guard let cell = cell as DropDownCell? else { return }
            cell.optionLabel.text = item
        }
        
        let tocoin = self.toCoinArray[0]
        
        self.img_toCoin.contentMode = .scaleAspectFit
        self.img_toCoin.image = UIImage(named: (tocoin.image)!)
        self.btt_toCoinName.setTitle(tocoin.fullname, for: [])
        self.lb_toCoinSymbol.text = tocoin.symbol
        self.lb_toCoinBalance.text = String(format: "$%@", tocoin.balance)
        
        self.txt_toCoin.placeholder = tocoin.symbol
        self.txt_toCoin.text = ""
        
        self.getMarketInfo()
        
        dropDownToCoin.selectionAction = { [weak self] (index, item) in
            if(self?.selectedToCoinIndex == index) {
                return
            }
            let coindata = self?.toCoinArray[index]
            self?.selectedToCoinIndex = index
            self?.btt_toCoinName.sizeToFit()
            self?.btt_toCoinName.setTitle(coindata?.fullname, for: [])
            self?.lb_toCoinBalance.text = String(format:"$%@",(coindata?.balance)!)
            self?.lb_toCoinSymbol.text = coindata?.symbol
            self?.img_toCoin.image = UIImage(named: (coindata?.image)!)
            
            self?.txt_fromCoin.placeholder = self?.baseCoinModel?.symbol
            self?.txt_fromCoin.text = ""
            self?.txt_toCoin.placeholder = coindata?.symbol
            self?.txt_toCoin.text = ""
            
            
            self?.getMarketInfo()
        }
        
        self.txt_toCoin.delegate = self
    }
    
    func updateUIValues(update : Bool) {
        if(update) {
//            var fee_usd = (self.marketModel?.minerFee)! * (baseCoinModel?.balance as! NSString).doubleValue
            self.lb_ExchangeAvailable.text = "Exchange Available!"
            self.lb_CoinBalance.text = String(format: "1 %@ = %f %@", (baseCoinModel?.symbol.uppercased())!, (self.marketModel?.rate)!, toCoinArray[selectedToCoinIndex].symbol)
            self.lb_CoinPowered.isHidden = false
            self.lb_minMax.text = String(format: "min: %f %@ max: %f %@", (self.marketModel?.minimum)!, (baseCoinModel?.symbol.uppercased())!, (self.marketModel?.maxLimit)!, (baseCoinModel?.symbol.uppercased())!)
//            self.lb_transactionFee.text = String(format: "%.4f %@ = %.4f %@", (self.marketModel?.minerFee)!, (self.baseCoinModel?.symbol.uppercased())!, fee_usd, "USD")
            calculateFee()
            if(self.baseCoinModel?.symbol == "BTC" || self.baseCoinModel?.symbol == "ETH") {
                self.viewTransactionFee.isHidden = false
            } else {
                self.viewTransactionFee.isHidden = true
            }
            self.viewAmount.isHidden = false
            self.btt_send.isHidden = false
        } else {
            self.lb_ExchangeAvailable.text = "Exchange Unavailable"
            self.lb_CoinBalance.text = ""
            self.lb_CoinPowered.isHidden = true
            self.lb_minMax.text = ""
            self.lb_transactionFee.text = ""
            self.viewTransactionFee.isHidden = true
            self.viewAmount.isHidden = true
            self.btt_send.isHidden = true
        }
        
    }
    
    func CheckAvailable() {
        let fromValue = (self.txt_fromCoin.text! as NSString).doubleValue
        let toValue = (self.txt_toCoin.text! as NSString).doubleValue
        if(fromValue != 0 && fromValue > (marketModel?.minimum)!) {
            if(toValue != 0 && toValue < (marketModel?.maxLimit)!) {
                isAvailable = true
                self.EnableView()
                return
            }
        }
        isAvailable = false
        self.EnableView()
    }
    
    @IBAction func clickFromCoin(_ sender: Any) {
        //        dropDownFromCoin.show()
    }
    @IBAction func clickToCoin(_ sender: Any) {
        dropDownToCoin.show()
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
        if(isAvailable) {
            let withdrawal = self.toCoinArray[selectedToCoinIndex].address
            let pair = String(format:"%@_%@", (baseCoinModel?.symbol.lowercased())!, toCoinArray[selectedToCoinIndex].symbol.lowercased())
            let returnAddress = self.baseCoinModel?.address
            let apiPubKey = "4a82a5f1610f1675fcbb54f8f3f64517687b6d8c2200411884ed601d8ef1874536cfbe5262543b1ae0c98e80ac16d4c94ff7c8ced0918101d56932b9b361b254"
            
            var params:Parameters = [:]
            params.updateValue(withdrawal!, forKey: "withdrawal")
            params.updateValue(returnAddress!, forKey: "returnAddress")
            params.updateValue(pair, forKey: "pair")
            params.updateValue(apiPubKey, forKey: "apiKey")
            
            SVProgressHUD.show()
            AF.request(Constants.URL_SHAPESHIFT_SWAP, method: .post, parameters: params, encoding: URLEncoding.default).responseJSON { (response) in
                switch response.result {
                case .success:
                    if let json = try? JSONSerialization.jsonObject(with: response.data!, options: []) {
                        print(String(describing: json))
                        self.sendTransaction(toAddress: (json as! [String: Any])["deposit"] as! String)
                    }
                    break
                case .failure:
                    SVProgressHUD.dismiss()
                    print(String(describing: response.data!))
                    break
                }
            }
        } else {
            
        }
    }
    
    func calculateFee() {
        if(self.baseCoinModel?.symbol == "BTC") {
            self.lb_transactionFee.text = String(format: "%f %@", self.slider_speed.value, "sat")
        } else if(self.baseCoinModel?.symbol == "ETH") {
            self.lb_transactionFee.text = String(format: "%f %@", self.slider_speed.value, "gwei")
        }
    }
    
    func getTransferFee() {
        if(self.baseCoinModel?.symbol == "BTC") {
            AF.request(Constants.URL_GET_BTC_FEE, method: .get).responseJSON { (response) in
                
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
            AF.request(Constants.URL_GET_ETH_FEE, method: .get).responseJSON { (response) in
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
    
    func sendTransaction(toAddress: String) {
        if(self.baseCoinModel?.symbol == "BTC" || self.baseCoinModel?.symbol == "LTC") {
            let amount = Decimal(string: txt_fromCoin.text!)
            let unitDecimal = Decimal(sign: FloatingPointSign.plus, exponent: 8, significand: Decimal(1))
            print((amount!*unitDecimal).description)
            self.baseCoinModel?.wallet.sendTransaction(to: toAddress, value: UInt64((amount! * unitDecimal).description)!, fee: UInt64(slider_speed.value)) { (err, tx) -> () in
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
            let amount = Decimal(string: txt_fromCoin.text!)
            let fee = Decimal(Double(slider_speed.value))
            let amountUnit = Decimal(sign: FloatingPointSign.plus, exponent: 18, significand: Decimal(1))
            let feeUnit = Decimal(sign: FloatingPointSign.plus, exponent: 9, significand: Decimal(1))
            self.baseCoinModel?.wallet.sendTransaction(contractHash: "", to: toAddress, value: BigUInt((amount! * amountUnit).description)! , fee: BigUInt((fee * feeUnit).description)!) { (err, tx) -> () in
                switch (err) {
                case .nrlSuccess:
                    SVProgressHUD.dismiss()
                    self.toastMessage(str: "Successfully sent transaction. tx: \(tx)")
                default:
                    SVProgressHUD.dismiss()
                    self.toastMessage(str: "Failed transaction: \(err)")
                }
            }
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
    
    // MARK: - Network Delegate
    func getMarketInfo() {
        let url =  String(format:"%@%@_%@", Constants.URL_GET_MARKETINFO, (baseCoinModel?.symbol)!, toCoinArray[selectedToCoinIndex].symbol)
        print("url: \(url)")
        SVProgressHUD.show()
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default).responseJSON { (response) in
            
            switch response.result {
            case .success:
                if let json = response.result.value as? [String: AnyObject] {
                    if((json["error"]) != nil){
                        self.updateUIValues(update: false)
                        SVProgressHUD.dismiss()
                        self.toastMessage(str: "That pair is temporarily unavailable for trades.")
                        return
                    }
                    self.marketModel = MarketModel()
                    self.marketModel?.limit = json["limit"] as! Double
                    self.marketModel?.minimum = json["minimum"] as! Double
                    self.marketModel?.minerFee = json["minerFee"] as! Double
                    self.marketModel?.maxLimit = json["maxLimit"] as! Double
                    self.marketModel?.rate = json["rate"] as! Double
                    self.updateUIValues(update: true)
                    SVProgressHUD.dismiss()
                }
                break
            case .failure:
                self.updateUIValues(update: false)
                SVProgressHUD.dismiss()
                break
            }
        }
    }
    @IBAction func srcAmountChanged(_ sender: Any) {
        if(self.marketModel?.rate != 0.0) {
            if let srcAmount = Double(txt_fromCoin.text!) {
                txt_toCoin.text = String(srcAmount * (self.marketModel?.rate)!)
            }
        }
        
        
        
    }
    @IBAction func dstAmountChanged(_ sender: Any) {
        if(self.marketModel?.rate != 0.0) {
            if let dstAmount = Double(txt_toCoin.text!) {
                txt_fromCoin.text = String(dstAmount / (self.marketModel?.rate)!)
            }
        }
    }
    
    @IBAction func onFeeChange(_ sender: Any) {
        self.calculateFee()
    }
}


// MARK: - TextFieldDelegate
//
extension SwapViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.CheckAvailable()
    }
}
