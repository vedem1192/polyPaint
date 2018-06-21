//
//  SendableLineObject.swift
//  clientLegerSwift
//
//  Created by Simon Barrette on 18-03-24.
//  Copyright © 2018 log3900. All rights reserved.
//

import Foundation
import UIKit

struct SendableLineObject: Codable {
    var _listOfPoints: Array<Points> = Array()
    var _width: Float
    var _height: Float
    var _color: [Float]
    var _drawingId: Int = drawingManager.drawingId
    var _Id: String!
    
    init(listOfPoints: Array<Points>, width: Float, color: [Float], id: String) {
        self._listOfPoints = listOfPoints
        self._width = width
        self._height = width
        self._color = color
        self._Id = id
    }
}

struct SendablePixel: Codable {
    var _x: Int
    var _y: Int
    
    init(x: Int, y: Int) {
        self._x = x
        self._y = y
    }
}

struct Points: Codable {
    var _x: Int
    var _y: Int
    
    init(x: Int, y: Int) {
        self._x = x
        self._y = y
    }
}
