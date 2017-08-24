//
//  PaymentCell.swift
//  Saitama
//
//  Created by Marcos Hass Wakamatsu on 24/08/17.
//  Copyright © 2017 Marcos Hass Wakamatsu. All rights reserved.
//

import UIKit

class PaymentCell : UICollectionViewCell {
    
    var payment: Payment? {
        didSet {
            guard let payment = payment else { return }
            
            //imageView.image = UIImage(named: "bike")
            textView.attributedText = self.attributedText(payment: payment)
        }
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 5.0
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    lazy var textView: UITextView = {
        let tv = UITextView()
        tv.isEditable = false
        tv.isSelectable = false
        tv.isScrollEnabled = false
        tv.isUserInteractionEnabled = false
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    let lineSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 208, green: 208, blue: 208)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func attributedText(payment: Payment) -> NSAttributedString {
        let text = NSMutableAttributedString()
        
        // email
        var emailAttr = [String: Any]()
        emailAttr[NSFontAttributeName] = UIFont.systemFont(ofSize: 15, weight: UIFontWeightBold)
        emailAttr[NSForegroundColorAttributeName] = UIColor(red: 38, green: 38, blue: 38)
        text.append(NSAttributedString(string: payment.email ?? NSLocalizedString("empty email", comment: "empty email"), attributes: emailAttr))
        
        // createdAt
        var createdAttr = [String: Any]()
        createdAttr[NSFontAttributeName] = UIFont.systemFont(ofSize: 13)
        createdAttr[NSForegroundColorAttributeName] = UIColor(red: 166, green: 166, blue: 166)
        text.append(NSAttributedString(string: "   \(payment.createdAt ?? NSLocalizedString("empty date", comment: "empty date"))" , attributes: createdAttr))
        
        // spacer
        var spacerAttr = [String: Any]()
        spacerAttr[NSFontAttributeName] = UIFont.systemFont(ofSize: 5)
        text.append(NSAttributedString(string: "\n\n" , attributes: spacerAttr))
        
        // body
        var bodyAttr = [String: Any]()
        bodyAttr[NSFontAttributeName] = UIFont.systemFont(ofSize: 14, weight: UIFontWeightRegular)
        bodyAttr[NSForegroundColorAttributeName] = UIColor(red: 46, green: 46, blue: 46)
        text.append(NSAttributedString(string: "\(payment.placeId ?? NSLocalizedString("empty place", comment: "empty place"))", attributes: bodyAttr))
        
        return text
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        setupImageView()
        setupTextView()
        setupLineSeparator()
    }
    
    func setupImageView() {
        addSubview(imageView)
        
        imageView.topAnchor.constraint(equalTo: topAnchor, constant: 10.0).isActive = true
        imageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10.0).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 36.0).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 36.0).isActive = true
    }
    
    func setupTextView() {
        addSubview(textView)
        
        textView.topAnchor.constraint(equalTo: topAnchor, constant: 0.0).isActive = true
        textView.leftAnchor.constraint(equalTo: leftAnchor, constant: 44.0 + 10.0).isActive = true
        textView.rightAnchor.constraint(equalTo: rightAnchor, constant: -10.0).isActive = true
        textView.widthAnchor.constraint(equalToConstant: self.frame.width - 64.0).isActive = true
        textView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10.0).isActive = true
    }
    
    func setupLineSeparator() {
        addSubview(lineSeparator)
        
        lineSeparator.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        lineSeparator.leftAnchor.constraint(equalTo: leftAnchor, constant: 12.0).isActive = true
        lineSeparator.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        lineSeparator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
    }
    
}


