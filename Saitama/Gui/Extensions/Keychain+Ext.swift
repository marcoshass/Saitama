//
//  Keychain+Ext.swift
//  Saitama
//
//  Created by Marcos Hass Wakamatsu on 23/08/17.
//  Copyright © 2017 Marcos Hass Wakamatsu. All rights reserved.
//

import KeychainAccess

extension Keychain {
    
    typealias KeyDictionary = [String: Any]
    
    /** 
     Check the first item present into the keychain.
     */
    func first() -> KeyDictionary? {
        return self.allItems().first
    }
    
    func clear() -> Bool {
        do {
            let keys = self.allKeys()
            for key in keys {
                try self.remove(key)
                print("key=\(key) removed from keychain")
            }
        } catch let error {
            print("error clearing keychain=\(error)")
            return false
        }
        return true
    }
    
    /**
     Write the token value to keychain under the email key.
     */
    func write(token: String, email: String) -> Bool {
        do {
            try self.set(token, key: email)
        } catch {
            return false
        }
        return true
    }
    
}
