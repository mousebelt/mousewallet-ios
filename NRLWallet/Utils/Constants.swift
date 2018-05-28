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
    }
    struct Colors {
        public static let ActiveLayerBackgroundColor = UIColor(red: 250.0/255.0, green: 239.0/255.0, blue: 237.0/255.0, alpha: 1.0)
        public static let WhiteColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        public static let BlackColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        public static let ErrorColor = UIColor(red: 237.0/255.0, green: 112.0/255.0, blue: 91.0/255.0, alpha: 1.0)
        public static let BorderColor = UIColor(red: 214.0/255.0, green: 210.0/255.0, blue: 210.0/255.0, alpha: 1.0)
    }
}
