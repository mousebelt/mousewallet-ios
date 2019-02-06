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
import Alamofire

class CoinListViewController: UIViewController {
    var bitcoinWallet: NRLWallet?
    var seed: Data?
    var mnemonic: [String]?
    
    @IBOutlet weak var tblCoinList: UITableView!
    
    @IBOutlet weak var bttMenu: UIBarButtonItem!
    var coinArray : [CoinModel] = [CoinModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         NotificationCenter.default.addObserver(self, selector: #selector(PeerGroupDidStartDownload(notification:)), name: NSNotification.Name.WSPeerGroupDidStartDownload, object: nil)
        
        if(AppController.shared.coinArray.count == 0)
        {
            self.decryptedMessage()
            self.generateBitcoinWallet()
            self.generateEthereumWallet()
            self.generateLitecoinWallet()
            self.generateNeoWallet()
            self.generateStellarWallet()
        } else {
            self.coinArray = AppController.shared.coinArray
        }
        
        self.addMenuAction()
        self.setLeftMenu()
        self.fetchConversionRates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.revealViewController().panGestureRecognizer().isEnabled=true
        self.tblCoinList.reloadData()
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setTimeout(_ delay:TimeInterval, block:@escaping ()->Void) -> Timer {
        return Timer.scheduledTimer(timeInterval: delay, target: BlockOperation(block: block), selector: #selector(Operation.main), userInfo: nil, repeats: false)
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
        let isNewAccount = UserData.loadKeyData(Constants.DefaultsKeys.kKeyIsNewAccount)
        let coinWallet = NRLWallet(mnemonic: self.mnemonic!, passphrase: "", network: .main(.ethereum)) as NRLWallet
        
        let dateString = "01/05/2018"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date  = dateFormatter.date(from: dateString)
        if(!coinWallet.createOwnWallet(created: date!, fnew: isNewAccount == Constants.YES)) {
            print("Failed to create wallet")
            return;
        }
        
        let coinmodel = CoinModel()
        coinmodel.balance = "0"
        //        coinWallet.getWalletBalance(callback: { (err, value) -> () in
        //            coinmodel.balance = String(describing: value)
        //        })
        let addresses = coinWallet.getReceiveAddress()
        coinmodel.symbol = "ETH"
        coinmodel.fullname = "Ethereum"
        coinmodel.image = "ethereum"
        coinmodel.count = ""
        coinmodel.address = String(describing: addresses)
        coinmodel.wallet = coinWallet
        self.coinArray.append(coinmodel)
        AppController.shared.coinArray.append(coinmodel)
        
        coinWallet.getWalletBalance() { (err, value) -> () in
            switch (err) {
            case NRLWalletSDKError.nrlSuccess:
                let balances = value as! NSArray
                for item in balances {
                    let balanceItem = item as! ETHGetBalanceMap
                    if((balanceItem.balance) != nil) {
                        if(balanceItem.symbol == "ETH") {
                            coinmodel.balance = balanceItem.balance
                            self.tblCoinList.reloadData()
                        }
                    }
                }
                print("Success")
                break
            case NRLWalletSDKError.responseError(.unexpected(let error)):
                print("Server request error: \(error)")
                break
            case NRLWalletSDKError.responseError(.connectionError(let error)):
                print("Server connection error: \(error)")
                break
            default:
                print("Failed: \(String(describing: err))")
            }
        }
    }
    
    func generateBitcoinWallet() {
        let isNewAccount = UserData.loadKeyData(Constants.DefaultsKeys.kKeyIsNewAccount)
        bitcoinWallet = NRLWallet(mnemonic: self.mnemonic!, passphrase: "", network: .main(.bitcoin))
        guard let wallet = bitcoinWallet else {
            print("Error cannot init wallet!")
            return
        }
        
        let dateString = "01/05/2018"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date  = dateFormatter.date(from: dateString)
        if(!(wallet.createOwnWallet(created: date!, fnew: isNewAccount == Constants.YES))) {
            print("Failed to create wallet")
            return;
        }
        
        wallet.createPeerGroup()
        if (!((wallet.isConnected()))) {
            wallet.connectPeers()
        }
        
        let coinmodel = CoinModel()
        coinmodel.balance = "0"
        //        wallet.getWalletBalance(callback: { (err, value) -> () in
        //            coinmodel.balance = String(describing: value)
        //        })
        let addresses = wallet.getReceiveAddress()
        
        
        coinmodel.symbol = "BTC"
        coinmodel.fullname = "Bitcoin"
        coinmodel.image = "bitcoin"
        //        coinmodel.balance = "6450"
        coinmodel.count = ""
        coinmodel.address = addresses
        coinmodel.wallet = wallet
        
        self.coinArray.append(coinmodel)
        AppController.shared.coinArray.append(coinmodel)
        
        bitcoinWallet?.getWalletBalance() { (err, value) -> () in
            coinmodel.balance = String(describing: value)
            self.tblCoinList.reloadData()
        }
    }
    
    func generateLitecoinWallet() {
        let isNewAccount = UserData.loadKeyData(Constants.DefaultsKeys.kKeyIsNewAccount)
        let coinWallet = NRLWallet(mnemonic: self.mnemonic!, passphrase: "", network: .main(.litecoin)) as NRLWallet
        
        let dateString = "01/05/2018"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date  = dateFormatter.date(from: dateString)
        if(!coinWallet.createOwnWallet(created: date!, fnew: isNewAccount == Constants.YES)) {
            print("Failed to create wallet")
            return;
        }
        
        coinWallet.createPeerGroup()
        if (!((coinWallet.isConnected()))) {
            coinWallet.connectPeers()
        }
        
        let coinmodel = CoinModel()
        coinmodel.balance = "0"
        //        coinWallet.getWalletBalance(callback: { (err, value) -> () in
        //            coinmodel.balance = String(describing: value)
        //        })
        let addresses = coinWallet.getReceiveAddress()
        
        //        coinWallet.createPeerGroup()
        
        coinmodel.symbol = "LTC"
        coinmodel.fullname = "Litecoin"
        coinmodel.image = "litecoin"
        coinmodel.count = ""
        coinmodel.address = addresses
        coinmodel.wallet = coinWallet
        
        self.coinArray.append(coinmodel)
        AppController.shared.coinArray.append(coinmodel)
        
        coinWallet.getWalletBalance() { (err, value) -> () in
            let balanceDecimal = Decimal(value as! UInt64)
            let unitDecimal = Decimal(sign: FloatingPointSign.plus, exponent: -8, significand: Decimal(1))
            coinmodel.balance = (balanceDecimal * unitDecimal).description
            self.tblCoinList.reloadData()
        }
        //notification handlers from spv node events
    }
    
    func generateNeoWallet() {
        let isNewAccount = UserData.loadKeyData(Constants.DefaultsKeys.kKeyIsNewAccount)
        let coinWallet = NRLWallet(mnemonic: self.mnemonic!, passphrase: "", network: .main(.neo)) as NRLWallet
        
        let dateString = "01/05/2018"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date  = dateFormatter.date(from: dateString)
        if(!coinWallet.createOwnWallet(created: date!, fnew: isNewAccount == Constants.YES)) {
            print("Failed to create wallet")
            return;
        }
        
        let coinmodel = CoinModel()
        coinmodel.balance = "0"
        //        coinWallet.getWalletBalance(callback: { (err, value) -> () in
        //            coinmodel.balance = String(describing: value)
        //        })
        let addresses = coinWallet.getReceiveAddress()
        
        coinmodel.symbol = "NEO"
        coinmodel.fullname = "Neo"
        coinmodel.image = "neo"
        coinmodel.count = ""
        coinmodel.address = addresses
        coinmodel.wallet = coinWallet
        self.coinArray.append(coinmodel)
        AppController.shared.coinArray.append(coinmodel)
        
        coinWallet.getWalletBalance() { (err, value) -> () in
            switch (err) {
            case NRLWalletSDKError.nrlSuccess:
                //for ethereum tx is ETHGetTransactionsResponse mapping object and can get any field
                let balances = (value as! NeoGetBalanceResponse ).balance! as NSArray
                for item in balances {
                    let balanceItem = item as! NeoAssetMap
                    if(balanceItem.symbol == "NEO") {
                        coinmodel.balance = balanceItem.value?.description
                        self.tblCoinList.reloadData()
                    }
                }
                break
            case NRLWalletSDKError.responseError(.unexpected(let error)):
                print("Server request error: \(error)")
                break
            case NRLWalletSDKError.responseError(.connectionError(let error)):
                print("Server connection error: \(error)")
                break
            default:
                print("Failed: \(String(describing: err))")
            }
            
        }
    }
    
    func generateStellarWallet() {
        let isNewAccount = UserData.loadKeyData(Constants.DefaultsKeys.kKeyIsNewAccount)
        let coinWallet = NRLWallet(mnemonic: self.mnemonic!, passphrase: "", network: .main(.stellar)) as NRLWallet
        
        let dateString = "01/05/2018"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date  = dateFormatter.date(from: dateString)
        if(!coinWallet.createOwnWallet(created: date!, fnew: isNewAccount == Constants.YES)) {
            print("Failed to create wallet")
            return;
        }
        
        let coinmodel = CoinModel()
        coinmodel.balance = "0"
        //        coinWallet.getWalletBalance(callback: { (err, value) -> () in
        //            coinmodel.balance = String(describing: value)
        //        })
        let addresses = coinWallet.getReceiveAddress()
        coinmodel.symbol = "XLM"
        coinmodel.fullname = "Stellar"
        coinmodel.image = "stellar"
        coinmodel.count = ""
        coinmodel.address = addresses
        coinmodel.wallet = coinWallet
        self.coinArray.append(coinmodel)
        AppController.shared.coinArray.append(coinmodel)
        
        coinWallet.getWalletBalance() { (err, value) -> () in
            switch (err) {
            case NRLWalletSDKError.nrlSuccess:
                let balances = value as! [StellarAccountBalanceResponse]
                for balance in balances {
                    if(balance.assetType == "native") {
                        coinmodel.balance = balance.balance
                        self.tblCoinList.reloadData()
                    }
                }
                print("Success")
                break
            case NRLWalletSDKError.responseError(.unexpected(let error)):
                print("Server request error: \(error)")
                break
            case NRLWalletSDKError.responseError(.connectionError(let error)):
                print("Server connection error: \(error)")
                break
            case NRLWalletSDKError.accountError(.notCreated):
                break
            default:
                print("Failed: \(String(describing: err))")
            }
        }
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
    
    func fetchConversionRates() {
        AF.request(Constants.URL_GET_CONVERSION_RATE, method: .get).responseJSON { (response) in
            switch response.result {
            case .success:
                if let json = try? JSONSerialization.jsonObject(with: response.data!, options: []) {
                    if let dict = json as? [String: Any], let dataDict = dict["data"] as? [String: Any] {
                        AppController.shared.conversionRates.removeAll()
                        for (_, item) in dataDict {
                            if let itemDict = item as? [String: Any] {
                                let price = ((itemDict["quotes"] as! [String:Any])["USD"] as! [String:Any])["price"]
                                AppController.shared.conversionRates.append(ConversionRate(id: itemDict["id"] as! Int, name: itemDict["name"] as! String, symbol: itemDict["symbol"] as! String, price: (price as! NSNumber).doubleValue))
                            }
                        }
                        self.tblCoinList.reloadData()
                    }
                }
                break
            case .failure:
                break
            }
        }
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

extension CoinListViewController {
    
    @objc func WalletDidUpdateBalance(notification: Notification) {
        
        let walletObj = notification.object as! WSWallet;
        
        let balanceDecimal = Decimal(string: walletObj.balance().description)
        let unitDecimal = Decimal(sign: FloatingPointSign.plus, exponent: -8, significand: 1)
//        self.balance =  (balanceDecimal! * unitDecimal).description
//        self.lb_coinName.text = String(format:"%@ %@", (self.balance)!, (self.baseCoinModel?.symbol)!)
        
    }
    
    @objc func PeerGroupDidStartDownload(notification: Notification) {
        guard let userInfo = notification.userInfo else {
            print("PeerGroupDidStartDownload Error: invalid notification object.")
            return
        }
        AppController.shared.btcBlockFromHeight = userInfo[WSPeerGroupDownloadFromHeightKey] as! UInt32
        AppController.shared.btcBlockToHeight = userInfo[WSPeerGroupDownloadToHeightKey] as! UInt32
    }
    
    @objc func PeerGroupDidDownloadBlock(notification: Notification) {
        
        let block = notification.userInfo![WSPeerGroupDownloadBlockKey] as! WSStorableBlock
        let currentHeight = block.height() as UInt32
        AppController.shared.btcCurrentHeight = currentHeight
    }
    
    @objc func On_LTC_PeerGroupDidDownloadBlock(notification: Notification) {
        let userinfo = notification.userInfo as! [String: Any]
        
        let progress = userinfo[PeerGroupDownloadBlockProgressKey] as! Double
        let timestamp = userinfo[PeerGroupDownloadBlockTimestampKey] as! UInt32
        
        AppController.shared.ltcSyncProgress = progress
    }
    
    @objc func On_LTC_WalletDidUpdateBalance(notification: Notification) {
        let userinfo = notification.userInfo as! [String: Any]
        let balanceDecimal = Decimal(userinfo[WalletBalanceKey] as! UInt64)
        let unitDecimal = Decimal(sign: FloatingPointSign.plus, exponent: -8, significand: Decimal(1))
//        self.lb_coinName.text = String(format:"%@ %@", (balanceDecimal * unitDecimal).description, (self.baseCoinModel?.symbol)!)
        
    }
}
