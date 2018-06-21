//
//  MathBasic.swift
//  clientLegerSwift
//
//  Created by veronique demers on 18-02-20.
//  Copyright © 2018 log3900. All rights reserved.
//

import UIKit

class MathBasic {
    
    func checkFor(point: CGPoint, inside button: RoundButton) -> Bool {
        let xDelta = button.relativeCenter.x - point.x
        let yDelta = button.relativeCenter.y - point.y
        let d = pow(xDelta, 2.0) + pow(yDelta, 2.0)
        
        return d <= pow(button.cornerRaidus, 2.0)
    }
    
}
