//
//  Constants.swift
//  NRLWallet
//
//  Created by admin on 26/05/2018.
//  Copyright © 2018 NoRestLabs. All rights reserved.
//

import UIKit

struct Constants {
    public static let AppName = "NRLWallet"
    public static let UserProfile = "USERPROFILE"
    
    struct DefaultsKeys {
        public static let kKeyUserToken = "SavedUserToken"
        public static let kKeyFilterPreference = "KEYFILTERPREFERENCE"
        public static let kKeyEncryptedMessage = "EncryptedMessage"
        public static let kKeyEncryptedKey = "EncryptedKey"
    }
    struct Colors {
        public static let ActiveLayerBackgroundColor = UIColor(red: 250.0/255.0, green: 239.0/255.0, blue: 237.0/255.0, alpha: 1.0)
        public static let WhiteColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        public static let BlackColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        public static let MainColor = UIColor(red: 227.0/255.0, green: 65.0/255.0, blue: 51.0/255.0, alpha: 1.0)
        public static let BorderColor = UIColor(red: 214.0/255.0, green: 210.0/255.0, blue: 210.0/255.0, alpha: 0.6)
        public static let BorderColor1 = UIColor(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 0.6)
        public static let SearchBackgroundColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.1)
        public static let FontColor = UIColor(red: 135.0/255.0, green: 135.0/255.0, blue: 135.0/255.0, alpha: 1.0)
        public static let ClearColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.0)
    }
    
    struct Consts {
        public static let BorderWidth = 1.0 as CGFloat?
        public static let CornerRadius = 5.0 as CGFloat?
    }
}
