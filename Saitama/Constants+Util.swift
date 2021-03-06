//
//  Constants.swift
//  Saitama
//
//  Created by Marcos Hass Wakamatsu on 23/08/17.
//  Copyright © 2017 Marcos Hass Wakamatsu. All rights reserved.
//

import UIKit

/**
 Nested structs with relevant constants used in the application
 */
struct Constants {
    
    struct Color {
        static let lightGray = UIColor(red: 208, green: 208, blue: 210)
        static let darkBlue = UIColor(red: 79, green: 106, blue: 163)
        static let disableBlue = UIColor(red: 123, green: 143, blue: 186)
    }
    
    struct NavigationBar {
        static let textAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont.systemFont(ofSize: 16, weight: UIFontWeightRegular)]
    }
    
    struct UIBarButtonItem {
        static let enableTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont.systemFont(ofSize: 16, weight: UIFontWeightRegular)]
        static let disableTextAttributes = [NSForegroundColorAttributeName: Color.disableBlue, NSFontAttributeName: UIFont.systemFont(ofSize: 16, weight: UIFontWeightRegular)]
    }
    
    struct ToolbarButtonItem {
        static let textAttributes = [NSForegroundColorAttributeName: Color.darkBlue, NSFontAttributeName: UIFont.systemFont(ofSize: 16, weight: UIFontWeightRegular)]
    }
    
    struct Keychain {
        static let service = "br.com.marcoshass.crossoverapp"
    }

}

/**
 Static DateFormatters to be used throughout the
 application and save resources for data parsing
 */
struct Format {
    
    static let utc: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter
    }()

    static let utcShort: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
}

struct Email {
    
    static func isValid(_ emailAddress: String) -> Bool {
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddress as NSString
            let results = regex.matches(in: emailAddress, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return returnValue
    }
    
}
