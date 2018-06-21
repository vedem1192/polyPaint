//
//  ShapeObject.swift
//  clientLegerSwift
//
//  Created by Simon Barrette on 18-04-09.
//  Copyright © 2018 log3900. All rights reserved.
//

import UIKit
import SpriteKit

struct ShapeObject {
    var skNode = SKNode()
    var id: String?
    
    init(skNode: SKNode) {
        self.skNode = skNode
    }
    
    init(skNode: SKNode, id: String) {
        self.skNode = skNode
        self.id = id
    }
    
}

