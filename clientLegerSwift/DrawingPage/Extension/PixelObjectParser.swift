//
//  PixelObjectParser.swift
//  clientLegerSwift
//
//  Created by Simon Barrette on 18-04-08.
//  Copyright © 2018 log3900. All rights reserved.
//

import Foundation
extension PixelDrawing {
    
    func createPixelMessage(modifiedPixelArray: [CGPoint], width: CGFloat, color: UIColor) -> ModifiedPixelMessage {
        var listOfPixels: Array<SendablePixel> = Array()
        let modifColor: [Int] = UIColor.IntArrayFromUIColor(color: color)
        let modifWidth: Int = Int(width)
        modifiedPixel.forEach { (point) in
            let tempPixel = preparePointToBeSent(pixel: point)
            listOfPixels.append(tempPixel)
        }
        return ModifiedPixelMessage(pixels: listOfPixels, width: modifWidth, color: modifColor)
    }
    
    func addModifiedPixel(modifiedPixelMessage: ModifiedPixelMessage, image: UIImage) -> UIImage? {
        var color: UIColor = UIColor.UIColorFromIntArray(components: modifiedPixelMessage._color)
        var modifiedPixelArray = [CGPoint]()
        var width: CGFloat = CGFloat(modifiedPixelMessage._width)
        
        modifiedPixelMessage._pixels.forEach { (sendablePixel) in
            let tempCGPoint = preparePointToBeDraw(sendablePixel: sendablePixel)
            modifiedPixelArray.append(tempCGPoint)
        }
        return insertModifiedPixelInDrawing(with: modifiedPixelArray, color : color, width: width, image : image)
    }
    
    func preparePointToBeSent(pixel: CGPoint) -> SendablePixel {
        //Are Pixel at the same place?!
        let tempPoint: SendablePixel = SendablePixel(x: Int(pixel.y), y: Int(pixel.x))
        return tempPoint
    }
    
    func preparePointToBeDraw(sendablePixel: SendablePixel) -> CGPoint {
        //Are Pixel at the same place?!
        let tempCGPoint: CGPoint = CGPoint(x: sendablePixel._y, y: sendablePixel._x)
        return tempCGPoint
    }
}
