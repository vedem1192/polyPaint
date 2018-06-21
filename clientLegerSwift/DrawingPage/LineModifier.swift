//
//  LineModifier.swift
//  clientLegerSwift
//
//  Created by veronique demers on 18-03-21.
//  Copyright © 2018 log3900. All rights reserved.
//

import UIKit
import SpriteKit

class LineModifier {
    
    let drawing = LineDrawing.instance
    let selectionRadius: CGFloat = 44
    let eraserRadius: CGFloat = 25
    var previousRotation : CGFloat = 0.0
    
    private func checkForCollisionWithElement(location: CGPoint, needsReferential : Bool) -> (Bool, Int) {
        let selectionArea = makeSelectionPath(location: location, of: selectionRadius, needsReferential: needsReferential)
        
        for i in 0..<drawing.lineCollection.count {
            let line = drawing.lineCollection[i].path
            let points = line.getPathElementsPoints()
            
            for point in points {
                if selectionArea.contains(point){
                    return (true, i)
                }
            }
        }
        return (false, -1)
    }
    
    
    private func makeSelectionPath(location : CGPoint, of radius: CGFloat, needsReferential : Bool) -> UIBezierPath {
        let pt = needsReferential ? pointInReferential(point: location) : location
        return UIBezierPath(arcCenter: pt, radius: radius, startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
    }
    
    private func pointInReferential(point location: CGPoint) -> CGPoint {
        return CGPoint(x: location.x, y: drawing.frame.height - location.y)
    }
    
    func eraseFullElement(_ location : CGPoint) {
        let isColliding = checkForCollisionWithElement(location: location, needsReferential: true)
        if isColliding.0 {
            let hasAuthority = drawing.objectGenerator.checkForAuthorityPermission(id:drawing.lineCollection[isColliding.1].id!)
            if (hasAuthority) {
                drawing.objectGenerator.removeAuthority(id: drawing.lineCollection[isColliding.1].id!)
                drawing.objectGenerator.drawingManager.sendStrokeEraseByLineMessage(id: drawing.lineCollection[isColliding.1].id!)
                drawing.lineCollection.remove(at: isColliding.1)
            }
        }
    }
    
    func splitSegment(at location: CGPoint) {
        let hit = checkForCollisionWithElement(location: location, needsReferential: false)
        
        if hit.0 {
            let hasAuthority = drawing.objectGenerator.checkForAuthorityPermission(id:drawing.lineCollection[hit.1].id!)
            if (hasAuthority) {
                let line = drawing.lineCollection[hit.1]
                let points = line.path.getPathElementsPoints()
                var newSegmentPoints:[CGPoint] = []
                var isInSelectionPath = false
                
                // trace new segments
                let selectionPath = makeSelectionPath(location: location, of: eraserRadius, needsReferential: false)
                for point in points {
                    if !selectionPath.contains(point){
                        newSegmentPoints.append(point)
                        isInSelectionPath = false
                    }
                    else if !isInSelectionPath {
                        isInSelectionPath = true
                        drawing.objectGenerator.createSegmentPath(with : &newSegmentPoints, color: line.color, width: line.width, drawCurrentLine: false)
                    }
                }
                drawing.objectGenerator.createSegmentPath(with : &newSegmentPoints, color: line.color, width: line.width, drawCurrentLine: false)
                drawing.objectGenerator.drawingManager.sendStrokeEraseByLineMessage(id: drawing.lineCollection[hit.1].id!)
                drawing.objectGenerator.removeAuthority(id: drawing.lineCollection[hit.1].id!)
                drawing.lineCollection.remove(at: hit.1)
            }
        }
    }
    
    func rotate(selectedElements : [Int], of angle : CGFloat) {
        let bound = drawing.objectGenerator.dashed.path.boundingBox
        let center = CGPoint(x: bound.midX, y: bound.midY)
        
        let rotation = angle - previousRotation
        previousRotation = angle

        var transform = CGAffineTransform(translationX: center.x, y: center.y)
        transform = transform.rotated(by: -rotation)
        transform = transform.translatedBy(x: -center.x, y: -center.y)

        for index in 0..<selectedElements.count {
            let path = UIBezierPath(cgPath: drawing.lineCollection[index].path)
            path.apply(transform)
            drawing.lineCollection[index].path = path.cgPath as! CGMutablePath
        }
    }
    
    func rotateShape(of angle : CGFloat) {
        var shape = drawing.shapeCollection[selectedShapes[0]]

        // try rotation position aroun center
        shape.skNode.zRotation = -angle
    }
    
    func containingLine() -> Bool {
        drawing.pasteCollection.removeAll()
        drawing.selectedLine.removeAll()
        drawing.selectedLineObject.removeAll()
        drawing.objectGenerator.removeMyAuthority()
        
        for y in 0..<drawing.lineCollection.count {
            let l = drawing.lineCollection[y].path
            let points = l.getPathElementsPoints()
            var contains = true
            var index = 0
            
            while (contains == true && index < points.count){
                contains = drawing.objectGenerator.dashed.path.contains(points[index])
                index = index + 1
            }
            let hasAuthority = drawing.objectGenerator.checkForAuthorityPermission(id:drawing.lineCollection[y].id!)
            if (contains == true && hasAuthority){
                drawing.selectedLine.append(y)
                drawing.selectedLineObject.append(drawing.lineCollection[y])
                drawing.pasteCollection.append(drawing.lineCollection[y])
                let tempAuthorityList = AuthorityList(_strokeId: drawing.lineCollection[y].id!, _username: drawing.objectGenerator.drawingManager.networkManager.username)
                    drawing.objectGenerator.drawingManager.authorityIdList.append(tempAuthorityList)
            }
            if (!hasAuthority) {
                drawing.selectedLine.removeAll()
                drawing.selectedLineObject.removeAll()
                drawing.pasteCollection.removeAll()
                drawing.objectGenerator.removeMyAuthority()
                break;
            }
        }
        drawing.objectGenerator.sendAuthorityIdList()
        
        return !drawing.selectedLine.isEmpty
    }
    
    
    // TODO : FIX THIS
    var selectedShapes : [Int] = []
    func containigShapes() -> Bool {
        selectedShapes.removeAll()
        
        for i in 0..<drawing.shapeCollection.count {
            let shape = drawing.shapeCollection[i].skNode.accessibilityPath?.cgPath
            let points = shape?.getPathElementsPoints()
        
            var contains = true
            var index = 0
            while (contains == true && index < points!.count){
                contains = drawing.objectGenerator.dashed.path.contains(points![index])
                index = index + 1
            }
            if (contains == true ){
                selectedShapes.append(i)
            }
        }
        print(selectedShapes)
        return !selectedShapes.isEmpty
    }
    
    var selectedTextView : UITextView!
    func containigTextView() -> Bool {
        drawing.textCollection.removeAll()
        
        for i in 0..<drawing.textCollection.count {
            var corners = drawing.textCollection[i].frame
            corners.origin = pointInReferential(point: corners.origin)
            
            print(drawing.objectGenerator.dashed.path.contains(corners.origin))
            if drawing.objectGenerator.dashed.path.contains(corners.origin) {
                selectedTextView = drawing.textCollection[i]
                return true
            }
        }
        return false
    }
    
    func cutSelection(){
        drawing.selectedLine.reverse()
        drawing.selectedLineObject.reverse()
        for i in 0..<drawing.selectedLine.count {
            drawing.objectGenerator.removeAuthority(id: drawing.selectedLineObject[i].id!)
            drawingManager.sendStrokeEraseByLineMessage(id: drawing.selectedLineObject[i].id!)
            drawing.lineCollection.remove(at: drawing.selectedLine[i])
        }
        drawing.selectedLine.removeAll()
        drawing.selectedLineObject.removeAll()
    }
    
    func copy() {
        for i in 0..<drawing.pasteCollection.count{
            var tempLine: LineObject = drawing.objectGenerator.transformLine(lineObject: drawing.pasteCollection[i])
            drawing.lineCollection.append(tempLine)
            drawingManager.sendLineObject(sendableLineObject: drawing.objectGenerator.createSendableLineObject(lineObject: tempLine))
        }
    }
    
    func paste(){
        //for cut
        for i in 0..<drawing.pasteCollection.count{
            drawing.lineCollection.append(drawing.pasteCollection[i])
            drawingManager.sendLineObject(sendableLineObject: drawing.objectGenerator.createSendableLineObject(lineObject: drawing.pasteCollection[i]))
        }
    }
    
    

}












