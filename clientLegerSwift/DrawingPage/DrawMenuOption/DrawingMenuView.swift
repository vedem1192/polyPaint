//
//  DrawingMenuView.swift
//  clientLegerSwift
//
//  Created by veronique demers on 18-02-20.
//  Copyright © 2018 log3900. All rights reserved.
//

import UIKit

class DrawingMenuView: UIView {
    
    func show(at location: CGPoint) {
        self.center = location
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 1
        })
    }
    
    func show() {
        self.alpha = 1
    }
    
    func showSlowly() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 1
        })
    }
    
    func hide() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        })
    }
    
    
}
