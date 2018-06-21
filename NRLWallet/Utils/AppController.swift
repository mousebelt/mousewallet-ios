//
//  GlobalData.swift
//  NRLWallet
//
//  Created by Daniel on 01/06/2018.
//  Copyright © 2018 NoRestLabs. All rights reserved.
//

import UIKit
import RNCryptor
import Toast_Swift

class AppController: NSObject {

    static let shared = AppController()
    
    var coinArray:  [CoinModel] = [CoinModel]()
    var appCoinModels : [String] = ["Bitcoin", "Ethereum", "Litecoin", "Neo", "Stellar"]
    
    override init() {
        super.init()
    }
    
    func ToastMessage(view: UIView, str: String){        
        var style = ToastStyle()
        style.backgroundColor = .gray
        view.makeToast(str, duration: 3.0, position: .bottom, style: style)
    }
    
    
    func encryptMessage(message: String, encryptionKey: String) throws -> String {
        let messageData = message.data(using: .utf8)!
        let cipherData = RNCryptor.encrypt(data: messageData, withPassword: encryptionKey)
        return cipherData.base64EncodedString()
    }
    
    func decryptMessage(encryptedMessage: String, encryptionKey: String) throws -> String {
        
        let encryptedData = Data.init(base64Encoded: encryptedMessage)!
        let decryptedData = try RNCryptor.decrypt(data: encryptedData, withPassword: encryptionKey)
        let decryptedString = String(data: decryptedData, encoding: .utf8)!
        
        return decryptedString
    }
}
