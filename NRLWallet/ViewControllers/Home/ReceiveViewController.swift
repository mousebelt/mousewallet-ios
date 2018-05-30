//
//  ReceiveViewController.swift
//  NRLWallet
//
//  Created by admin on 29/05/2018.
//  Copyright © 2018 NoRestLabs. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import DropDown

class ReceiveViewController: UIViewController, IndicatorInfoProvider {
    
    @IBOutlet weak var btt_coin: UIButton!
    @IBOutlet weak var btt_select: UIButton!
    @IBOutlet weak var lb_coinAddress: UILabel!
    
    let dropDown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
    }
    
    // MARK: - IndicatorInfoProvider
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title:"Receive")
    }
    
    func setupViews() {
        dropDown.anchorView = btt_coin        
        dropDown.dataSource = ["bitcoin", "ethereum", "omg"]
        dropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            guard let cell = cell as? DropDownCell else { return }
            let coinImage = UIImage.init(named: item)
            let coinView = UIImageView.init(image: coinImage)
            coinView.contentMode = .scaleAspectFit
            coinView.frame = CGRect(x:5, y: 5, width: 30, height : 30)
            cell.addSubview(coinView)
            cell.optionLabel.isHidden = true
        }
        dropDown.selectionAction = { [weak self] (index, item) in
            self?.btt_coin.setImage(UIImage.init(named: item), for: .normal)
            self?.lb_coinAddress.text = item + " wallet address"
        }
    }

    @IBAction func selectDown(_ sender: Any) {
        dropDown.show()
    }
    @IBAction func selectCoin(_ sender: Any) {
        dropDown.show()
    }
    @IBAction func copyClick(_ sender: Any) {
    }
}
