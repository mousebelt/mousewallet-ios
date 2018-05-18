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
        self.btnGetStarted.layer.cornerRadius = 4
        self.pageControl.transform = CGAffineTransform(scaleX: 2, y:2)
    }
    
    @IBAction func onGetStarted(_ sender: Any) {
        self.performSegue(withIdentifier: "GetStartedSegue", sender: nil)
    }
}

