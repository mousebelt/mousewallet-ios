//
//  Tutorial1ViewController.swift
//  NRLWallet
//
//  Created by dev on 18/05/2018.
//  Copyright © 2018 NoRestLabs. All rights reserved.
//

import UIKit

class Tutorial1ViewController: UIViewController {

    @IBOutlet var btnGetStarted: UIView!
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
        self.btnGetStarted.layer.cornerRadius = Constants.Consts.CornerRadius!
        self.pageControl.transform = CGAffineTransform(scaleX: 2, y:2)
        self.cardView.layer.borderWidth = Constants.Consts.BorderWidth!
        self.cardView.layer.borderColor = UIColor(red:222/255, green:225/255, blue:227/255, alpha: 0.4).cgColor
    }
    
    @IBAction func onGetStarted(_ sender: Any) {
        self.performSegue(withIdentifier: "GetStartedSegue", sender: nil)
    }
    func dropShadow(opacity: Float = 0.5, radius: CGFloat = 1, scale: Bool = true) {
        self.cardView.clipsToBounds = false
        self.cardView.layer.shadowColor = UIColor(red:222/255, green:225/255, blue:227/255, alpha: 0.5).cgColor
        self.cardView.layer.shadowOpacity = opacity
        self.cardView.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.cardView.layer.shadowRadius = radius
        
        self.cardView.layer.shadowPath = UIBezierPath(rect: self.view.bounds).cgPath
        self.cardView.layer.shouldRasterize = true
        self.cardView.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

