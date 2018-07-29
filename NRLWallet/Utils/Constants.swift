//
//  Constants.swift
//  NRLWallet
//
//  Created by Daniel on 26/05/2018.
//  Copyright © 2018 NoRestLabs. All rights reserved.
//

import UIKit

struct Constants {
    public static let AppName = "NRLWallet"
    public static let UserProfile = "USERPROFILE"
    
    public static let URL_GET_MARKETINFO = "https://shapeshift.io/marketinfo/"
    public static let URL_SHAPESHIFT_SWAP = "https://shapeshift.io/shift"
    public static let URL_GET_CONVERSION_RATE = "https://api.coinmarketcap.com/v2/ticker/?convert=USD"
    public static let URL_GET_BTC_FEE = "https://bitcoinfees.earn.com/api/v1/fees/recommended"
    public static let URL_GET_ETH_FEE = "https://www.etherchain.org/api/gasPriceOracle"
    
    public static let YES = "yes"
    public static let NO = "no"
    
    struct DefaultsKeys {
        public static let kKeyUserToken = "SavedUserToken"
        public static let kKeyFilterPreference = "KEYFILTERPREFERENCE"
        public static let kKeyEncryptedMessage = "EncryptedMessage"
        public static let kKeyEncryptedKey = "EncryptedKey"
        public static let kKeyTutorialPass = "TutorialPass"
        public static let kKeyIsNewAccount = "IsNewAccount"
    }
    struct Colors {
        public static let ActiveLayerBackgroundColor = UIColor(red: 247.0/255.0, green: 186.0/255.0, blue: 66.0/255.0, alpha: 1.0)
        public static let WhiteColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        public static let BlackColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        public static let MainColor = UIColor(red: 246.0/255.0, green: 177.0/255.0, blue: 34.0/255.0, alpha: 1.0)
        public static let BorderColor = UIColor(red: 214.0/255.0, green: 210.0/255.0, blue: 210.0/255.0, alpha: 0.6)
        public static let BorderColor1 = UIColor(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 0.6)
        public static let SearchBackgroundColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.1)
        public static let FontColor = UIColor(red: 135.0/255.0, green: 135.0/255.0, blue: 135.0/255.0, alpha: 1.0)
        public static let ClearColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.0)
    }
    
    struct Consts {
        public static let BorderWidth = 1.0 as CGFloat?
        public static let CornerRadius = 5.0 as CGFloat?
        public static let CornerRadius3 = 3.0 as CGFloat?
    }
    
    
}
