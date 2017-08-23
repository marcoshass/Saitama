//
//  Keychain+Ext.swift
//  Saitama
//
//  Created by Marcos Hass Wakamatsu on 23/08/17.
//  Copyright © 2017 Marcos Hass Wakamatsu. All rights reserved.
//

import KeychainAccess

extension Keychain {
    
    func isEmpty() -> Bool {
        let keys = self.allKeys()
        for key in keys {
            print("key=\(key) found on keychain")
        }
        
        if keys.isEmpty {
            print("keychain empty")
        }
        
        return keys.isEmpty
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
    
    func persist(token: String, email: String) -> Bool {
        do {
            try self.set(token, key: email)
            print("token=\(token) for=\(email) written")
        } catch {
            print("error persisting token=\(token) for=\(email)")
            return false
        }
        
        return true
    }
    
}
