//
//  ViewController+Toast.swift
//  NRLWallet
//
//  Created by Daniel Rupp on 6/30/18.
//  Copyright © 2018 NoRestLabs. All rights reserved.
//

import UIKit
import Toast_Swift

extension UIViewController {
    
    func toastMessage(str: String){
        var style = ToastStyle()
        style.backgroundColor = .gray
        view.makeToast(str, duration: 3.0, position: .bottom, style: style)
    }
}
