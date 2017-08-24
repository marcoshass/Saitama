//
//  PaymentCell.swift
//  Saitama
//
//  Created by Marcos Hass Wakamatsu on 24/08/17.
//  Copyright © 2017 Marcos Hass Wakamatsu. All rights reserved.
//

import UIKit

class PaymentCell : UITableViewCell {
    
    var payment: Payment? {
        didSet {
            guard let payment = payment else { return }
            textView.attributedText = self.attributedText(payment: payment)
        }
    }
    
    let cardImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "card"))
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

    func attributedText(payment: Payment) -> NSAttributedString {
        let text = NSMutableAttributedString()
        let emptyStr = NSLocalizedString("empty", comment: "empty")
        
        guard let card = payment.creditCard else {
            text.append(NSAttributedString(string: emptyStr))
            return text
        }
        
        guard let name = card.name,
            let number = card.number,
            let expiryMonth = card.expiryMonth,
            let expiryYear = card.expiryYear,
            let cvv = card.cvv else {
                text.append(NSAttributedString(string: NSLocalizedString("Incomplete card info", comment: "Incomplete card info")))
                return text
        }
        
        // name
        var nameAttr = [String: Any]()
        nameAttr[NSFontAttributeName] = UIFont.systemFont(ofSize: 15, weight: UIFontWeightBold)
        nameAttr[NSForegroundColorAttributeName] = UIColor.black
        text.append(NSAttributedString(string: name.uppercased(), attributes: nameAttr))
        
        // number
        var numberAttr = [String: Any]()
        numberAttr[NSFontAttributeName] = UIFont.systemFont(ofSize: 16)
        numberAttr[NSForegroundColorAttributeName] = UIColor.darkGray
        text.append(NSAttributedString(string: "\n\(Card.format(number))", attributes: numberAttr))
        
        // goodthru cvv
        let goodThru = NSLocalizedString("GOODTHRU", comment: "GOODTHRU")
        let cvvStr = NSLocalizedString("CVV", comment: "CVV")
        var goodThruAttr = [String: Any]()
        goodThruAttr[NSFontAttributeName] = UIFont.systemFont(ofSize: 13)
        goodThruAttr[NSForegroundColorAttributeName] = UIColor.lightGray
        text.append(NSAttributedString(string: "\n\(goodThru) \(expiryMonth)/\(expiryYear)   \(cvvStr) \(cvv)" , attributes: goodThruAttr))
        
        // spacer
        var spacerAttr = [String: Any]()
        spacerAttr[NSFontAttributeName] = UIFont.systemFont(ofSize: 5)
        text.append(NSAttributedString(string: "\n\n" , attributes: spacerAttr))
        
        // place info
        var placeAttr = [String: Any]()
        placeAttr[NSFontAttributeName] = UIFont.systemFont(ofSize: 14, weight: UIFontWeightRegular)
        placeAttr[NSForegroundColorAttributeName] = Constants.Color.darkBlue
        text.append(NSAttributedString(string: "Hotel Mid In Akabane Ekimae", attributes: placeAttr))
        
        return text
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(cardImageView)
        addSubview(textView)
        
        cardImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10.0).isActive = true
        cardImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10.0).isActive = true
        cardImageView.widthAnchor.constraint(equalToConstant: 54.0).isActive = true
        cardImageView.heightAnchor.constraint(equalToConstant: 34.5).isActive = true

        textView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        textView.leftAnchor.constraint(equalTo: cardImageView.rightAnchor, constant: 10.0).isActive = true
        textView.rightAnchor.constraint(equalTo: rightAnchor, constant: -10.0).isActive = true
        textView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1).isActive = true
    }
    
}


