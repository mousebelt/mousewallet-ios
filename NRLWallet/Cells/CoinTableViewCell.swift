//
//  CoinTableViewCell.swift
//  NRLWallet
//
//  Created by admin on 31/05/2018.
//  Copyright © 2018 NoRestLabs. All rights reserved.
//

import UIKit

class CoinTableViewCell: UITableViewCell {
    
    @IBOutlet weak var img_star: UIImageView!
    @IBOutlet weak var img_coin: UIImageView!
    
    @IBOutlet weak var lb_coin: UILabel!
    @IBOutlet weak var lb_coinname: UILabel!
    
    @IBOutlet weak var lb_count: UILabel!
    @IBOutlet weak var lb_balance: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureTableCell(_ coinModel: CoinModel){
        self.lb_coin.text = coinModel.name
        self.lb_coinname.text = coinModel.fullname
        self.lb_count.text = coinModel.count
        self.lb_balance.text = coinModel.balance
        self.img_coin.image = UIImage.init(named: coinModel.image)
    }

}
