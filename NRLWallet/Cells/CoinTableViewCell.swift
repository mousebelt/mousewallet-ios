//
//  CoinTableViewCell.swift
//  NRLWallet
//
//  Created by Daniel on 31/05/2018.
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
    
    @IBOutlet weak var backview: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backview.layer.borderWidth = Constants.Consts.BorderWidth!
        self.backview.layer.borderColor = Constants.Colors.BorderColor1.cgColor
        self.backview.layer.cornerRadius = Constants.Consts.CornerRadius!
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureTableCell(_ coinModel: CoinModel){
        self.lb_coin.text = coinModel.symbol
        self.lb_coinname.text = coinModel.fullname
        self.lb_count.text = coinModel.balance
        let rate = AppController.shared.getConversionRate(symbol: coinModel.symbol)
        if let amountDecimal = Decimal(string: coinModel.balance) {
            var usdAmount = amountDecimal * Decimal(floatLiteral: rate)
            var resDecimal = Decimal()
            NSDecimalRound(&resDecimal, &usdAmount, 3, NSDecimalNumber.RoundingMode.plain)
            self.lb_balance.text = String(format: "%@ USD", resDecimal.description)
        } else {
            self.lb_balance.text = "0.0 USD"
        }
        
        self.img_coin.image = UIImage.init(named: coinModel.image)
    }

}
