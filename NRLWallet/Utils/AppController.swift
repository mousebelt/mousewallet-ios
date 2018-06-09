//
//  GlobalData.swift
//  NRLWallet
//
//  Created by admin on 01/06/2018.
//  Copyright © 2018 NoRestLabs. All rights reserved.
//

import UIKit

class AppController: NSObject {

    static let shared = AppController()
    
    var coinArray:  [CoinModel] = [CoinModel]()
    
    override init() {
        super.init()
    }
}
