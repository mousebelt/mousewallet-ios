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
import QRCode
import NRLWalletSDK
import SVProgressHUD

class ReceiveViewController: UIViewController, IndicatorInfoProvider {
    
    @IBOutlet weak var btt_coin: UIButton!
    @IBOutlet weak var btt_select: UIButton!
    @IBOutlet weak var lb_coinAddress: UILabel!
    @IBOutlet weak var lb_coinBalance: UILabel!
    @IBOutlet weak var lb_coinName: UILabel!
    @IBOutlet weak var img_qrCode: UIImageView!
    
    @IBOutlet weak var bottom_view: UIView!
    
    var blockFromHight: UInt32 = 0
    var blockToHight: UInt32 = 0
    var wallet : NRLWallet?
    var balance : String?
    var baseCoinModel : CoinModel?
    let dropDown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(self.baseCoinModel?.symbol == "BTC") {
            SVProgressHUD.show()
            wallet = self.baseCoinModel?.wallet
            //notification handlers from spv node events
            NotificationCenter.default.addObserver(self, selector: #selector(WalletDidUpdateBalance(notification:)), name: NSNotification.Name.WSWalletDidUpdateBalance, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(PeerGroupDidDownloadBlock(notification:)), name: NSNotification.Name.WSPeerGroupDidDownloadBlock, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(PeerGroupDidStartDownload(notification:)), name: NSNotification.Name.WSPeerGroupDidStartDownload, object: nil)
            
            wallet?.createPeerGroup()
            if (!((wallet?.isConnected())!)) {
                wallet?.connectPeers()
            }
        }
    }
    // MARK: - IndicatorInfoProvider
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title:"Receive")
    }
    
    func setupViews() {
        self.btt_coin.setImage(UIImage.init(named: (baseCoinModel?.image)!), for: .normal)
        bottom_view.layer.borderWidth = Constants.Consts.BorderWidth!
        bottom_view.layer.borderColor = Constants.Colors.BorderColor1.cgColor
        bottom_view.layer.cornerRadius = Constants.Consts.CornerRadius!
        
        dropDown.anchorView = btt_coin        
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
        UIPasteboard.general.string = self.lb_coinAddress.text
        AppController.shared.ToastMessage(view: self.view, str: "Address copied!")
    }
    
    func updateWalletInfo() {
        SVProgressHUD.dismiss()
        self.wallet?.getWalletBalance() { (err, value) -> () in
            self.balance = String(describing: value)
            self.lb_coinName.text = String(format:"%@ %@", (self.balance)!, (self.baseCoinModel?.symbol)!)
        }
        self.lb_coinAddress.text = self.baseCoinModel?.address
        self.makeQRCode()
    }
    
    @objc func WalletDidUpdateBalance(notification: Notification) {
        
        let walletObj = notification.object as! WSWallet;
        
        self.balance =  String(describing: walletObj.balance)
        self.lb_coinName.text = String(format:"%@ %@", (self.balance)!, (self.baseCoinModel?.symbol)!)
        
    }
    
    @objc func PeerGroupDidStartDownload(notification: Notification) {
        guard let userInfo = notification.userInfo else {
            print("PeerGroupDidStartDownload Error: invalid notification object.")
            return
        }
        
        self.blockFromHight = userInfo[WSPeerGroupDownloadFromHeightKey] as! UInt32
        self.blockToHight = userInfo[WSPeerGroupDownloadToHeightKey] as! UInt32
        
        if(self.blockToHight == self.blockFromHight) {
            self.updateWalletInfo()
        }
    }
    
    @objc func PeerGroupDidDownloadBlock(notification: Notification) {
        
        let block = notification.userInfo![WSPeerGroupDownloadBlockKey] as! WSStorableBlock
        let currentHeight = block.height() as UInt32;
        let total = self.blockToHight - self.blockFromHight
        let progressed = currentHeight - self.blockFromHight
        SVProgressHUD.setStatus(String(format: "%d/%d       %.2f%%", currentHeight, self.blockToHight, Double(progressed) * 100.0 / Double(total)))
        if (total != 0 && progressed > 0) {
            if (currentHeight < self.blockToHight) {
                if (currentHeight % 1000 == 0 || currentHeight == self.blockToHight) {
                    print(String(format: "%d/%d       %.2f%%", currentHeight, self.blockToHight, Double(progressed) * 100.0 / Double(total)))
                }
            } else if(currentHeight == self.blockToHight) {
                self.updateWalletInfo()
            }
        } else if(currentHeight >= self.blockToHight) {
            self.updateWalletInfo()
        }
        
    }
}
