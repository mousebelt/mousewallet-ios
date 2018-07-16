//
//  CoinModel.swift
//  NRLWallet
//
//  Created by Daniel on 31/05/2018.
//  Copyright © 2018 NoRestLabs. All rights reserved.
//

import UIKit
import NRLWalletSDK

class CoinModel: NSObject {
    var symbol:String!
    var fullname:String!
    var image:String!
    var count:String!
    var balance:String!
    var address:String!
    var wallet:NRLWallet!
}

class ETHToken: NSObject {
    var name: String
    var symbol: String
    var address: String
    var decimal: Int
    
    init(name: String, symbol: String, address: String, decimal: Int) {
        self.name = name
        self.symbol = symbol
        self.address = address
        self.decimal = decimal
    }
}

class ConversionRate : NSObject {
    var id : Int
    var name : String
    var symbol : String
    var price : Double
    
    init(id: Int, name: String, symbol: String, price: Double) {
        self.id = id
        self.name = name
        self.symbol = symbol
        self.price = price
    }
}
