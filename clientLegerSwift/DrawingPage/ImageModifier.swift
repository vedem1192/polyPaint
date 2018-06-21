//
//  ImageModifier.swift
//  clientLegerSwift
//
//  Created by veronique demers on 18-04-01.
//  Copyright © 2018 log3900. All rights reserved.
//

import UIKit
import SpriteKit

class ImageModifier {
    let drawing = LineDrawing.instance
    
    var rotatedAngle = CGFloat(0)
    var previousScale = CGFloat(1)
    var imageOrigine : CGPoint!
    
    func rotateSelectedImage(angle : CGFloat) {
        guard let image = drawing.childNode(withName: "image") else { return }
        let temp = CGFloat.pi * 2 - rotatedAngle - angle
        
        image.zRotation = temp
    }
    
    func setRotationAngle(angle : CGFloat) {
        rotatedAngle = rotatedAngle + angle
    }
    
    func scaleSelectedImage(scale : CGFloat) {
        guard let image = drawing.childNode(withName: "image") else { return }
        image.xScale = scale * previousScale
        image.yScale = scale * previousScale
    }
    
    func setScale(scale : CGFloat) {
        previousScale = previousScale * scale
    }
    
    func setOrigin() {
        imageOrigine = CGPoint(x: drawing.frame.width/2, y: drawing.frame.height/2)
    }
    
    func setOrigin(to point : CGPoint) {
        let translation = CGPoint(x: point.x, y: point.y * (-1))
        imageOrigine = imageOrigine + translation
    }
    
    func panSelectedImage(of point : CGPoint) {
        guard let image = drawing.childNode(withName: "image") else { return }
        if imageOrigine == nil {
            setOrigin()
        }
        let translation = CGPoint(x: point.x, y: point.y * (-1))
        image.position = imageOrigine + translation
    }
    
    func acceptChanges() {
        guard let image = drawing.childNode(withName: "image") else { return }
        image.name = "modifiedImage"
        
        rotatedAngle = CGFloat(0)
        previousScale = CGFloat(1)
        imageOrigine = nil
    }
    
    func discardChanges() {
        guard let image = drawing.childNode(withName: "image") else { return }
        image.removeFromParent()
        
        rotatedAngle = CGFloat(0)
        previousScale = CGFloat(1)
        imageOrigine = nil
    }
    
    
    
}
