//
//  CGPointExtension.swift
//  clientLegerSwift
//
//  Created by veronique demers on 18-03-29.
//  Copyright © 2018 log3900. All rights reserved.
//

import UIKit

extension CGPoint {
    
    mutating func invert() -> CGPoint {
        return CGPoint(x: self.y, y: self.x)
    }
    
    static func +(first: CGPoint, second: CGPoint) -> CGPoint {
        return CGPoint(x: first.x + second.x, y: first.y + second.y)
    }
}
