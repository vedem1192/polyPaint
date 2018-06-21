//
//  Pixel.swift
//  clientLegerSwift
//
//  Created by veronique demers on 18-03-26.
//  Copyright © 2018 log3900. All rights reserved.
//

import UIKit

struct Pixel {
    var r:UInt8
    var g:UInt8
    var b:UInt8
    var a:UInt8
    
    static func ==(lhs: Pixel, rhs: Pixel) -> Bool {
        return lhs.a == rhs.a && lhs.b == rhs.b && lhs.g == rhs.g && lhs.r == rhs.r
    }
    
    static func !=(lhs: Pixel, rhs: Pixel) -> Bool {
        return lhs.a != rhs.a || lhs.b != rhs.b || lhs.g != rhs.g || lhs.r != rhs.r
    }
    
    func isOfColor( _ color : UIColor) -> Bool {
        let rgb = color.cgColor.components
        let alpha = color.cgColor.alpha
        let r = UInt8(rgb![0]*255)
        let g = UInt8(rgb![1]*255)
        let b = UInt8(rgb![2]*255)
        let a = UInt8(alpha*255)
        
        return self.r == r && self.g == g && self.b == b && self.a == a
    }
}
