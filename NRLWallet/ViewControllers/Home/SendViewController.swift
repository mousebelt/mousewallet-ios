//
//  SendViewController.swift
//  NRLWallet
//
//  Created by admin on 29/05/2018.
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title:"Send")
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
            self?.btt_coinname.titleLabel?.text = String(format:"%@(%@)", (coindata.name)!, (coindata.fullname)!)
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
    
    
    
    
}
