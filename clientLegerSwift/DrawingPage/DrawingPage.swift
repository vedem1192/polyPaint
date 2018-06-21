//
//  DrawingPage.swift
//  clientLegerSwift
//
//  Created by veronique demers on 18-02-19.
//  Copyright © 2018 log3900. All rights reserved.
//

import SpriteKit
import GameplayKit

class DrawingPage : SKScene {
    
    enum DrawingState {
        case Draw
        case Lasso
        case ErasePixel
        case SplitElement
        case EraseElement
        case Selection
        case Default
    }

    var currentState: DrawingState!
    
    var bin: [LineObject] = []
    var lineCollection: [LineObject] = []
    var pointCollection: [CGPoint] = []
    
    var currentStrokeColor = #colorLiteral(red: 0.6642242074, green: 0.6642400622, blue: 0.6642315388, alpha: 1)
    var currentWidth:CGFloat = 1
    
    let selectionRadius: CGFloat = 44
    let eraserRadius: CGFloat = 25
    
    var currentSelection: LineObject!
    var selectedLine : [LineObject] = []
    
    
//    override func didMove(to view: SKView) {
//        self.backgroundColor = .white
//    }
    
//    override func update(_ currentTime: TimeInterval) {
//        // called before each frame is rendered
//        updateCanvas()
//        
//        if (self.currentState == DrawingState.Draw) {
//            createSegmentPath(with: &pointCollection, color: currentStrokeColor, width: currentWidth, drawCurrentLine: true)
//        }
//    }
    
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let touch = touches.first else { return }
//        let location = touch.location(in: self)
//        
//        //makeCirlceInPosition(location: location)
//        currentState == DrawingState.SplitElement ? splitSegment(at: location) : addMovingPoint(point: location)
//    }
    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if (self.currentState == DrawingState.Draw) {
//            createSegmentPath(with: &pointCollection, color: currentStrokeColor, width: currentWidth, drawCurrentLine : false)
//        }
//        clearPoints()
//    }
    
    
//    private func addMovingPoint(point: CGPoint) {
//        pointCollection.append(point)
//    }
    
//    func createSegmentPath(with points: inout [CGPoint], color : UIColor, width : CGFloat, drawCurrentLine: Bool) {
//        if points.count <= 1 { return }
//        let line = LineObject(color: color, width: width)
//
//        for i in 0..<points.count {
//            let pt = points[i]
//            if i == 0 {
//                line.path.move(to: pt)
//            }
//            else {
//                line.path.addLine(to: pt)
//                if drawCurrentLine{
////                    self.addChild(createShapeNode(with: line))
//                    print("")
//                }
//            }
//        }
//
//        if !drawCurrentLine {
//            lineCollection.append(line)
//            points.removeAll()
//        }
//    }
    
//    private func updateCanvas() {
//        enumerateChildNodes(withName: "line", using: { node, stop in
//            node.removeFromParent()
//        })
//        
//        if lineCollection.count > 0 {
//            for line in lineCollection {
//                self.addChild(createShapeNode(with: line))
//            }
//        }
//    }
    
//    private func createShapeNode(with line: LineObject) -> SKShapeNode {
//        let shapeNode = SKShapeNode()
//
//        shapeNode.path = line.path
//        shapeNode.name = "line"
//        shapeNode.strokeColor = line.color
//        shapeNode.lineWidth = line.width
//        shapeNode.lineCap = line.cap
//        shapeNode.zPosition = 1
//
//        return shapeNode
//    }
    
//    func undo() {
//        if let elem = lineCollection.popLast() {
//            bin.append(elem)
//        }
//    }
//    
//    func redo() {
//        if let elem = bin.popLast() {
//            lineCollection.append(elem)
//        }
//    }
//    
//    func generateBlankCanvas() {
//        lineCollection.removeAll()
//        bin.removeAll()
//    }
    
//    func eraseFullElement(_ location : CGPoint) {
//        let isColliding = checkForCollisionWithElement(location: location, needsReferential: true)
//        if isColliding.0 {
//            lineCollection.remove(at: isColliding.1)
//        }
//    }
    
//    func checkForCollisionWithElement(location: CGPoint, needsReferential : Bool) -> (Bool, Int) {
//        let selectionArea = makeSelectionPath(location: location, of: selectionRadius, needsReferential: needsReferential)
//
//        for i in 0..<lineCollection.count {
//            let line = lineCollection[i].path
//            let points = line.getPathElementsPoints()
//
//            for point in points {
//                if selectionArea.contains(point){
//                    return (true, i)
//                }
//            }
//        }
//        return (false, -1)
//    }
    
    
//    func makeSelectionPath(location : CGPoint, of radius: CGFloat, needsReferential : Bool) -> UIBezierPath {
//        let pt = needsReferential ? pointInReferential(point: location) : location
//        return UIBezierPath(arcCenter: pt, radius: radius, startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
//    }
    
//    private func pointInReferential(point location: CGPoint) -> CGPoint {
//        return CGPoint(x: location.x, y: frame.height - location.y)
//    }
    
//    private func clearPoints() {
//        pointCollection.removeAll()
//    }
    
    // makes circles --> use in later version of polypaint
//    func makeCirlceInPosition(location: CGPoint){
//        let circle = SKShapeNode(circleOfRadius: currentWidth/2 )
//
//        circle.position = location
//        circle.name = "defaultCircle"
//        circle.strokeColor = SKColor.red
//        circle.glowWidth = 1.0
//        circle.fillColor = SKColor.green
//
//        self.addChild(circle)
//    }
    
//    func splitSegment(at location: CGPoint) {
//        let hit = checkForCollisionWithElement(location: location, needsReferential: false)
//        
//        if hit.0 {
//            let line = lineCollection[hit.1]
//            let points = line.path.getPathElementsPoints()
//            var newSegmentPoints:[CGPoint] = []
//            var isInSelectionPath = false
//            
//            // trace new segments
//            let selectionPath = makeSelectionPath(location: location, of: eraserRadius, needsReferential: false)
//            for point in points {
//                if !selectionPath.contains(point){
//                    newSegmentPoints.append(point)
//                    isInSelectionPath = false
//                }
//                else if !isInSelectionPath {
//                    isInSelectionPath = true
//                    createSegmentPath(with: &newSegmentPoints, color: line.color, width: line.width, drawCurrentLine : false)
//                }
//            }
//            createSegmentPath(with: &newSegmentPoints, color: line.color, width: line.width, drawCurrentLine : false)
//            
//            // remove hit line from collection
//            lineCollection.remove(at: hit.1)
//        }
//    }
}



