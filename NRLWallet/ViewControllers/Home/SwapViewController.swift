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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
        self.addDoneCancelToolbar()
    }
    
    // MARK: - IndicatorInfoProvider
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title:"Swap")
    }
    
    func setupViews() {
        self.background_view.layer.cornerRadius = Constants.Consts.CornerRadius!
        self.background_view.layer.borderColor = Constants.Colors.BorderColor1.cgColor
        self.background_view.layer.borderWidth = Constants.Consts.BorderWidth!
        
        self.btt_send.layer.cornerRadius = Constants.Consts.CornerRadius!
        
        self.slider_speed.setThumbImage(UIImage(named: "oval"), for: .normal)
        self.slider_speed.setThumbImage(UIImage(named: "oval"), for: .selected)
        self.slider_speed.setThumbImage(UIImage(named: "oval"), for: .highlighted)
        
        self.img_fromCoin.contentMode = .scaleAspectFit
        self.img_toCoin.contentMode = .scaleAspectFit
        
        dropDownFromCoin.anchorView = btt_fromCoinName
        dropDownFromCoin.dataSource = ["Bitcoin", "Ethereum", "OmiseGo"]
        dropDownToCoin.anchorView = btt_toCoinName
        dropDownToCoin.dataSource = ["Bitcoin", "Ethereum", "OmiseGo"]
        
        
        dropDownFromCoin.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            guard let cell = cell as DropDownCell? else { return }
            cell.optionLabel.text = item
        }        
        
        dropDownFromCoin.selectionAction = { [weak self] (index, item) in
            let coindata = AppController.shared.coinArray[index]
            self?.btt_fromCoinName.titleLabel?.text = coindata.fullname
            self?.lb_fromCoinBalance.text = coindata.balance
            self?.lb_fromCoinSymbol.text = coindata.name
            self?.img_fromCoin.image = UIImage(named: coindata.image)
        }
        dropDownToCoin.selectionAction = { [weak self] (index, item) in
            let coindata = AppController.shared.coinArray[index]
            self?.btt_toCoinName.titleLabel?.text = coindata.fullname
            self?.lb_toCoinBalance.text = coindata.balance
            self?.lb_toCoinSymbol.text = coindata.name
            self?.img_toCoin.image = UIImage(named: coindata.image)
        }
        self.txt_fromCoin.delegate = self
        self.txt_toCoin.delegate = self
    }

    @IBAction func clickFromCoin(_ sender: Any) {
        dropDownFromCoin.show()
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
extension SwapViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        
        return true
    }
}
