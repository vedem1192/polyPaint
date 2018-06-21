//
//  RoundButton.swift
//  clientLegerSwift
//
//  Created by veronique demers on 18-02-19.
//  Copyright © 2018 log3900. All rights reserved.
//

import UIKit



@IBDesignable
class RoundButton: UIButton {
    
    
    let radius = 25
    var relativeCenter:CGPoint!
    
    @IBInspectable var cornerRaidus: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRaidus
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    func set(background: UIColor) {
        self.backgroundColor = background
        self.tintColor = background == .white ? #colorLiteral(red: 0.658308804, green: 0.8193534017, blue: 0.9075077176, alpha: 1) : .white
    }
    
}

