//
//  CoinListViewController.swift
//  NRLWallet
//
//  Created by Daniel on 31/05/2018.
//  Copyright © 2018 NoRestLabs. All rights reserved.
//

import UIKit
import SWRevealViewController
import NRLWalletSDK
import SVProgressHUD

class CoinListViewController: UIViewController {
//    var coinWallet: NRLWallet?
    var seed: Data?
    var mnemonic: [String]?
    
    var blockFromHight: UInt32 = 0
    var blockToHight: UInt32 = 0
    
    @IBOutlet weak var bttMenu: UIBarButtonItem!
    var coinArray : [CoinModel] = [CoinModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.decryptedMessage()
        self.generateBitcoinWallet()
        self.generateEthereumWallet()
        self.generateLitecoinWallet()
        self.generateNeoWallet()
        self.generateStellarWallet()
        self.addMenuAction()
        self.setLeftMenu()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.revealViewController().panGestureRecognizer().isEnabled=true;
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getMnemonicFromStore() -> String {
        let encryptedMessage = UserData.loadKeyData(Constants.DefaultsKeys.kKeyEncryptedMessage)
        let encryptionKey = UserData.loadKeyData(Constants.DefaultsKeys.kKeyEncryptedKey)
        
        do {
            let tmp = try AppController.shared.decryptMessage(encryptedMessage: encryptedMessage!, encryptionKey: encryptionKey!)
            return tmp
        }
        catch {
            print(error)
            return ""
        }
    }
    
    func decryptedMessage() {
        let tmpstr = self.getMnemonicFromStore()
        self.mnemonic = tmpstr.components(separatedBy: " ")
        do {
            self.seed = try NRLMnemonic.mnemonicToSeed(from: self.mnemonic!)
        } catch {
            print(error)
        }
    }
    
    func generateEthereumWallet() {
        
        let coinWallet = NRLWallet(mnemonic: self.mnemonic!, passphrase: "", network: .test(.stellar)) as NRLWallet
        
        let date = Date()
        if(!coinWallet.createOwnWallet(created: date, fnew: false)) {
            print("Failed to create wallet")
            return;
        }
        
        let coinmodel = CoinModel()
        coinmodel.balance = "0"
        coinWallet.getWalletBalance(callback: { (err, value) -> () in
            coinmodel.balance = String(describing: value)
        })
        let addresses = coinWallet.getReceiveAddress()
        coinmodel.symbol = "ETH"
        coinmodel.fullname = "Ethereum"
        coinmodel.image = "ethereum"
        coinmodel.count = "0.555"
        coinmodel.address = String(describing: addresses)
        coinmodel.wallet = coinWallet
        self.coinArray.append(coinmodel)
        AppController.shared.coinArray.append(coinmodel)
 
    }
    
    func generateBitcoinWallet() {
        let coinWallet = NRLWallet(mnemonic: self.mnemonic!, passphrase: "", network: .test(.bitcoin)) as NRLWallet
        
        let date = Date()
        if(!coinWallet.createOwnWallet(created: date, fnew: false)) {
            print("Failed to create wallet")
            return;
        }
        
        let coinmodel = CoinModel()
        coinmodel.balance = "0"
        coinWallet.getWalletBalance(callback: { (err, value) -> () in
            coinmodel.balance = String(describing: value)
        })
        let addresses = coinWallet.getReceiveAddress()
        
//        coinWallet.createPeerGroup()
        
        coinmodel.symbol = "BTC"
        coinmodel.fullname = "Bitcoin"
        coinmodel.image = "bitcoin"
//        coinmodel.balance = "6450"
        coinmodel.count = "3.333"
        coinmodel.address = addresses
        coinmodel.wallet = coinWallet
        
        self.coinArray.append(coinmodel)
        AppController.shared.coinArray.append(coinmodel)
        
    }
    
    func generateLitecoinWallet() {
        let coinWallet = NRLWallet(mnemonic: self.mnemonic!, passphrase: "", network: .test(.litecoin)) as NRLWallet
        
        let date = Date()
        if(!coinWallet.createOwnWallet(created: date, fnew: false)) {
            print("Failed to create wallet")
            return;
        }
        
        let coinmodel = CoinModel()
        coinmodel.balance = "0"
        coinWallet.getWalletBalance(callback: { (err, value) -> () in
            coinmodel.balance = String(describing: value)
        })
        let addresses = coinWallet.getReceiveAddress()
        
//        coinWallet.createPeerGroup()
        
        coinmodel.symbol = "LTC"
        coinmodel.fullname = "Litecoin"
        coinmodel.image = "litecoin"
        coinmodel.count = "2.222"
        coinmodel.address = addresses
        coinmodel.wallet = coinWallet
        
        self.coinArray.append(coinmodel)
        AppController.shared.coinArray.append(coinmodel)
        
        //notification handlers from spv node events
        NotificationCenter.default.addObserver(self, selector: #selector(On_LTC_WalletDidUpdateBalance(notification:)), name: NSNotification.Name.LTC_WalletDidUpdateBalance, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(On_LTC_PeerGroupDidDownloadBlock(notification:)), name: Notification.Name.LTC_PeerGroupDidDownloadBlock, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(On_LTC_PeerGroupDidStartDownload(notification:)), name: NSNotification.Name.LTC_PeerGroupDidStartDownload, object: nil)
    }
    
    func generateNeoWallet() {
        let coinWallet = NRLWallet(mnemonic: self.mnemonic!, passphrase: "", network: .test(.neo)) as NRLWallet
        
        let date = Date()
        if(!coinWallet.createOwnWallet(created: date, fnew: false)) {
            print("Failed to create wallet")
            return;
        }
        
        let coinmodel = CoinModel()
        coinmodel.balance = "0"
        coinWallet.getWalletBalance(callback: { (err, value) -> () in
            coinmodel.balance = String(describing: value)
        })
        let addresses = coinWallet.getReceiveAddress()
        
        coinmodel.symbol = "NEO"
        coinmodel.fullname = "Neo"
        coinmodel.image = "neo"
        coinmodel.count = "1.111"
        coinmodel.address = addresses
        coinmodel.wallet = coinWallet
        self.coinArray.append(coinmodel)
        AppController.shared.coinArray.append(coinmodel)
    }
    
    func generateStellarWallet() {
        let coinWallet = NRLWallet(mnemonic: self.mnemonic!, passphrase: "", network: .test(.stellar)) as NRLWallet
        
        let date = Date()
        if(!coinWallet.createOwnWallet(created: date, fnew: false)) {
            print("Failed to create wallet")
            return;
        }
        
        let coinmodel = CoinModel()
        coinmodel.balance = "0"
        coinWallet.getWalletBalance(callback: { (err, value) -> () in
            coinmodel.balance = String(describing: value)
        })
        let addresses = coinWallet.getReceiveAddress()
        coinmodel.symbol = "XLD"
        coinmodel.fullname = "Stellar"
        coinmodel.image = "stellar"
        coinmodel.count = "0.111"
        coinmodel.address = addresses
        coinmodel.wallet = coinWallet
        self.coinArray.append(coinmodel)
        AppController.shared.coinArray.append(coinmodel)
    }
    
    func setLeftMenu() {
        self.revealViewController().rearViewRevealWidth = view.frame.size.width * 0.8
        self.revealViewController().panGestureRecognizer()
        self.revealViewController().tapGestureRecognizer()
    }
    func addMenuAction() {
        if self.revealViewController() != nil {
            self.bttMenu.target = self.revealViewController()
            self.bttMenu.action = #selector(SWRevealViewController.revealToggle(_:))
        }
    }
    
    
    @objc func WalletDidUpdateBalance(notification: Notification) {
        /*
        let walletObj = notification.object as! WSWallet;
        
        guard let wallet = coinWallet else {
            print("WalletDidUpdateBalance Error: cannot init wallet!")
            return
        }
        
        print("Balance: \(walletObj.balance)")
        
//        wallet.getWalletBalance() { (err, value) -> () in
//            self.lbBalance.text = value
//        }
 */
    }
    
    @objc func PeerGroupDidStartDownload(notification: Notification) {
        /*
        guard let wallet = coinWallet else {
            print("PeerGroupDidStartDownload Error: cannot init wallet!")
            return
        }
        
        guard let userInfo = notification.userInfo else {
            print("PeerGroupDidStartDownload Error: invalid notification object.")
            return
        }
        
//        self.blockFromHight = userInfo[WSPeerGroupDownloadFromHeightKey] as! UInt32
//        self.blockToHight = userInfo[WSPeerGroupDownloadToHeightKey] as! UInt32
        
//        wallet.getWalletBalance() { (err, value) -> () in
//            self.lbBalance.text = value
//        }
//        self.lbAddress.text = wallet.getReceiveAddress();
//
//        var progressed = 0;
//        if (self.blockFromHight == self.blockToHight) {
//            progressed = 100
//        }
//        self.lbProgress.text = String(format: "%d/%d       %.2f%%", self.blockFromHight, self.blockToHight, Double(progressed))
 */
    }
    
    @objc func PeerGroupDidDownloadBlock(notification: Notification) {
        /*
        let block = notification.userInfo![WSPeerGroupDownloadBlockKey] as! WSStorableBlock
        let currentHeight = block.height() as UInt32;
        let total = self.blockToHight - self.blockFromHight
        let progressed = currentHeight - self.blockFromHight
        
        if (total != 0 && progressed > 0) {
            if (currentHeight <= self.blockToHight) {
                if (currentHeight % 1000 == 0 || currentHeight == self.blockToHight) {
//                    self.lbProgress.text = String(format: "%d/%d       %.2f%%", currentHeight, self.blockToHight, Double(progressed) * 100.0 / Double(total))
                }
            }
        }
 */
    }
    
    @objc func On_LTC_PeerGroupDidDownloadBlock(notification: Notification) {
        let userinfo = notification.userInfo as! [String: Any]
        
        let progress = userinfo[PeerGroupDownloadBlockProgressKey] as! Double
        let timestamp = userinfo[PeerGroupDownloadBlockTimestampKey] as! UInt32
        
//        let txt = dateFormatter.string(from: Date(timeIntervalSince1970: Double(timestamp)))
//
//        self.lbProgress.text = String(format: "Progress: %.2f %%  \(txt)", (progress * 100))
    }
    
    @objc func On_LTC_WalletDidUpdateBalance(notification: Notification) {
        let userinfo = notification.userInfo as! [String: Any]
        
        let balance = userinfo[WalletBalanceKey] as! UInt64
        
//        self.lbBalance.text = String(format: "\(balance)")
    }
    
    @objc func On_LTC_PeerGroupDidStartDownload(notification: Notification) {
        /*
        guard let wallet = coinWallet else {
            print("On_LTC_PeerGroupDidStartDownload Error: cannot init wallet!")
            return
        }
        
        wallet.getWalletBalance() { (err, value) -> () in
//            self.lbBalance.text = value
        }
//        self.lbAddress.text = wallet.getReceiveAddress();
 */
    }
 
}

extension CoinListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.coinArray.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "coin_cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as! CoinTableViewCell
        cell.configureTableCell(self.coinArray[indexPath.row])
        
        return cell
    }
}
extension CoinListViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        homeVC.baseCoinModel = self.coinArray[indexPath.row]
        if let navVC = self.navigationController {
            navVC.pushViewController(homeVC, animated: true)
        }
    }
}
