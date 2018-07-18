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

class CoinListViewController: UIViewController {
    var bitcoinWallet: NRLWallet?
    var seed: Data?
    var mnemonic: [String]?
    
    @IBOutlet weak var tblCoinList: UITableView!
    
    @IBOutlet weak var bttMenu: UIBarButtonItem!
    var coinArray : [CoinModel] = [CoinModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.revealViewController().panGestureRecognizer().isEnabled=true;
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
