//
//  CutCopyMenuView.swift
//  clientLegerSwift
//
//  Created by lea el hage on 2018-03-24.
//  Copyright © 2018 log3900. All rights reserved.
//


import UIKit

class CutCopyMenuView: UIView {
    func hide() {
        UIView.animate(withDuration: 0.1, animations: {
            self.alpha = 0
        })
    }
}
