//
//  CoinListViewController.swift
//  NRLWallet
//
//  Created by admin on 31/05/2018.
//  Copyright © 2018 NoRestLabs. All rights reserved.
//

import UIKit
import SWRevealViewController

class CoinListViewController: UIViewController {
    @IBOutlet weak var bttMenu: UIBarButtonItem!
    var coinArray : [CoinModel] = [CoinModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initTempData()
        self.addMenuAction()
        self.setLeftMenu()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initTempData() {
        let coinmodel = CoinModel()
        coinmodel.name = "BTC"
        coinmodel.fullname = "Bitcoin"
        coinmodel.image = "bitcoin"
        coinmodel.balance = "$450"
        coinmodel.count = "0.123"
        self.coinArray.append(coinmodel)
        let coinmodel1 = CoinModel()
        coinmodel1.name = "ETH"
        coinmodel1.fullname = "Ethereum"
        coinmodel1.image = "ethereum"
        coinmodel1.balance = "$100"
        coinmodel1.count = "0.555"
        self.coinArray.append(coinmodel1)
        let coinmodel2 = CoinModel()
        coinmodel2.name = "OMG"
        coinmodel2.fullname = "OmiseGo"
        coinmodel2.image = "omg"
        coinmodel2.balance = "$10"
        coinmodel2.count = "3.215"
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
