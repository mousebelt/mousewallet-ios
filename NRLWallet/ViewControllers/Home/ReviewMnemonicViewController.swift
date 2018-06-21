//
//  ReviewMnemonicViewController.swift
//  NRLWallet
//
//  Created by Daniel on 13/06/2018.
//  Copyright © 2018 NoRestLabs. All rights reserved.
//

import UIKit
import TagListView

class ReviewMnemonicViewController: UIViewController {

    var mnemonic: [String]?
    @IBOutlet weak var mnemonicView: UIView!
    @IBOutlet weak var mnemonicTagListView: TagListView!
    @IBOutlet weak var bttOK: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func onClickOK(_ sender: Any) {
    }
    
    func setupViews() {
        self.bttOK.layer.cornerRadius = Constants.Consts.CornerRadius!
        
        mnemonicTagListView.textFont = UIFont(name: "SourceSansPro-Regular", size: 14.0)!
        mnemonicTagListView.addTags(self.mnemonic!)
        
        
        let viewBorder = CAShapeLayer()
        viewBorder.strokeColor = Constants.Colors.BorderColor.cgColor
        viewBorder.lineDashPattern = [8, 8]
        viewBorder.frame = mnemonicView.bounds
        viewBorder.fillColor = nil
        viewBorder.cornerRadius = Constants.Consts.CornerRadius!
        let rect = CGRect(x:0, y: 0, width:self.view.bounds.size.width - 36 * 2, height: mnemonicView.bounds.size.height)
        viewBorder.path = UIBezierPath(rect: rect).cgPath
        viewBorder.masksToBounds = false
        mnemonicView.layer.addSublayer(viewBorder)
    }

}
