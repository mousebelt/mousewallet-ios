//
//  CoinListViewController.swift
//  NRLWallet
//
//  Created by admin on 31/05/2018.
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
        self.generateEthereumWallet()
        self.initTempData()
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
        print("\n------------------------- Ethereum ----------------------------\n")
        // Ethereum : 60ß
        coinWallet = NRLWallet(seed: self.seed!, network: .main(.ethereum))
        coinWallet?.generateExternalKeyPair(at: 0)
    }
    
    func initTempData() {
        
        
        let coinmodel = CoinModel()
        coinmodel.name = "BTC"
        coinmodel.fullname = "Bitcoin"
        coinmodel.image = "bitcoin"
        coinmodel.balance = "$450"
        coinmodel.count = "0.123"
        coinmodel.address = "Bitcoin address"
        self.coinArray.append(coinmodel)
        let coinmodel1 = CoinModel()
        coinmodel1.name = "ETH"
        coinmodel1.fullname = "Ethereum"
        coinmodel1.image = "ethereum"
        coinmodel1.balance = "$100"
        coinmodel1.count = "0.555"
        coinmodel1.address = coinWallet?.getAddress()
        self.coinArray.append(coinmodel1)
        let coinmodel2 = CoinModel()
        coinmodel2.name = "OMG"
        coinmodel2.fullname = "OmiseGo"
        coinmodel2.image = "omg"
        coinmodel2.balance = "$10"
        coinmodel2.count = "3.215"
        coinmodel2.address = "OmiseGo address"
        self.coinArray.append(coinmodel2)
        AppController.shared.coinArray.append(coinmodel)
        AppController.shared.coinArray.append(coinmodel1)
        AppController.shared.coinArray.append(coinmodel2)
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
        homeVC.coinModel = self.coinArray[indexPath.row]
        if let navVC = self.navigationController {
            navVC.pushViewController(homeVC, animated: true)
        }
    }
}
