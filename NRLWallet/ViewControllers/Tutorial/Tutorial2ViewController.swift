//
//  Tutorial2ViewController.swift
//  NRLWallet
//
//  Created by dev on 18/05/2018.
//  Copyright © 2018 NoRestLabs. All rights reserved.
//

import UIKit

class Tutorial2ViewController: UIViewController {
    
    @IBOutlet weak var btnGotIt: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var cardView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViews()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupViews() {
        self.btnGotIt.layer.cornerRadius = Constants.Consts.CornerRadius!
        self.pageControl.transform = CGAffineTransform(scaleX: 2, y:2)
        self.cardView.layer.borderWidth = Constants.Consts.BorderWidth!
        self.cardView.layer.borderColor = UIColor(red:222/255, green:225/255, blue:227/255, alpha: 0.4).cgColor
    }
    
    @IBAction func onGotIt(_ sender: Any) {
        self.performSegue(withIdentifier: "GotItSegue", sender: nil)
    }
    
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}


