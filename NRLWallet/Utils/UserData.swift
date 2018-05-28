//
//  UserData.swift
//  NRLWallet
//
//  Created by admin on 26/05/2018.
//  Copyright © 2018 NoRestLabs. All rights reserved.
//

import UIKit

struct UserData {
    
    static func saveProfileToUserDefault(_ dict: [String: Any]) {
        UserDefaults.standard.set(dict, forKey: Constants.UserProfile)
    }
    
    static func loadProfileFromUserDefault() -> [String: Any]? {
        return UserDefaults.standard.dictionary(forKey: Constants.UserProfile)
    }
    
    static func removeProfileFromUserDefault() {
        UserDefaults.standard.removeObject(forKey: Constants.UserProfile)
    }
}
