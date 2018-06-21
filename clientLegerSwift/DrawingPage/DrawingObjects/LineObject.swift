//
//  lineObject.swift
//  clientLegerSwift
//
//  Created by veronique demers on 18-03-02.
//  Copyright © 2018 log3900. All rights reserved.
//

import UIKit

struct LineObject {
    var color = UIColor.white
    var path = CGMutablePath()
    var width: CGFloat = 1.0
    var cap: CGLineCap = .round
    var id: String?
    
    init(color: UIColor, width: CGFloat) {
        self.color = color
        self.width = width
    }
    
    init(color: UIColor, width: CGFloat, id: String) {
        self.color = color
        self.width = width
        self.id = id
    }
    
    init(color: UIColor, width: CGFloat, path: CGMutablePath) {
        self.color = color
        self.width = width
        self.path = path
    }
    
    init(color: UIColor, width: CGFloat, path: CGMutablePath, id: String) {
        self.color = color
        self.width = width
        self.path = path
        self.id = id
    }
    
}
