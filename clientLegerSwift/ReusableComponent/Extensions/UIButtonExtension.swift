//
//  UIButtonExtension.swift
//  clientLegerSwift
//
//  Created by veronique demers on 18-04-07.
//  Copyright © 2018 log3900. All rights reserved.
//

import UIKit

extension UIButton {
    
    func show() {
        UIButton.animate(withDuration: 0.3, animations: {
            self.alpha = 1
        })
    }
    
    func hide() {
        UIButton.animate(withDuration: 0.75, animations: {
            self.alpha = 0
        })
    }
}
