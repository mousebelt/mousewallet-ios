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
    
    let dropDownFromCoin = DropDown()
    let dropDownToCoin = DropDown()
    var baseCoinModel : CoinModel?
    var isAvailable : Bool = false
    var toCoinArray:  [CoinModel] = [CoinModel]()
    var selectedToCoinIndex = 0
    var marketModel : MarketModel?
    
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
        self.lb_fromCoinBalance.text = baseCoinModel?.balance
        
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
        self.lb_toCoinBalance.text = tocoin.balance
        
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
            self?.lb_toCoinBalance.text = coindata?.balance
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
            self.lb_CoinBalance.text = String(format: "1 %@ = %f", (baseCoinModel?.symbol.uppercased())!, (self.marketModel?.rate)!)
            self.lb_CoinPowered.text = String(format: "%@ powered by shapeshife", self.toCoinArray[selectedToCoinIndex].symbol.uppercased())
            self.lb_minMax.text = String(format: "min: %f %@ max: %f %@", (self.marketModel?.minimum)!, (baseCoinModel?.symbol.uppercased())!, (self.marketModel?.maxLimit)!, self.toCoinArray[selectedToCoinIndex].symbol.uppercased())
            self.lb_transactionFee.text = String(format: "%.4f %@ = %f %@", (self.marketModel?.minerFee)!, (self.baseCoinModel?.symbol.uppercased())!, 0.12, "USD")
            self.txt_toCoin.isEnabled = true
            self.txt_fromCoin.isEnabled = true
        } else {
            self.lb_CoinBalance.text = ""
            self.lb_CoinPowered.text = ""
            self.lb_minMax.text = ""
            self.lb_transactionFee.text = ""
            self.txt_toCoin.isEnabled = false
            self.txt_fromCoin.isEnabled = false
        }
        
    }
    
    func CheckAvailable() {
        let fromValue = (self.txt_fromCoin.text! as NSString).doubleValue
        let toValue = (self.txt_toCoin.text! as NSString).doubleValue
        if(fromValue != 0 && fromValue < (marketModel?.minimum)!) {
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
        self.slider_speed.setValue(0.0, animated: true)
    }
    
    @IBAction func clickMedium(_ sender: Any) {
        self.slider_speed.setValue(0.5, animated: true)
    }
    
    @IBAction func clickFast(_ sender: Any) {
        self.slider_speed.setValue(1.0, animated: true)
    }
    
    @IBAction func clickSend(_ sender: Any) {
        if(isAvailable) {
            let withdrawal = self.baseCoinModel?.address
            let pair = String(format:"%@_%@", (baseCoinModel?.symbol)!, toCoinArray[selectedToCoinIndex].symbol)
//            let returnAddress = self.toCoinArray[selectedToCoinIndex].address
            let apiPubKey = "4a82a5f1610f1675fcbb54f8f3f64517687b6d8c2200411884ed601d8ef1874536cfbe5262543b1ae0c98e80ac16d4c94ff7c8ced0918101d56932b9b361b254"
            
            var params:Parameters = [:]
            params.updateValue(withdrawal!, forKey: "withdrawal")
            params.updateValue(pair, forKey: "pair")
//            params.updateValue(returnAddress!, forKey: "returnAddress")
            params.updateValue(apiPubKey, forKey: "apiPubKey")
            
            SVProgressHUD.show()
            Alamofire.request(Constants.URL_GET_MARKETINFO, method: .post, parameters: params, encoding: URLEncoding.default).responseJSON { (response) in
                
                switch response.result {
                case .success:
                    
                    break
                case .failure:
                    SVProgressHUD.dismiss()
                    break
                }
            }
        } else {
            
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
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default).responseJSON { (response) in
            
            switch response.result {
            case .success:
                if let json = response.result.value as? [String: AnyObject] {
                    if((json["error"]) != nil){
                        self.updateUIValues(update: false)
                        SVProgressHUD.dismiss()
                        AppController.shared.ToastMessage(view: self.view, str: "That pair is temporarily unavailable for trades.")
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
