//
//  MnemonicViewController.swift
//  NRLWallet
//
//  Created by dev on 19/05/2018.
//  Copyright © 2018 NoRestLabs. All rights reserved.
//

import UIKit
import TagListView
import NRLWalletSDK

class MnemonicViewController: UIViewController {
    
    var mnemonic: [String]?
    
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var mnemonicList: TagListView!
    @IBOutlet weak var mnemonicListContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.generateMnemonic()
        self.setupViews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func generateMnemonic() {
        do {
            self.mnemonic = try NRLMnemonic.generateMnemonic(strength: .normal, language: .english)
        } catch {
            print(error)
        }
    }
    
    func setupViews() {
        self.btnContinue.layer.cornerRadius = Constants.Consts.CornerRadius!
        
        mnemonicList.textFont = UIFont(name: "SourceSansPro-Regular", size: 14.0)!
        mnemonicList.addTags(self.mnemonic!)
        
        
        let viewBorder = CAShapeLayer()
        viewBorder.strokeColor = Constants.Colors.BorderColor.cgColor
        viewBorder.lineDashPattern = [8, 8]
        viewBorder.frame = mnemonicListContainer.bounds
        viewBorder.fillColor = nil
        viewBorder.cornerRadius = Constants.Consts.CornerRadius!
        let rect = CGRect(x:0, y: 0, width:self.view.bounds.size.width - 36 * 2, height: mnemonicListContainer.bounds.size.height)
        viewBorder.path = UIBezierPath(rect: rect).cgPath
        viewBorder.masksToBounds = false
        mnemonicListContainer.layer.addSublayer(viewBorder)
    }
    
    @IBAction func onContinue(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Mnemonic", bundle: nil)
        let verifyMnemonicViewController = storyboard.instantiateViewController(withIdentifier: "VerifyMnemonicVC") as! VerifyMnemonicViewController
        verifyMnemonicViewController.mnemonicInitial = self.mnemonic
        self.navigationController?.pushViewController(verifyMnemonicViewController, animated: true)
    }
    
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

