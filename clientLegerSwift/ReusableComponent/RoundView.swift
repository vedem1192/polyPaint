//
//  RoundView.swift
//  clientLegerSwift
//
//  Created by veronique demers on 18-03-04.
//  Copyright © 2018 log3900. All rights reserved.
//

import UIKit

@IBDesignable
class RoundView: UIView {

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
    
    @IBInspectable var backgroundImage : UIImage? {
        didSet {
            UIGraphicsBeginImageContext(self.frame.size)
            backgroundImage?.draw(in: self.bounds)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            if let image = image{
                self.backgroundColor = UIColor(patternImage: image)
            }
        }
    }

}
