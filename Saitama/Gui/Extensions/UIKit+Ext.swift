//
//  UIKit+Ext.swift
//  Saitama
//
//  Created by Marcos Hass Wakamatsu on 23/08/17.
//  Copyright © 2017 Marcos Hass Wakamatsu. All rights reserved.
//

import UIKit

// Initializer for rgb UIColor
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1)
    }
}

// Add a constraint for an array of UILabels to align them
extension UITableViewController {
    
    private func labelWidth(_ label: UILabel) -> CGFloat {
        let labelSize = label.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: label.frame.height))
        return labelSize.width
    }
    
    private func maxLabelWidth(_ labels: [UILabel]) -> CGFloat {
        var maxWidth:CGFloat = 0.0
        for item in labels {
            let itemWidth = labelWidth(item)
            if (itemWidth > maxWidth) {
                maxWidth = itemWidth
            }
        }
        return maxWidth
    }
    
    func updateWidthsForLabels(labels: [UILabel]) {
        let maxWidth = maxLabelWidth(labels)
        for label in labels {
            let constraint = NSLayoutConstraint(item: label, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: maxWidth)
            label.addConstraint(constraint)
        }
    }
    
}

// Avoid embedded viewcontroller rotation
extension UINavigationController {
    
    override open var shouldAutorotate: Bool {
        get {
            if let visibleVC = visibleViewController {
                return visibleVC.shouldAutorotate
            }
            return super.shouldAutorotate
        }
    }
    
    override open var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        get {
            if let visibleVC = visibleViewController {
                return visibleVC.preferredInterfaceOrientationForPresentation
            }
            return super.preferredInterfaceOrientationForPresentation
        }
    }
    
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        get {
            if let visibleVC = visibleViewController {
                return visibleVC.supportedInterfaceOrientations
            }
            return super.supportedInterfaceOrientations
        }
    }
}

enum ActionSet {
    case Ok
    case OkCancel
}

extension UIAlertController {
    
    // UIAlertController rotation not allowed
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return UIInterfaceOrientationMask.portrait
        }
    }
    
    open override var shouldAutorotate: Bool {
        get {
            return false
        }
    }
    
    static func show(actionSet: ActionSet, parent: UIViewController, title: String? = nil, message: String, style: UIAlertControllerStyle = .alert, confirmTitle: String? = nil, cancelTitle: String? = nil, confirmHandler: ((UIAlertAction)->Void)? = nil, cancelHandler: ((UIAlertAction)->Void)? = nil) {
        
        // alert
        let defaultAlertTitle = title == nil ? NSLocalizedString("Attention", comment: "Attention") : title
        let alert = UIAlertController(title: defaultAlertTitle, message: message, preferredStyle: style)
        
        // confirm action
        let actionStyle: UIAlertActionStyle = .default
        let defaultConfirmTitle = confirmTitle == nil ? NSLocalizedString("OK", comment: "OK") : confirmTitle
        let confirmAction = (UIAlertAction(title: defaultConfirmTitle, style: actionStyle, handler: confirmHandler))
        
        // cancel action
        let defaultCancelTitle = cancelTitle == nil ? NSLocalizedString("Cancel", comment: "Cancel") : cancelTitle
        let cancelAction = UIAlertAction(title: defaultCancelTitle, style: .cancel, handler: cancelHandler)
        
        alert.addAction(confirmAction)
        if actionSet == .OkCancel {
            alert.addAction(cancelAction)
        }
        
        parent.present(alert, animated: true, completion: nil)
    }
    
}

extension UIViewController {
    
    // modal alert
    func show(title: String? = nil, message: String, confirmTitle: String? = nil, confirmHandler: ((UIAlertAction)->Void)? = nil) {
        UIAlertController.show(actionSet: .Ok, parent: self, title: title, message: message, style: .alert, confirmTitle: confirmTitle, confirmHandler: confirmHandler)
    }
    
    // modal alert with actionset
    func show(actionSet: ActionSet, title: String? = nil, message: String, style: UIAlertControllerStyle = .alert, confirmTitle: String? = nil, cancelTitle: String? = nil, confirmHandler: ((UIAlertAction)->Void)? = nil, cancelHandler: ((UIAlertAction)->Void)? = nil) {
        UIAlertController.show(actionSet: actionSet, parent: self, title: title, message: message, style: style, confirmTitle: confirmTitle, cancelTitle: cancelTitle, confirmHandler: confirmHandler, cancelHandler: cancelHandler)
    }
    
}

