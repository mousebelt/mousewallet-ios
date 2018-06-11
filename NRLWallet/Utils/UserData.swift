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
    
    static func loadKeyData(_ key: String) -> String? {
        return UserDefaults.standard.string(forKey: key)
    }
    
    static func saveKeyData(_ key: String, value: String) {
        removeKeyData(key)
        
        let userDefault = UserDefaults.standard
        userDefault.setValue(value, forKey: key)
        userDefault.synchronize()
    }
    
    static func removeKeyData(_ key: String) {
        let userDefault = UserDefaults.standard
        if let _ = userDefault.object(forKey: key) {
            userDefault.removeObject(forKey: key)
        }
    }
}
