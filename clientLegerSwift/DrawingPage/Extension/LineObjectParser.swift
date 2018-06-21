//
//  LineObjectParser.swift
//  clientLegerSwift
//
//  Created by Simon Barrette on 18-03-24.
//  Copyright © 2018 log3900. All rights reserved.
//

import Foundation
import UIKit

extension ObjectGenerator {
    
   func createLineObject(sendableLineObject: SendableLineObject) -> LineObject {
        let color: UIColor
        var pointsArray = [CGPoint]()
        let path = CGMutablePath()
        let width: CGFloat
        
        sendableLineObject._listOfPoints.forEach { (point) in
            let tempCGPoint: CGPoint = preparePointToBeDraw(point: point)
            pointsArray.append(tempCGPoint)
        }
        path.addLines(between: pointsArray)
        color = UIColor.UIColorFromArray(components: sendableLineObject._color)
        width = CGFloat(sendableLineObject._width)
        return LineObject(color: color, width: width, path: path, id: sendableLineObject._Id)
    }
    
    func createSendableLineObject(lineObject: LineObject) -> SendableLineObject {
        var listOfPoints: Array<Points> = Array()
        var color: [Float]
        var width: Float
        
        lineObject.path.getPathElementsPoints().forEach { (point) in
            let tempPoint: Points = preparePointToBeSent(point: point)
            listOfPoints.append(tempPoint)
        }
        width = Float(lineObject.width)
        color = UIColor.ArrayFromUIColor(color: lineObject.color)
        return SendableLineObject(listOfPoints: listOfPoints, width: width, color: color, id: lineObject.id!)
    }
    
    func addLineObject(sendableLineObject: SendableLineObject) {
        let color: UIColor
        var pointsArray = [CGPoint]()
        let width: CGFloat
        
        sendableLineObject._listOfPoints.forEach { (point) in
            let tempCGPoint: CGPoint = preparePointToBeDraw(point: point)
            pointsArray.append(tempCGPoint)
        }
        color = UIColor.UIColorFromArray(components: sendableLineObject._color)
        width = CGFloat(sendableLineObject._width)
        insertLineInDrawing(with: &pointsArray, color : color, width: width, id: sendableLineObject._Id)
    }
    
    func addLineObject(lineObjectMessage: LineObjectMessage) {
        let color: UIColor
        var pointsArray = [CGPoint]()
        let width: CGFloat
        let sendableLineObject = SendableLineObject(listOfPoints: lineObjectMessage.ListOfPoints, width: lineObjectMessage._width, color: lineObjectMessage._color, id: lineObjectMessage._Id)
        
        sendableLineObject._listOfPoints.forEach { (point) in
            let tempCGPoint: CGPoint = preparePointToBeDraw(point: point)
            pointsArray.append(tempCGPoint)
        }
        color = UIColor.UIColorFromArray(components: sendableLineObject._color)
        width = CGFloat(sendableLineObject._width)
        insertLineInDrawing(with: &pointsArray, color : color, width: width, id: sendableLineObject._Id)
    }
    
    func addLineObject(strokeMovedMessage: StrokeMovedMessage) {
        let color: UIColor
        var pointsArray = [CGPoint]()
        let width: CGFloat
        let sendableLineObject = SendableLineObject(listOfPoints: strokeMovedMessage.ListOfPoints, width: strokeMovedMessage._width, color: strokeMovedMessage._color, id: strokeMovedMessage._Id)
        
        sendableLineObject._listOfPoints.forEach { (point) in
            let tempCGPoint: CGPoint = preparePointToBeDraw(point: point)
            pointsArray.append(tempCGPoint)
        }
        color = UIColor.UIColorFromArray(components: sendableLineObject._color)
        width = CGFloat(sendableLineObject._width)
        insertLineInDrawing(with: &pointsArray, color : color, width: width, id: sendableLineObject._Id)
    }
    
    func movedStroke(strokeMovedMessage: StrokeMovedMessage) {
        var isChanged = false
        for i in 0..<drawing.lineCollection.count {
            if( drawing.lineCollection[i].id == strokeMovedMessage._Id && isChanged == false) {
                let tempLineObject: LineObject = drawing.lineCollection[i]
                var tempCGPointsArray = [CGPoint]()
                strokeMovedMessage.ListOfPoints.forEach { (point) in
                    let tempCGPoint: CGPoint = preparePointToBeDraw(point: point)
                    tempCGPointsArray.append(tempCGPoint)
                }
                drawing.lineCollection.remove(at: i)
                insertLineInDrawing(with: &tempCGPointsArray, color: tempLineObject.color, width: tempLineObject.width, id: tempLineObject.id!)
                isChanged = true
            }
//            if( drawing.shapeCollection[i].id == strokeMovedMessage._Id && isChanged == false) {
//                //ASK VERO FOR SHAPES
//                //drawing.shapeCollection[i].skNode.removeFromParent()
//                isChanged = true
//            }
        }
        if (!isChanged) {
            addLineObject(strokeMovedMessage: strokeMovedMessage)
        }
    }
    
    func preparePointToBeSent(point: CGPoint) -> Points {
        //let tempPoint: Points = Points.init(x: Int(point.x/drawing.frame.width), y: Int((drawing.frame.height - point.y)/drawing.frame.height))
        let tempPoint: Points = Points.init(x: Int(point.x), y: Int(drawing.frame.height - point.y))
        return tempPoint
    }
    
    func preparePointToBeDraw(point: Points) -> CGPoint {
        //let tempCGPoint: CGPoint = CGPoint.init(x: point._x*Int(drawing.frame.width), y:(Int(drawing.frame.height) - point._y*Int(drawing.frame.height))
        let tempCGPoint: CGPoint = CGPoint.init(x: point._x, y:(Int(drawing.frame.height) - point._y))
        return tempCGPoint
    }

}

public extension UIColor {
    
    class func ArrayFromUIColor(color: UIColor) -> Array<Float> {
        let components = color.cgColor.components
        var colorArray = [Float]()
        colorArray.append(contentsOf: [Float(components![3]), Float(components![0]), Float(components![1]), Float(components![2])])
        return colorArray
    }
    
    class func IntArrayFromUIColor(color: UIColor) -> [Int] {
        let components = color.cgColor.components
        var colorArray = [Int]()
        colorArray.append(contentsOf: [Int(components![0]*255), Int(components![1]*255), Int(components![2]*255), Int(components![3]*255)])
        return colorArray
    }
    
    class func UIColorFromIntArray(components: [Int]) -> UIColor {
        return UIColor(red: (CGFloat(components[0])/255.0),
                       green: (CGFloat(components[1])/255.0),
                       blue: (CGFloat(components[2])/255.0),
                       alpha: (CGFloat(components[3])/255.0))
    }
    
    class func UIColorFromArray(components: [Float]) -> UIColor {
        return UIColor(red: CGFloat(components[1]),
                       green: CGFloat(components[2]),
                       blue: CGFloat(components[3]),
                       alpha: CGFloat(components[0]))
    }
    
    class func StringFromUIColor(color: UIColor) -> String {
        let components = color.cgColor.components
        return "[\(components![3]), \(components![0]), \(components![1]), \(components![2])]"
    }
    
    class func UIColorFromString(string: String) -> UIColor {
        let componentsString = string.replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "")
        let components = componentsString.components(separatedBy: ", ")
        return UIColor(red: CGFloat((components[1] as NSString).floatValue),
                       green: CGFloat((components[2] as NSString).floatValue),
                       blue: CGFloat((components[3] as NSString).floatValue),
                       alpha: CGFloat((components[0] as NSString).floatValue))
    }
}
