//
//  VerifyMnemonicViewController.swift
//  NRLWallet
//
//  Created by dev on 19/05/2018.
//  Copyright © 2018 NoRestLabs. All rights reserved.
//

import UIKit
import TagListView
import Toast_Swift

class VerifyMnemonicViewController: UIViewController, TagListViewDelegate {
    
    var mnemonicWords = [String]()
    var mnemonicInitial : [String]!
    
    @IBOutlet weak var btnContinue: UIButton!
    
    @IBOutlet weak var mnemonicList: TagListView!
    @IBOutlet weak var mnemonicWordsList: TagListView!
    @IBOutlet weak var mnemonicListContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.generateMnemonicRandom()
        self.setupViews()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func generateMnemonicRandom() {
        var tmpMnemonic = self.mnemonicInitial as [String]
        for _ in 0...(tmpMnemonic.count) - 1
        {
            let rand = Int(arc4random_uniform(UInt32(tmpMnemonic.count)))
            
            self.mnemonicWords.append(tmpMnemonic[rand])
            
            tmpMnemonic.remove(at: rand)
        }

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
        //check mnemonic index
        if(self.mnemonicInitial.count != self.mnemonicList.tagViews.count) {
            var style = ToastStyle()
            style.backgroundColor = .gray
            self.view.makeToast("Please sort all the Mnemonic!", duration: 3.0, position: .bottom, style: style)
            return
        }
        var isMatch = true
        for i in 0...(self.mnemonicInitial.count) - 1
        {
            if(self.mnemonicInitial[i] != self.mnemonicList.tagViews[i].titleLabel?.text)
            {
                isMatch = false
                break
            }
        }
//        isMatch = true
        if(isMatch){
            let storyboard = UIStoryboard(name: "Pin", bundle: nil)
            let PinViewController = storyboard.instantiateViewController(withIdentifier: "PinVC") as! PinViewController
            PinViewController.mnemonicInitial = self.mnemonicInitial
            self.navigationController?.pushViewController(PinViewController, animated: true)
        }else {
            var style = ToastStyle()
            style.backgroundColor = .gray
            self.view.makeToast("Mnemonic is not matching!", duration: 3.0, position: .bottom, style: style)
            
        }
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


