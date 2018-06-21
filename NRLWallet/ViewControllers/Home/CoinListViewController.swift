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
    var coinWallet: NRLWallet?
    var seed: Data?
    var mnemonic: [String]?
    
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
            self.seed = try NRLMnemonic.mnemonicToSeed(from: self.mnemonic!, withPassphrase: "")
        } catch {
            print(error)
        }
    }
    
    func generateEthereumWallet() {
        // Ethereum : 60ß
        coinWallet = NRLWallet(seed: self.seed!, network: .main(.ethereum))
        coinWallet?.generateExternalKeyPair(at: 0)
        
        let coinmodel1 = CoinModel()
        coinmodel1.symbol = "ETH"
        coinmodel1.fullname = "Ethereum"
        coinmodel1.image = "ethereum"
        coinmodel1.balance = "$100"
        coinmodel1.count = "0.555"
        coinmodel1.address = coinWallet?.getAddress()
        self.coinArray.append(coinmodel1)
        AppController.shared.coinArray.append(coinmodel1)
    }
    
    func generateBitcoinWallet() {
        coinWallet = NRLWallet(seed: self.seed!, network: .main(.bitcoin))
        coinWallet?.generateExternalKeyPair(at: 0)
        
        let coinmodel1 = CoinModel()
        coinmodel1.symbol = "BTC"
        coinmodel1.fullname = "Bitcoin"
        coinmodel1.image = "bitcoin"
        coinmodel1.balance = "$6450"
        coinmodel1.count = "3.333"
        coinmodel1.address = coinWallet?.getAddress()
        self.coinArray.append(coinmodel1)
        AppController.shared.coinArray.append(coinmodel1)
        
    }
    
    func generateLitecoinWallet() {
        coinWallet = NRLWallet(seed: self.seed!, network: .main(.litecoin))
        coinWallet?.generateExternalKeyPair(at: 0)
        
        let coinmodel1 = CoinModel()
        coinmodel1.symbol = "LTC"
        coinmodel1.fullname = "Litecoin"
        coinmodel1.image = "litecoin"
        coinmodel1.balance = "$94.05"
        coinmodel1.count = "2.222"
        coinmodel1.address = coinWallet?.getAddress()
        self.coinArray.append(coinmodel1)
        AppController.shared.coinArray.append(coinmodel1)
        
    }
    
    func generateNeoWallet() {
        coinWallet = NRLWallet(seed: self.seed!, network: .main(.neo))
        coinWallet?.generateExternalKeyPair(at: 0)
        
        let coinmodel1 = CoinModel()
        coinmodel1.symbol = "NEO"
        coinmodel1.fullname = "Neo"
        coinmodel1.image = "neo"
        coinmodel1.balance = "$1.11"
        coinmodel1.count = "1.111"
        coinmodel1.address = coinWallet?.getAddress()
        self.coinArray.append(coinmodel1)
        AppController.shared.coinArray.append(coinmodel1)
        
    }
    
    func generateStellarWallet() {
        coinWallet = NRLWallet(seed: self.seed!, network: .main(.stellar))
        coinWallet?.generateExternalKeyPair(at: 0)
        
        let coinmodel1 = CoinModel()
        coinmodel1.symbol = "XLD"
        coinmodel1.fullname = "Stellar"
        coinmodel1.image = "stellar"
        coinmodel1.balance = "$0.11"
        coinmodel1.count = "0.111"
        coinmodel1.address = coinWallet?.getAddress()
        self.coinArray.append(coinmodel1)
        AppController.shared.coinArray.append(coinmodel1)
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
