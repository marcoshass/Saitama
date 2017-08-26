//
//  URLManager.swift
//  Saitama
//
//  Created by Marcos Hass Wakamatsu on 26/08/17.
//  Copyright © 2017 Marcos Hass Wakamatsu. All rights reserved.
//

import Foundation

enum Env: String {
    case dev = "dev"
    case pro = "pro"
}

/**
 Manages the urls used by the api layer, the application must be set to
 use the environments "dev" (that I've used) and "pro" (docker).
 Also into the plist file both base urls must be defined or the
 application will not start
 */
enum URLManager {
    case login
    case register
    case payments
    case rent
    case places
    
    var url: String {
        guard let plistVersion = releaseFromPlist(),
            let devBase = devUrlFromPlist(),
            let proBase = proUrlFromPlist()
        else {
            fatalError("error=check Info.plist file. It must contain the AppRelease with dev/pro; DevelopmentBaseUrl and ProductionBaseUrl")
        }
        
        if plistVersion != "dev" {
            if plistVersion != "pro" {
                fatalError("AppRelease must be dev or pro")
            }
        }
         
        let release = Env(rawValue: plistVersion)!
        switch self {
        case .login: return release == .dev ? "\(devBase)/599e0f552500009705d303b2": "\(proBase)/users/"
        case .register: return release == .dev ? "\(devBase)/599e3560250000f406d303d2": "\(proBase)/users/"
        case .payments: return release == .dev ? "\(devBase)/599ed8232c00004e0051d3cb": "\(proBase)/payments/"
        case .rent: return release == .dev ? "\(devBase)/59a0b0f111000010066442b5": "\(proBase)/payments/"
        case .places: return release == .dev ? "\(devBase)/599f29ea2c0000820151d480": "\(proBase)/places/"
        }
    }
    
    func releaseFromPlist() -> String? {
        return Bundle.main.object(forInfoDictionaryKey: "AppRelease") as? String
    }
    
    func devUrlFromPlist() -> String? {
        return Bundle.main.object(forInfoDictionaryKey: "DevelopmentBaseUrl") as? String
    }
    
    func proUrlFromPlist() -> String? {
        return Bundle.main.object(forInfoDictionaryKey: "ProductionBaseUrl") as? String
    }
}

//      let places = URL(string: "http://www.mocky.io/v2/599f29ea2c0000820151d480")!   // https://localhost:3000/places/ (GET)

//      let login = URL(string: "http://www.mocky.io/v2/599e0f552500009705d303b2")!   // https://localhost:3000/users/ (POST)

//      let register = URL(string: "http://www.mocky.io/v2/599e3560250000f406d303d2")!   // https://localhost:3000/users/ (PUT)

//      let allPayments = URL(string: "http://www.mocky.io/v2/599ed8232c00004e0051d3cb")!   // https://localhost:3000/payments/ (GET)

//      let rent = URL(string: "http://www.mocky.io/v2/59a0b0f111000010066442b5")!   // https://localhost:3000/payments/ (PUT)
