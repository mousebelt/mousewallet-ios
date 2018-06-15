//
//  ReceiveViewController.swift
//  NRLWallet
//
//  Created by Daniel on 29/05/2018.
//  Copyright © 2018 NoRestLabs. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import DropDown
import Toast_Swift
import QRCode

class ReceiveViewController: UIViewController, IndicatorInfoProvider {
    
    @IBOutlet weak var btt_coin: UIButton!
    @IBOutlet weak var btt_select: UIButton!
    @IBOutlet weak var lb_coinAddress: UILabel!
    @IBOutlet weak var lb_coinBalance: UILabel!
    @IBOutlet weak var lb_coinName: UILabel!
    @IBOutlet weak var img_qrCode: UIImageView!
    
    @IBOutlet weak var bottom_view: UIView!
    
    
    var coinModel : CoinModel?    
    let dropDown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initViews()
        self.setupViews()
    }
    
    // MARK: - IndicatorInfoProvider
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title:"Receive")
    }
    
    func initViews() {
        self.btt_coin.setImage(UIImage.init(named: (coinModel?.image)!), for: .normal)
        self.lb_coinName.text = String(format:"%@ %@", (self.coinModel?.count)!, (self.coinModel?.name)!)
        self.lb_coinAddress.text = self.coinModel?.address
        self.makeQRCode()
    }
    
    func setupViews() {
        bottom_view.layer.borderWidth = Constants.Consts.BorderWidth!
        bottom_view.layer.borderColor = Constants.Colors.BorderColor1.cgColor
        bottom_view.layer.cornerRadius = Constants.Consts.CornerRadius!
        
        dropDown.anchorView = btt_coin        
        dropDown.dataSource = ["bitcoin", "ethereum", "omg"]
        dropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            guard let cell = cell as DropDownCell? else { return }
            let coinImage = UIImage.init(named: item)
            let coinView = UIImageView.init(image: coinImage)
            coinView.contentMode = .scaleAspectFit
            coinView.frame = CGRect(x:5, y: 5, width: 30, height : 30)
            cell.addSubview(coinView)
            cell.optionLabel.isHidden = true
        }
        dropDown.selectionAction = { [weak self] (index, item) in
            self?.btt_coin.setImage(UIImage.init(named: item), for: .normal)
//            self?.lb_coinAddress.text = self?.coinModel?.address
            self?.makeQRCode()
        }
        
        self.btt_coin.imageView?.contentMode = .scaleAspectFit
    }
    
    func makeQRCode() {
        let qrCode = QRCode(self.lb_coinAddress.text!)!
        self.img_qrCode.image = qrCode.image
    }

    @IBAction func selectDown(_ sender: Any) {
        dropDown.show()
    }
    @IBAction func selectCoin(_ sender: Any) {
        dropDown.show()
    }
    @IBAction func copyClick(_ sender: Any) {
        var style = ToastStyle()
        style.backgroundColor = .gray
        UIPasteboard.general.string = self.lb_coinAddress.text
        self.view.makeToast("Address copied!", duration: 3.0, position: .bottom, style: style)
    }
}
