//
//  Constants.swift
//  Saitama
//
//  Created by Marcos Hass Wakamatsu on 23/08/17.
//  Copyright © 2017 Marcos Hass Wakamatsu. All rights reserved.
//

import UIKit

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
        static let enableTextAttributes = [NSForegroundColorAttributeName: Constants.Color.darkBlue, NSFontAttributeName: UIFont.systemFont(ofSize: 16, weight: UIFontWeightRegular)]
    }
    
    struct Keychain {
        static let service = "br.com.marcoshass.crossoverapp"
    }
    
}
