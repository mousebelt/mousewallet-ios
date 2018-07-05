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

class ReceiveViewController: UIViewController, IndicatorInfoProvider, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell") as! UITableViewCell
//        if(self.baseCoinModel?.symbol == "LTC") {
//            let transaction = self.transactions[indexPath.row] as! BRTransaction
//        }
        return cell
    }
    
    
    @IBOutlet weak var btt_coin: UIButton!
    @IBOutlet weak var btt_select: UIButton!
    @IBOutlet weak var lb_coinAddress: UILabel!
    @IBOutlet weak var lb_coinBalance: UILabel!
    @IBOutlet weak var lb_coinName: UILabel!
    @IBOutlet weak var img_qrCode: UIImageView!
    @IBOutlet weak var tbl_transactions: UITableView!
    
    var blockFromHight: UInt32 = 0
    var blockToHight: UInt32 = 0
    var wallet : NRLWallet?
    var balance : String?
    var baseCoinModel : CoinModel?
    let dropDown = DropDown()
    var balanceIndex = 0
    var balances : NSArray = []
    var transactions : NSArray = []
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("MMM d, yyyy")
        return df
    }()
    
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
        } else if (self.baseCoinModel?.symbol == "ETH") {
            wallet = self.baseCoinModel?.wallet
            self.lb_coinAddress.text = wallet?.getReceiveAddress()
            self.makeQRCode()
            self.wallet?.getWalletBalance() { (err, value) -> () in
                self.balances = value as! NSArray
                
                var dropdownDataSource: [String] = []
                for item in self.balances {
                    let balanceItem = item as! ETHGetBalanceMap
                    dropdownDataSource.append(balanceItem.balance! + " " +  balanceItem.symbol!)
                }
                self.dropDown.dataSource = dropdownDataSource
                self.lb_coinName.text = dropdownDataSource[0]
            }
        } else if (self.baseCoinModel?.symbol == "NEO") {
            wallet = self.baseCoinModel?.wallet
            self.lb_coinAddress.text = wallet?.getReceiveAddress()
            self.makeQRCode()
            self.wallet?.getWalletBalance() { (err, value) -> () in
                self.balances = (value as! NeoGetBalanceResponse ).balance as! NSArray
                var dropdownDataSource : [String] = []
                for item in self.balances {
                    let balanceItem = item as! NeoAssetMap
                    dropdownDataSource.append(String(format: "%.8f %@", balanceItem.value!, balanceItem.symbol!))
                }
                self.dropDown.dataSource = dropdownDataSource
                self.lb_coinName.text = dropdownDataSource[0]
            }
        } else if (self.baseCoinModel?.symbol == "XLD") {
            wallet = self.baseCoinModel?.wallet
            self.lb_coinAddress.text = wallet?.getReceiveAddress()
            self.makeQRCode()
            self.wallet?.getWalletBalance() { (err, value) -> () in
                self.balance = String(describing: value)
                self.lb_coinName.text = String(format:"%@ %@", (self.balance)!, (self.baseCoinModel?.symbol)!)
                
            }
        } else if (self.baseCoinModel?.symbol == "LTC") {
            
            wallet = self.baseCoinModel?.wallet
            //notification handlers from spv node events
            NotificationCenter.default.addObserver(self, selector: #selector(On_LTC_WalletDidUpdateBalance(notification:)), name: NSNotification.Name.LTC_WalletDidUpdateBalance, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(On_LTC_PeerGroupDidDownloadBlock(notification:)), name: Notification.Name.LTC_PeerGroupDidDownloadBlock, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(On_LTC_PeerGroupDidStartDownload(notification:)), name: NSNotification.Name.LTC_PeerGroupDidStartDownload, object: nil)
            
            wallet?.createPeerGroup()
            if (!((wallet?.isConnected())!)) {
                wallet?.connectPeers()
            } else {
                self.updateWalletInfo()
            }
        }
    }
    // MARK: - IndicatorInfoProvider
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title:"Receive")
    }
    
    func setupViews() {
        self.btt_coin.setImage(UIImage.init(named: (baseCoinModel?.image)!), for: .normal)
        
        dropDown.anchorView = btt_coin
        dropDown.width = 200
        
        dropDown.cellNib = UINib(nibName: "BalanceDropDownCell", bundle: nil)
        dropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            guard let cell = cell as? BalanceDropDownCell else { return }
            var imageName = "ethereum"
            if(self.baseCoinModel?.symbol == "ETH") {
                imageName = "ethereum"
            } else if(self.baseCoinModel?.symbol == "NEO") {
                imageName = "neo"
            } else if (self.baseCoinModel?.symbol == "XLD") {
                imageName = "stellar"
            }
            cell.optionImage.image = UIImage(named: imageName)
            // Setup your custom UI components
        }
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.balanceIndex = index
            self.lb_coinName.text = item
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
        UIPasteboard.general.string = self.lb_coinAddress.text
        toastMessage(str: "Address copied!")
    }
    
    
}

// MARK: - BITCOIN
extension ReceiveViewController {
    
    func updateWalletInfo() {
        SVProgressHUD.dismiss()
        self.wallet?.getWalletBalance() { (err, value) -> () in
            self.balance = String(describing: value)
            self.lb_coinName.text = String(format:"%@ %@", (self.balance)!, (self.baseCoinModel?.symbol)!)
        }
        self.lb_coinAddress.text = self.baseCoinModel?.address
        self.makeQRCode()
        
        if(self.baseCoinModel?.symbol == "LTC") {
            self.wallet?.getAccountTransactions(offset: 0, count: 10, order: 0){ (err, tx) -> () in
                switch (err) {
                case NRLWalletSDKError.nrlSuccess:
                    //for ethereum tx is ETHGetTransactionsResponse mapping object and can get any field
                    self.transactions = tx as! NSArray
                    self.tbl_transactions.reloadData()
                    print("Success")
                case NRLWalletSDKError.responseError(.unexpected(let error)):
                    print("Server request error: \(error)")
                case NRLWalletSDKError.responseError(.connectionError(let error)):
                    print("Server connection error: \(error)")
                default:
                    print("Failed: \(String(describing: err))")
                }
            }
        }
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
    
    @objc func On_LTC_PeerGroupDidDownloadBlock(notification: Notification) {
        let userinfo = notification.userInfo as! [String: Any]
        
        let progress = userinfo[PeerGroupDownloadBlockProgressKey] as! Double
        let timestamp = userinfo[PeerGroupDownloadBlockTimestampKey] as! UInt32
        
        let txt = self.dateFormatter.string(from: Date(timeIntervalSince1970: Double(timestamp)))
        
        SVProgressHUD.setStatus(String(format: "Progress: %.2f %%  \(txt)", (progress * 100)))
        
        if(progress >= 1.00) {
            self.updateWalletInfo()
        }
    }
    
    @objc func On_LTC_WalletDidUpdateBalance(notification: Notification) {
        let userinfo = notification.userInfo as! [String: Any]
        
        let balance = userinfo[WalletBalanceKey] as! UInt64
        
        self.lb_coinName.text = String(format:"%d %@", balance, (self.baseCoinModel?.symbol)!)
    }
    
    @objc func On_LTC_PeerGroupDidStartDownload(notification: Notification) {
        SVProgressHUD.show()
    }
}


