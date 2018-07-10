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
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell") as! TransactionCell
        if(self.baseCoinModel?.symbol == "LTC") {
            let transaction = self.transactions[indexPath.row] as! BRTransaction
            cell.lblAddress.text = transaction.txHash.description
        } else if( self.baseCoinModel?.symbol == "ETH") {
            let transaction = self.transactions[indexPath.row] as! ETHTxDetailResponse
            cell.lblAddress.text = transaction.hash
            cell.lblAmount.text = transaction.value?.description
        } else if( self.baseCoinModel?.symbol == "XLD") {
            let transaction = self.transactions[indexPath.row] as! StellarTxDetailResponse
            cell.lblAddress.text = transaction.transaction_hash
//            cell.lblAmount.text = transaction.amount
        }
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
        wallet = self.baseCoinModel?.wallet
        if(self.baseCoinModel?.symbol == "BTC") {
            //notification handlers from spv node events
            NotificationCenter.default.addObserver(self, selector: #selector(WalletDidUpdateBalance(notification:)), name: NSNotification.Name.WSWalletDidUpdateBalance, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(PeerGroupDidDownloadBlock(notification:)), name: NSNotification.Name.WSPeerGroupDidDownloadBlock, object: nil)
            
            self.getBTCInfo()
            
        } else if (self.baseCoinModel?.symbol == "ETH") {
            self.getETHInfo()
        } else if (self.baseCoinModel?.symbol == "NEO") {
            self.getNEOInfo()
        } else if (self.baseCoinModel?.symbol == "XLD") {
            self.getXLDInfo()
        } else if (self.baseCoinModel?.symbol == "LTC") {
            //notification handlers from spv node events
            NotificationCenter.default.addObserver(self, selector: #selector(On_LTC_WalletDidUpdateBalance(notification:)), name: NSNotification.Name.LTC_WalletDidUpdateBalance, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(On_LTC_PeerGroupDidDownloadBlock(notification:)), name: Notification.Name.LTC_PeerGroupDidDownloadBlock, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(On_LTC_PeerGroupDidStartDownload(notification:)), name: NSNotification.Name.LTC_PeerGroupDidStartDownload, object: nil)
            
            self.getLTCInfo()
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
    
    func getBTCInfo() {
        self.lb_coinAddress.text = self.baseCoinModel?.address
        self.makeQRCode()
        self.wallet?.getWalletBalance() { (err, value) -> () in
            self.balance = String(describing: value)
            self.lb_coinName.text = String(format:"%@ %@", (self.balance)!, (self.baseCoinModel?.symbol)!)
        }
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
    
    func getLTCInfo() {
        self.lb_coinAddress.text = self.baseCoinModel?.address
        self.makeQRCode()
        self.wallet?.getWalletBalance() { (err, value) -> () in
            self.balance = String(describing: value)
            self.lb_coinName.text = String(format:"%@ %@", (self.balance)!, (self.baseCoinModel?.symbol)!)
        }
        
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
    
    func getETHInfo() {
        self.lb_coinAddress.text = wallet?.getReceiveAddress()
        self.makeQRCode()
        self.wallet?.getWalletBalance() { (err, value) -> () in
            switch (err) {
            case NRLWalletSDKError.nrlSuccess:
                self.balances = value as! NSArray
                
                var dropdownDataSource: [String] = []
                for item in self.balances {
                    let balanceItem = item as! ETHGetBalanceMap
                    dropdownDataSource.append(balanceItem.balance! + " " +  balanceItem.symbol!)
                }
                self.dropDown.dataSource = dropdownDataSource
                self.lb_coinName.text = dropdownDataSource[0]
                print("Success")
            case NRLWalletSDKError.responseError(.unexpected(let error)):
                print("Server request error: \(error)")
            case NRLWalletSDKError.responseError(.connectionError(let error)):
                print("Server connection error: \(error)")
            default:
                print("Failed: \(String(describing: err))")
            }
            self.balances = value as! NSArray
            
            var dropdownDataSource: [String] = []
            for item in self.balances {
                let balanceItem = item as! ETHGetBalanceMap
                dropdownDataSource.append(balanceItem.balance! + " " +  balanceItem.symbol!)
            }
            self.dropDown.dataSource = dropdownDataSource
            self.lb_coinName.text = dropdownDataSource[0]
        }
        
        self.wallet?.getAccountTransactions(offset: 0, count: 10, order: 0){ (err, tx) -> () in
            switch (err) {
            case NRLWalletSDKError.nrlSuccess:
                //for ethereum tx is ETHGetTransactionsResponse mapping object and can get any field
                let res = tx as! ETHGetTransactionsResponse
                self.transactions = res.result as! NSArray
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
    
    func getNEOInfo() {
        self.lb_coinAddress.text = wallet?.getReceiveAddress()
        self.makeQRCode()
        self.wallet?.getWalletBalance() { (err, value) -> () in
            switch (err) {
            case NRLWalletSDKError.nrlSuccess:
                //for ethereum tx is ETHGetTransactionsResponse mapping object and can get any field
                self.balances = (value as! NeoGetBalanceResponse ).balance as! NSArray
                var dropdownDataSource : [String] = []
                for item in self.balances {
                    let balanceItem = item as! NeoAssetMap
                    dropdownDataSource.append(String(format: "%.8f %@", balanceItem.value!, balanceItem.symbol!))
                }
                self.dropDown.dataSource = dropdownDataSource
                self.lb_coinName.text = dropdownDataSource[0]
                print("Success")
            case NRLWalletSDKError.responseError(.unexpected(let error)):
                print("Server request error: \(error)")
            case NRLWalletSDKError.responseError(.connectionError(let error)):
                print("Server connection error: \(error)")
            default:
                print("Failed: \(String(describing: err))")
            }
            
        }
        
        self.wallet?.getAccountTransactions(offset: 0, count: 10, order: 0){ (err, tx) -> () in
            switch (err) {
            case NRLWalletSDKError.nrlSuccess:
                //for ethereum tx is ETHGetTransactionsResponse mapping object and can get any field
                let res = tx as! NeoTransactionsMap
                //                self.transactions = res.result as! NSArray
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
    
    func getXLDInfo() {
        self.lb_coinAddress.text = wallet?.getReceiveAddress()
        self.makeQRCode()
        self.wallet?.getWalletBalance() { (err, value) -> () in
            switch (err) {
            case NRLWalletSDKError.nrlSuccess:
                let balances = value as! [StellarAccountBalanceResponse]
                for balance in balances {
                    if(balance.assetType == "native") {
                        self.balance = balance.balance
                        self.lb_coinName.text = String(format:"%@ %@", (self.balance)!, (self.baseCoinModel?.symbol)!)
                    }
                }
                
                print("Success")
            case NRLWalletSDKError.responseError(.unexpected(let error)):
                print("Server request error: \(error)")
            case NRLWalletSDKError.responseError(.connectionError(let error)):
                print("Server connection error: \(error)")
            case NRLWalletSDKError.accountError(.notCreated):
                self.lb_coinName.text = "You need to send small amount of lumens to your new account to enable your account"
            default:
                print("Failed: \(String(describing: err))")
            }
        }
        
        self.wallet?.getAccountTransactions(offset: 0, count: 10, order: 0){ (err, tx) -> () in
            switch (err) {
            case NRLWalletSDKError.nrlSuccess:
                //for ethereum tx is ETHGetTransactionsResponse mapping object and can get any field
                let res = tx as! StellarGetTransactionsResponse
                self.transactions = res.result as! NSArray
                self.tbl_transactions.reloadData()
                print("Success")
            case NRLWalletSDKError.responseError(.unexpected(let error)):
                print("Server request error: \(error)")
            case NRLWalletSDKError.responseError(.connectionError(let error)):
                print("Server connection error: \(error)")
            case NRLWalletSDKError.accountError(.notCreated):
                print("You need to send small amount of lumens to your new account to enable your account")
            default:
                print("Failed: \(String(describing: err))")
            }
        }
    }
}

// MARK: - BITCOIN
extension ReceiveViewController {
    
    @objc func WalletDidUpdateBalance(notification: Notification) {
        
        let walletObj = notification.object as! WSWallet;
        
        self.balance =  String(describing: walletObj.balance)
        self.lb_coinName.text = String(format:"%@ %@", (self.balance)!, (self.baseCoinModel?.symbol)!)
        
    }
    
    @objc func PeerGroupDidDownloadBlock(notification: Notification) {
        
        let block = notification.userInfo![WSPeerGroupDownloadBlockKey] as! WSStorableBlock
        let currentHeight = block.height() as UInt32;
        self.blockToHight = UInt32(UserData.loadKeyData("BTC_BLOCK_TO_HEIGHT")!)!
        if(currentHeight >= self.blockToHight) {
            self.getBTCInfo()
        }
    }
    
    @objc func On_LTC_PeerGroupDidDownloadBlock(notification: Notification) {
        let userinfo = notification.userInfo as! [String: Any]
        
        let progress = userinfo[PeerGroupDownloadBlockProgressKey] as! Double
        let timestamp = userinfo[PeerGroupDownloadBlockTimestampKey] as! UInt32
        
        //        let txt = self.dateFormatter.string(from: Date(timeIntervalSince1970: Double(timestamp)))
        //        SVProgressHUD.setStatus(String(format: "Progress: %.2f %%  \(txt)", (progress * 100)))
        
        if(progress >= 1.00) {
            self.getLTCInfo()
        }
    }
    
    @objc func On_LTC_WalletDidUpdateBalance(notification: Notification) {
        let userinfo = notification.userInfo as! [String: Any]
        
        let balance = userinfo[WalletBalanceKey] as! UInt64
        
        self.lb_coinName.text = String(format:"%d %@", balance, (self.baseCoinModel?.symbol)!)
    }
    
    @objc func On_LTC_PeerGroupDidStartDownload(notification: Notification) {
        //        SVProgressHUD.show()
    }
}


