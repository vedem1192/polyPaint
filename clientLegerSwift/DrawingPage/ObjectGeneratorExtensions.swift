//
//  ObjectGeneratorExtensions.swift
//  clientLegerSwift
//
//  Created by veronique demers on 18-04-02.
//  Copyright © 2018 log3900. All rights reserved.
//

import UIKit
import SpriteKit

extension ObjectGenerator {
    
    // minX,maxY ----- maxX,maxY
    //     |               |
    //     |               |
    // minX,minY ----- maxX,minY
    
    private func setAccessibilityPath(path : CGPath, accessiblity : CGPath) -> SKShapeNode {
        let shape = SKShapeNode(path: path)
        shape.accessibilityPath = UIBezierPath(cgPath: accessiblity)
        return shape
    }
    
    func elipse(rect: CGRect, center : CGPoint) -> SKShapeNode {
        // offset of -pi/10 = 198 degree
        let offsetRect = rect.offsetBy(dx: -rect.midX, dy: -rect.midY)
        
        let icosagon = polygonPath(x: 0, y:  0, radius: offsetRect.width/2, sides: 20, offset: 0)
        let accessibilityPath = polygonPath(x: center.x, y:  center.y, radius: rect.width/2, sides: 20, offset: 0)
        
        return setAccessibilityPath(path: icosagon, accessiblity: accessibilityPath)
    }
    
    
    func rectangleShape(origin : CGPoint, location : CGPoint) -> SKShapeNode {
        let accessibilityPath = getRectanglePath(origin: origin, location: location)
        
        let rectangle = getRectanglePath(origin: origin, location: location)
        let midX = (origin.x + location.x)/2
        let midY = (origin.y + location.y)/2
        let transform = CGAffineTransform(translationX: -midX, y: -midY)
        rectangle.apply(transform)
        
        return setAccessibilityPath(path: rectangle.cgPath, accessiblity: accessibilityPath.cgPath)
    }

    func pentagon(rect: CGRect, center : CGPoint) -> SKShapeNode {
        // offset of -pi/10 = 198 degree
        let offsetRect = rect.offsetBy(dx: -rect.midX, dy: -rect.midY)
        
        let pentagon = polygonPath(x: 0, y:  0, radius: offsetRect.width/2, sides: 5, offset: 198)
        let accessibilityPath = polygonPath(x: center.x, y:  center.y, radius: rect.width/2, sides: 5, offset: 198)
        
        return setAccessibilityPath(path: pentagon, accessiblity: accessibilityPath)
    }

    func hexagon(rect: CGRect, center : CGPoint) -> SKShapeNode {
        let offsetRect = rect.offsetBy(dx: -rect.midX, dy: -rect.midY)
        
        let hexagon = polygonPath(x: 0, y:  0, radius: offsetRect.width/2, sides: 6, offset: 0)
        let accessibilityPath = polygonPath(x: center.x, y:  center.y, radius: rect.width/2, sides: 6, offset: 0)
        
        return setAccessibilityPath(path: hexagon, accessiblity: accessibilityPath)
    }

    func octogon(rect: CGRect, center : CGPoint) -> SKShapeNode {
        // offset of 45 degree
        let offsetRect = rect.offsetBy(dx: -rect.midX, dy: -rect.midY)
        
        let octogon = polygonPath(x: 0, y: 0, radius: offsetRect.width/2, sides: 8, offset: 45)
        let accessibilityPath = polygonPath(x: center.x, y: center.y, radius: rect.width/2, sides: 8, offset: 45)
        
        return setAccessibilityPath(path: octogon, accessiblity: accessibilityPath)
    }

    func line(origin : CGPoint, location : CGPoint) -> SKShapeNode {
        let accessibilityPath = UIBezierPath()
        accessibilityPath.move(to: origin)
        accessibilityPath.addLine(to: location)
        
        let line = UIBezierPath()
        line.move(to: origin)
        line.addLine(to: location)
        let midX = (origin.x + location.x)/2
        let midY = (origin.y + location.y)/2
        
        let transform = CGAffineTransform(translationX: -midX, y: -midY)
        line.apply(transform)
        
        return setAccessibilityPath(path: line.cgPath, accessiblity: accessibilityPath.cgPath)
    }

    func triangle(rect: CGRect, center : CGPoint) -> SKShapeNode {
        let offsetRect = rect.offsetBy(dx: -rect.midX, dy: -rect.midY)
        
        let triangle = polygonPath(x: 0, y:  0, radius: offsetRect.width/2, sides: 3, offset: 30)
        let accessibilityPath = polygonPath(x: center.x, y:  center.y, radius: rect.width/2, sides: 3, offset: 30)
        
        return setAccessibilityPath(path: triangle, accessiblity: accessibilityPath)
    }

    func diamond(origin : CGPoint, location : CGPoint) -> SKShapeNode {
        let accessibilityPath = getDiamondPath(origin: origin, location: location)
        
        let diamond = getDiamondPath(origin: origin, location: location)
        let midX = (origin.x + location.x)/2
        let midY = (origin.y + location.y)/2
        let transform = CGAffineTransform(translationX: -midX, y: -midY)
        diamond.apply(transform)
        
        return setAccessibilityPath(path: diamond.cgPath, accessiblity: accessibilityPath.cgPath)
    }

    func arrow(origin: CGPoint, location: CGPoint) -> SKShapeNode {
        let accessibilityPath = getArrowPath(origin: origin, location: location)
        
        let arrow = getArrowPath(origin: origin, location: location)
        let midX = (origin.x + location.x)/2
        let midY = (origin.y + location.y)/2
        let transform = CGAffineTransform(translationX: -midX, y: -midY)
        arrow.apply(transform)
        
        return setAccessibilityPath(path: arrow.cgPath, accessiblity: accessibilityPath.cgPath)
    }

    func lightning(origin : CGPoint, location : CGPoint) -> SKShapeNode {
        let accessibilityPath = getLightningPath(origin: origin, location: location)
        
        let lightning = getLightningPath(origin: origin, location: location)
        let midX = (origin.x + location.x)/2
        let midY = (origin.y + location.y)/2
        let transform = CGAffineTransform(translationX: -midX, y: -midY)
        lightning.apply(transform)
        
        return setAccessibilityPath(path: lightning.cgPath, accessiblity: accessibilityPath.cgPath)
    }
    
    func getLightningPath(origin : CGPoint, location : CGPoint) -> UIBezierPath {
        let midX = (origin.x + location.x)/2
        let midY = (origin.y + location.y)/2
        let maxX = origin.x >= location.x ? origin.x : location.x
        let maxY = origin.y >= location.y ? origin.y : location.y
        let minX = origin.x <= location.x ? origin.x : location.x
        let minY = origin.y <= location.y ? origin.y : location.y
        
        let aSixthX = (maxX - minX)/6
        
        let lightning = UIBezierPath()
        lightning.move(to: CGPoint(x: midX, y: maxY))
        lightning.addLine(to: CGPoint(x: midX + (2*aSixthX), y: maxY))
        lightning.addLine(to: CGPoint(x: midX + aSixthX, y: midY))
        lightning.addLine(to: CGPoint(x: midX + (2*aSixthX), y: midY))
        lightning.addLine(to: CGPoint(x: minX + (2*aSixthX), y: minY))
        lightning.addLine(to: CGPoint(x: midX, y: midY))
        lightning.addLine(to: CGPoint(x: minX + (2*aSixthX), y: midY))
        lightning.addLine(to: CGPoint(x: midX, y: maxY))
        
        return lightning
    }
    
    func getRectanglePath(origin : CGPoint, location : CGPoint) -> UIBezierPath {
        let maxX = origin.x >= location.x ? origin.x : location.x
        let maxY = origin.y >= location.y ? origin.y : location.y
        let minX = origin.x <= location.x ? origin.x : location.x
        let minY = origin.y <= location.y ? origin.y : location.y
        
        let rectangle = UIBezierPath()
        rectangle.move(to: CGPoint(x: minX, y: maxY))
        rectangle.addLine(to: CGPoint(x: maxX, y: maxY))
        rectangle.addLine(to: CGPoint(x: maxX, y: minY))
        rectangle.addLine(to: CGPoint(x: minX, y: minY))
        rectangle.addLine(to: CGPoint(x: minX, y: maxY))
        
        return rectangle
    }
    
    func getDiamondPath(origin : CGPoint, location : CGPoint) -> UIBezierPath {
        let midX = (origin.x + location.x)/2
        let midY = (origin.y + location.y)/2
        let maxX = origin.x >= location.x ? origin.x : location.x
        let maxY = origin.y >= location.y ? origin.y : location.y
        let minX = origin.x <= location.x ? origin.x : location.x
        let minY = origin.y <= location.y ? origin.y : location.y
        
        let diamond = UIBezierPath()
        diamond.move(to: CGPoint(x: minX, y: midY))
        diamond.addLine(to: CGPoint(x: midX, y: maxY))
        diamond.addLine(to: CGPoint(x: maxX, y: midY))
        diamond.addLine(to: CGPoint(x: midX, y: minY))
        diamond.addLine(to: CGPoint(x: minX, y: midY))
        
        return diamond
    }
    
    func getArrowPath(origin: CGPoint, location: CGPoint) -> UIBezierPath {
        let midX = (origin.x + location.x)/2
        let midY = (origin.y + location.y)/2
        let maxX = origin.x >= location.x ? origin.x : location.x
        let maxY = origin.y >= location.y ? origin.y : location.y
        let minX = origin.x <= location.x ? origin.x : location.x
        let minY = origin.y <= location.y ? origin.y : location.y
        
        let aSixthX = (maxX - minX)/6
        let aSixthY = (maxY - minY)/6
        
        let arrow = UIBezierPath()
        arrow.move(to: CGPoint(x: maxX, y: midY))
        arrow.addLine(to: CGPoint(x: midX + aSixthX, y: minY))
        arrow.addLine(to: CGPoint(x: midX + aSixthX, y: midY - aSixthY))
        arrow.addLine(to: CGPoint(x: minX, y: midY - aSixthY))
        arrow.addLine(to: CGPoint(x: minX, y: midY + aSixthY))
        arrow.addLine(to: CGPoint(x: midX + aSixthX, y: midY + aSixthY))
        arrow.addLine(to: CGPoint(x: midX + aSixthX, y: maxY))
        arrow.addLine(to: CGPoint(x: maxX, y: midY))
        
        return arrow
    }
    
    func polygonPointArray(sides: Int, x: CGFloat, y: CGFloat, radius: CGFloat, offset: CGFloat) -> [CGPoint] {
        let angle = (360/CGFloat(sides)).radians()
        let cx = x // x origin
        let cy = y // y origin
        let r = radius // radius of circle
        var i = 0
        var points = [CGPoint]()
        while i <= sides {
            let xpo = cx + r * cos(angle * CGFloat(i) - offset.radians())
            let ypo = cy + r * sin(angle * CGFloat(i) - offset.radians())
            points.append(CGPoint(x: xpo, y: ypo))
            i += 1
        }
        return points
    }
    
    func polygonPath(x: CGFloat, y: CGFloat, radius: CGFloat, sides: Int, offset: CGFloat) -> CGPath {
        let path = CGMutablePath()
        let points = polygonPointArray(sides: sides,x: x,y: y,radius: radius, offset: offset)
        let cpg = points[0]
        path.move(to: cpg)
        for p in points {
            path.addLine(to: p)
        }
        path.closeSubpath()
        return path
    }
}
