//
//  HomeViewController.swift
//  NRLWallet
//
//  Created by admin on 25/05/2018.
//  Copyright © 2018 NoRestLabs. All rights reserved.
//

import UIKit
import SWRevealViewController

class HomeViewController: BaseViewController {
    @IBOutlet weak var bttMenu: UIBarButtonItem!
    @IBOutlet weak var segments: UISegmentedControl!
    
    
    lazy var searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 200, height: 20))    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
        self.addMenuAction()
    }
    
    func setupViews() {
        searchBar.placeholder = "Search"
        
        navigationItem.titleView = searchBar
        searchBar.changeSearchBarColor(color: Constants.Colors.SearchBackgroundColor)
        
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UIColor.white
        
        let textFieldInsideSearchBarLabel = textFieldInsideSearchBar!.value(forKey: "placeholderLabel") as? UILabel
        textFieldInsideSearchBarLabel?.textColor = UIColor.white
        
        let glassIconView = textFieldInsideSearchBar?.leftView as? UIImageView
        glassIconView?.image = glassIconView?.image?.withRenderingMode(.alwaysTemplate)
        glassIconView?.tintColor = UIColor.white
        
        let clearButton = textFieldInsideSearchBar!.value(forKey: "clearButton") as! UIButton
        
        clearButton.setImage(UIImage(named: "ic_cancel"), for: .normal)
        clearButton.setImage(clearButton.imageView?.image?.withRenderingMode(.alwaysTemplate), for: .normal)
        clearButton.tintColor = UIColor.white
        
    }
    
    func addMenuAction() {
        if self.revealViewController() != nil {
            self.bttMenu.target = self.revealViewController()
            self.bttMenu.action = #selector(SWRevealViewController.revealToggle(_:))
        }
    }
    
}
extension UISearchBar {
    func changeSearchBarColor(color : UIColor) {
        for subView in self.subviews {
            for subSubView in subView.subviews {
                
                if let _ = subSubView as? UITextInputTraits {
                    let textField = subSubView as! UITextField
                    textField.backgroundColor = color
                    break
                }
                
            }
        }
    }
}
