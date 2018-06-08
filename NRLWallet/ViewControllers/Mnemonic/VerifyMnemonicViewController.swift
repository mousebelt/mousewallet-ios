//
//  VerifyMnemonicViewController.swift
//  NRLWallet
//
//  Created by dev on 19/05/2018.
//  Copyright © 2018 NoRestLabs. All rights reserved.
//

import UIKit
import TagListView

class VerifyMnemonicViewController: UIViewController, TagListViewDelegate {
    
    let mnemonicWords = ["accident", "impose", "goat", "inhale", "vintage", "idle", "crazy", "reveal", "reopen", "chest", "picnic", "uphold"]
    
    @IBOutlet weak var btnContinue: UIButton!
    
    @IBOutlet weak var mnemonicList: TagListView!
    @IBOutlet weak var mnemonicWordsList: TagListView!
    @IBOutlet weak var mnemonicListContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.generateMnemonic()
        self.setupViews()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func generateMnemonic() {
        
    }
    
    func setupViews() {
        self.btnContinue.layer.cornerRadius = Constants.Consts.CornerRadius!
        
        mnemonicList.delegate = self
        mnemonicList.textFont = UIFont(name: "SourceSansPro-Regular", size: 14.0)!
        
        let viewBorder = CAShapeLayer()
        viewBorder.strokeColor = UIColor(red: 214/255, green: 210/255, blue: 214/255, alpha: 1).cgColor
        viewBorder.lineDashPattern = [8, 8]
        viewBorder.frame = mnemonicListContainer.bounds
        viewBorder.fillColor = nil
        viewBorder.cornerRadius = Constants.Consts.CornerRadius!
        let rect = CGRect(x:0, y: 0, width:self.view.bounds.size.width - 36 * 2, height: mnemonicListContainer.bounds.size.height)
        viewBorder.path = UIBezierPath(rect: rect).cgPath
        mnemonicListContainer.layer.addSublayer(viewBorder)
        
        mnemonicWordsList.delegate = self
        mnemonicWordsList.textFont = UIFont(name: "SourceSansPro-Regular", size: 14.0)!
        mnemonicWordsList.addTags(self.mnemonicWords)
        
    }
    
    @IBAction func onContinue(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Pin", bundle: nil)
        let PinViewController = storyboard.instantiateViewController(withIdentifier: "PinVC")
        self.navigationController?.pushViewController(PinViewController, animated: true)
    }
    
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        if sender == mnemonicList {
            mnemonicList.removeTag(title)
            mnemonicWordsList.addTag(title)
        } else {
            mnemonicWordsList.removeTag(title)
            mnemonicList.addTag(title)
        }
        
    }
}


