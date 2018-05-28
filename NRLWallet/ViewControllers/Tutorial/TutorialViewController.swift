//
//  TutorialViewController.swift
//  NRLWallet
//
//  Created by admin on 24/05/2018.
//  Copyright © 2018 NoRestLabs. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var viewTutorial1: UIView!
    @IBOutlet weak var viewTutorial2: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pageSetup()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pageSetup() {
        let width = self.view.frame.width
        self.viewTutorial2.frame.offsetBy(dx: width, dy: 0)
        self.scrollView.contentSize = CGSize(width: width * 2, height: view.frame.height)
        self.scrollView.isPagingEnabled = true
        self.scrollView.delegate = self
        
        let width1 = self.scrollView.frame.width
        self.pageController.currentPage = 0;
        self.pageController.numberOfPages = 2;
        
//        self.scrollView.scrollRectToVisible(CGRect(0,0,self.view.frame.width, self.view.frame.height), animated: true)
        
    }

}
