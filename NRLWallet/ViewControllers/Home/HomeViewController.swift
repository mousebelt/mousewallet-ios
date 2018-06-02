//
//  HomeViewController.swift
//  NRLWallet
//
//  Created by admin on 25/05/2018.
//  Copyright © 2018 NoRestLabs. All rights reserved.
//

import UIKit
import Foundation
//import SWRevealViewController
import XLPagerTabStrip

class HomeViewController: ButtonBarPagerTabStripViewController {
    @IBOutlet weak var bttMenu: UIBarButtonItem!
    
    var coinModel : CoinModel?
    
    lazy var searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        self.navigationItem.backBarButtonItem?.tintColor = UIColor.white
//        self.addMenuAction()
        self.revealViewController().panGestureRecognizer().isEnabled=false;
//        self.setLeftMenu()
//        self.setupViews()
        // change selected bar color
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.selectedBarBackgroundColor = Constants.Colors.WhiteColor
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 16)
        settings.style.selectedBarHeight = 0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .white
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        
        
        buttonBarView.layer.backgroundColor = Constants.Colors.WhiteColor.cgColor
        buttonBarView.layer.cornerRadius = buttonBarView.layer.frame.size.height / 2
        buttonBarView.clipsToBounds = true
        buttonBarView.layer.borderColor = Constants.Colors.BorderColor.cgColor
        buttonBarView.layer.borderWidth = Constants.Consts.BorderWidth!
        let theight = buttonBarView.frame.size.height - 10
        
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.layer.cornerRadius = theight/2
            oldCell?.label.textColor = Constants.Colors.FontColor
            oldCell?.contentView.backgroundColor = Constants.Colors.WhiteColor
            
            newCell?.layer.cornerRadius = theight/2 + 3
            newCell?.label.textColor = Constants.Colors.WhiteColor
            newCell?.contentView.backgroundColor =  Constants.Colors.MainColor
            newCell?.layer.borderWidth = 6
            newCell?.layer.borderColor = Constants.Colors.WhiteColor.cgColor
        }
        super.viewDidLoad()
    }
    
    // MARK: - PagerTabStripDataSource
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {      
        let child_1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReceiveViC") as! ReceiveViewController
        let child_2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SendVC")
        let child_3 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SwapVC")
        child_1.coinModel = self.coinModel
        return [child_1, child_2, child_3]
    }
    
    
    override func updateIndicator(for viewController: PagerTabStripViewController, fromIndex: Int, toIndex: Int, withProgressPercentage progressPercentage: CGFloat, indexWasChanged: Bool) {
        super.updateIndicator(for: viewController, fromIndex: fromIndex, toIndex: toIndex, withProgressPercentage: progressPercentage, indexWasChanged: indexWasChanged)
        if indexWasChanged && toIndex > -1 && toIndex < viewControllers.count {
            let child = viewControllers[toIndex] as! IndicatorInfoProvider // swiftlint:disable:this force_cast
            UIView.performWithoutAnimation({ [weak self] () -> Void in
                guard let me = self else { return }
                me.navigationItem.leftBarButtonItem?.title =  child.indicatorInfo(for: me).title
            })
        }
    }
    
    func setLeftMenu() {
        self.revealViewController().rearViewRevealWidth = view.frame.size.width * 0.8   
        self.revealViewController().panGestureRecognizer()
        self.revealViewController().tapGestureRecognizer()
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
//        self.bttMenu.target = self
//        self.bttMenu.action = #selector(self.gotoBack)
//        if self.revealViewController() != nil {
//            self.bttMenu.target = self.revealViewController()
//            self.bttMenu.action = #selector(SWRevealViewController.revealToggle(_:))
//        }
    }
    
    @objc func gotoBack() {
        self.navigationController?.popViewController(animated: true)
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
