//
//  LineGenerator.swift
//  clientLegerSwift
//
//  Created by veronique demers on 18-03-21.
//  Copyright © 2018 log3900. All rights reserved.
//

import UIKit
import SpriteKit

class ObjectGenerator {
    enum Action {
        case LineSegment
        case Shape
    }
    
    var drawing = LineDrawing.instance
    var drawingManager = DrawingManager.drawingInstance
    var dashed: LineObject!
    var lineIdNumber: Int = 0
    
    func generateLineId() -> String {
        var lineId = drawingManager.networkManager.username
        lineId = "\(lineId)\(String(lineIdNumber))"
        lineIdNumber += 1
        print(lineId)
        return lineId
    }
    
    func checkForAuthorityPermission(id: String) -> Bool {
        for strokes in drawingManager.authorityIdList {
            if (strokes._strokeId == id && strokes._username != drawingManager.networkManager.username) {
                return false
            }
        }
        return true
    }
    
    func removeAuthority(id: String) {
        let tempDictionnary: Array<AuthorityList> = drawingManager.authorityIdList
        let tempIndex = tempDictionnary.count - 1
        for i in 0..<tempDictionnary.count {
            if (tempDictionnary[(tempIndex - i)]._strokeId == id) {
                drawingManager.authorityIdList.remove(at: (tempIndex - i))
            }
        }
    }
    
    func removeMyAuthority() {
        let tempDictionnary: Array<AuthorityList> = drawingManager.authorityIdList
        let tempIndex = tempDictionnary.count - 1
        for i in 0..<tempDictionnary.count {
            if (tempDictionnary[(tempIndex - i)]._username == drawingManager.networkManager.username) {
                drawingManager.authorityIdList.remove(at: (tempIndex - i))
            }
        }
    }
    
    func sendAuthorityIdList() {
        var strokeIDAuthority: Array<String> = Array()
        for i in 0..<drawingManager.authorityIdList.count {
            strokeIDAuthority.append(drawingManager.authorityIdList[i]._strokeId)
        }
        print("CURRENT", drawingManager.authorityIdList)
        print("SENDING", strokeIDAuthority)
        drawingManager.sendAuthorityRequestMessage(strokeIdList: strokeIDAuthority)
    }
    
    func eraseDrawingObjectWithId(id: String) {
        var removeIndex : Int?
        // line object
        for i in 0..<drawing.lineCollection.count {
            if drawing.lineCollection[i].id == id {
                removeIndex = i
                break
            }
        }
        if let index = removeIndex {
            drawing.lineCollection.remove(at: index)
            return
        }
        
        // shapes
        for i in 0..<drawing.shapeCollection.count {
            if drawing.shapeCollection[i].id == id {
                removeIndex = i
                break
            }
        }
        if let index = removeIndex {
            drawing.shapeCollection[index].skNode.removeFromParent()
        }
        removeAuthority(id: id)
    }
    
    func transformLine(lineObject: LineObject) -> LineObject {
        var pointsArray = [CGPoint]()
        let tempPath = CGMutablePath()
        
        for point in lineObject.path.getPathElementsPoints() {
             let tempCGPoint: CGPoint = CGPoint(x: (point.x + (lineObject.width + 40)), y: (point.y - (lineObject.width + 40)))
            pointsArray.append(tempCGPoint)
        }
        tempPath.addLines(between: pointsArray)
        return LineObject(color: lineObject.color, width: lineObject.width, path: tempPath, id: generateLineId())
    }
    
    func createSegmentPath(with points: inout [CGPoint], color : UIColor, width: CGFloat, drawCurrentLine: Bool) {
        if points.count <= 1 { return }
        var line = LineObject(color: color, width: width)
        
        for i in 0..<points.count {
            let pt = points[i]
            if i == 0 {
                line.path.move(to: pt)
            }
            else {
                line.path.addLine(to: pt)
                if drawCurrentLine{
                    drawing.addChild(createShapeNode(with: line))
                }
            }
        }
        if !drawCurrentLine {
            ///// Adding to collection for fast undo/redo ///////
            line.id = generateLineId()
            drawing.lineCollection.append(line)
            drawing.actionCollection.append(Action.LineSegment)
            
            points.removeAll()
            var sendableLineObject: SendableLineObject
            sendableLineObject = createSendableLineObject(lineObject: line)
            print(sendableLineObject)
            drawingManager.sendLineObject(sendableLineObject: sendableLineObject)
        }
    }
    
    func insertLineInDrawing(with points: inout [CGPoint], color : UIColor, width: CGFloat, id: String) {
        if points.count <= 1 { return }
        let line = LineObject(color: color, width: width, id: id)
        
        for i in 0..<points.count {
            let pt = points[i]
            i == 0 ? line.path.move(to: pt) : line.path.addLine(to: pt)
        }

            drawing.lineCollection.append(line)
            points.removeAll()
    }
    
    func createShapeNode(with line: LineObject) -> SKShapeNode {
        let shapeNode = SKShapeNode()
        
        shapeNode.path = line.path
        shapeNode.name = "line"
        shapeNode.strokeColor = line.color
        shapeNode.lineWidth = line.width
        shapeNode.lineCap = line.cap
        shapeNode.zPosition = 1
        
        return shapeNode
    }
    
    func makeCirlceInPosition(location: CGPoint){
        let circle = SKShapeNode(circleOfRadius: 44 )
        
        circle.position = location
        circle.name = "defaultCircle"
        circle.strokeColor = SKColor.black
        circle.glowWidth = 1.0
        circle.fillColor = SKColor.black
        
        drawing.addChild(circle)
    }
    
    func insert(shape : LineDrawing.Shape, from origin : CGPoint, to location : CGPoint) {
        let name = String(describing: shape)
        let temp = drawing.childNode(withName: name)
        temp?.removeFromParent()
        
        /////////////////////////////////////////////////////////
        let width = location.x - origin.x
        let height = location.y - origin.y
        let rectangle = CGRect(origin: origin , size: CGSize(width: width, height: height))
        let center = CGPoint(x: location.x - width/2, y: location.y - height/2)
        //////////////////////////////////////////////////////////////
        
        let updatedShape = getShape(shape: shape, origin: origin, location: location)
        updatedShape.name = name
        updatedShape.strokeColor = drawing.currentStrokeColor
        updatedShape.lineWidth = drawing.currentWidth
        updatedShape.glowWidth = 1.0
        updatedShape.zPosition = 1
        updatedShape.lineJoin = .round
        updatedShape.position = center
        
        drawing.addChild(updatedShape)
    }

    
    private func getShape(shape : LineDrawing.Shape, origin: CGPoint, location : CGPoint) -> SKShapeNode {
        let width = location.x - origin.x
        let height = location.y - origin.y
        let rectangle = CGRect(origin: origin , size: CGSize(width: width, height: height))
        let center = CGPoint(x: location.x - width/2, y: location.y - height/2)
        
        switch shape {
        case .Elipse:
            return elipse(rect: rectangle, center: center)
        case .Hexagon :
            return hexagon(rect: rectangle, center : center)
        case .Rectangle :
            return rectangleShape(origin: origin, location: location)
        case .Octogon :
            return octogon(rect: rectangle, center: center)
        case .Pentagon :
            return pentagon(rect: rectangle, center: center)
        case .Line :
            return line(origin: origin, location: location)
        case .Triangle :
            return triangle(rect: rectangle, center: center)
        case .Diamond :
            return diamond(origin: origin, location: location)
        case .Arrow :
            return arrow(origin: origin, location: location)
        case .Lightning :
            return lightning(origin: origin, location: location)
        }
    }
    
    
    func set(shape : LineDrawing.Shape) {
        let name = String(describing: shape)
        guard let element = drawing.childNode(withName: name) else { return }
        let newName = "modified"
        element.name = newName + name
        // use this to send to server
        //ASK VERO
        //print("THIS IS THE PATH ? : \(element.accessibilityPath)")
        let commonId = self.generateLineId()
        let currentLineObject = LineObject(color: drawing.currentStrokeColor, width: drawing.currentWidth, path:element.accessibilityPath?.cgPath as! CGMutablePath, id: commonId)
        drawingManager.sendLineObject(sendableLineObject: createSendableLineObject(lineObject: currentLineObject))
        ///// Adding to the collection for fast undo/redo ///////
        drawing.shapeCollection.append(ShapeObject(skNode: element, id: commonId))
        drawing.actionCollection.append(Action.Shape)
    }
    
    
    
    func generateGridOf( spacing : Int) {
        // remove previous grid
        removeGrid()
        
        let relevantSpacing = spacing * 10
        let width = Int(drawing.frame.width)
        let height = Int(drawing.frame.height)
        
        // in x
        for pos in stride(from: relevantSpacing, to: width, by: relevantSpacing) {
            let line = UIBezierPath()
            line.move(to: CGPoint(x: pos, y: 0))
            line.addLine(to: CGPoint(x: pos, y: height))
            let shape = getGridLine(line : line.cgPath)
            drawing.addChild(shape)
        }
        
        // in y
        for pos in stride(from: relevantSpacing, to: height, by: relevantSpacing) {
            let line = UIBezierPath()
            line.move(to: CGPoint(x: 0, y: pos))
            line.addLine(to: CGPoint(x: width, y: pos))
            let shape = getGridLine(line: line.cgPath)
            drawing.addChild(shape)
        }
    }
    
    private func getGridLine(line : CGPath) -> SKShapeNode {
        let gridLine = SKShapeNode(path: line)
        gridLine.lineWidth = 1
        gridLine.strokeColor = .lightGray
        gridLine.name = "grid"
        gridLine.isUserInteractionEnabled = false
        
        return gridLine
    }
    
    func removeGrid() {
        drawing.enumerateChildNodes(withName: "grid", using: { node, stop in
            node.removeFromParent()
        })
    }
    
    func insertTextView(from origin : CGPoint, to location : CGPoint) {
        let maxX = origin.x >= location.x ? origin.x : location.x
        let maxY = origin.y >= location.y ? origin.y : location.y
        let minX = origin.x <= location.x ? origin.x : location.x
        let minY = origin.y <= location.y ? origin.y : location.y
        
        let size = CGSize(width: maxX - minX, height: maxY - minY)
        let originPoint = pointInReferential(point: origin)
        
        let textView = UITextView(frame: CGRect(origin: originPoint, size: size))
        textView.font = UIFont.systemFont(ofSize: drawing.currentWidth)
        textView.textColor = drawing.currentStrokeColor
        
        textView.backgroundColor = UIColor.clear
        textView.becomeFirstResponder()
        textView.isScrollEnabled = false
        textView.delegate = drawing
        
        
        drawing.view?.addSubview(textView)
        drawing.textCollection.append(textView)
        drawing.currentState = LineDrawing.State.Draw
    }
    
    private func pointInReferential(point location: CGPoint) -> CGPoint {
        return CGPoint(x: location.x, y: drawing.frame.height - location.y)
    }
    
    
    func drawLassoLine() {
        if drawing.pointCollection.count <= 1 { return }
        let line = LineObject(color:.black, width: CGFloat(1))
        
        for i in 0..<drawing.pointCollection.count {
            let pt = drawing.pointCollection[i]
            if i == 0 {line.path.move(to: pt)}
                
            else {
                line.path.addLine(to:pt)
                let dashLine = createDashLine(line: line)
                drawing.addChild(dashLine)
            }
        }
    }
    
    private func createDashLine(line : LineObject) -> SKShapeNode {
        let dashLine = SKShapeNode()
        dashLine.strokeColor = UIColor.blue
        dashLine.path = line.path.copy(dashingWithPhase: 2, lengths:[10.0, 10.0])
        dashLine.name = "line"
        dashLine.lineWidth = 1
        dashLine.lineCap = line.cap
        dashLine.zPosition = 1
        
        return dashLine
    }
    
    func createSelectionLasso() {
        if drawing.pointCollection.count <= 1 { return }
        let line = LineObject(color:.black, width: drawing.currentWidth)
        
        for i in 0..<drawing.pointCollection.count {
            let pt = drawing.pointCollection[i]
            if i == 0 {line.path.move(to: pt)}
            else {line.path.addLine(to:pt)}
        }
        dashed = line
        dashed.path.closeSubpath()
        drawing.pointCollection.removeAll()
    }
}

extension CGFloat {
    func radians() -> CGFloat {
        let b = CGFloat.pi * (self/180)
        return b
    }
}








