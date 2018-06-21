//
//  Drawing.swift
//  clientLegerSwift
//
//  Created by veronique demers on 18-03-28.
//  Copyright © 2018 log3900. All rights reserved.
//

import UIKit

private class PixelDrawingHelper {
    var controller : UIViewController?
    var imageview : UIImageView?
}

class PixelDrawing {
    
    static let instance = PixelDrawing()
    private static let setup = PixelDrawingHelper()
    
    enum State {
        case Draw
        case Erase
        case ImageModification
        case EyeDropping
        case SelectByColor
        case Saturation
    }
    
    var defaults : UserDefaults = UserDefaults.standard
    var currentState: State!
    var currentStrokeColor = #colorLiteral(red: 0.6642242074, green: 0.6642400622, blue: 0.6642315388, alpha: 1)
    var currentWidth:CGFloat = 2
    var modifiedPixel : [CGPoint] = []
    var blankCanvas : UIImage!
    var whitePixel : Pixel!
    var currentModifiengImage : UIImageView!
    
    var rotation = CGAffineTransform(rotationAngle: 0)
    var scaling = CGAffineTransform(scaleX: 1, y: 1)
    var panning = CGAffineTransform(translationX: 0, y: 0)
    
    var selectedPixels : [Int] = []
    var selectionByColorThreshold = 0
    let canvasWidth = 768
    let canvasHeight = 1024
    
    class func setup(controller : UIViewController, imageview: UIImageView) {
        PixelDrawing.setup.controller = controller
        PixelDrawing.setup.imageview = imageview
    }
    
    private init() {
        resetSingleton()
    }
    
    func resetSingleton() {
        let viewController = PixelDrawing.setup.controller
        let uiImageView = PixelDrawing.setup.imageview
        
        guard let controller = viewController else { fatalError() }
        guard let imageview = uiImageView else { fatalError() }
        
        let width_input = Int(controller.view.frame.width)
        let height_input = Int(controller.view.frame.height)
        
        whitePixel = Pixel(r:255, g:255, b:255, a:255)
        let pixelData:[Pixel] = Array(repeating: whitePixel, count: width_input*height_input)
        
        controller.view.insertSubview(imageview, at: 0)
        
        imageview.frame = CGRect(x: 0,y: 0, width: width_input, height: height_input)
        imageview.image = pixelDraw(pixel: pixelData, width: width_input, height: height_input)
    }
    
    private func getContextInfo(image : UIImage ) -> (buffer : UnsafeMutablePointer<Pixel>?, context: CGContext?, width : Int?, height: Int?) {
        guard let inputCGImage = image.cgImage else { return (nil,nil,nil,nil)}
        guard let context = getContext(inputCGImage: inputCGImage) else { return (nil,nil,nil,nil)}
        guard let buffer = context.data else { return (nil,nil,nil,nil)}
        
        let width = inputCGImage.width
        let height = inputCGImage.height
        
        context.draw(inputCGImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        let pixelBuffer = buffer.bindMemory(to: Pixel.self, capacity: width * height)
        
        return (pixelBuffer, context, width, height)
    }
    
    private func pixelDraw(pixel:[Pixel], width:Int, height:Int) -> UIImage {
        let data = UnsafeMutableRawPointer(mutating: pixel)
        let bitmapContext = PixelContext.init(data: data, width: width, height: height)
        let image = bitmapContext.context.makeImage()
        
        blankCanvas = UIImage(cgImage: image!)
        return blankCanvas
    }
    
    func getContext(inputCGImage : CGImage) -> CGContext? {
        let context = PixelContext(data: nil, width: inputCGImage.width, height: inputCGImage.height)
        return context.context
    }
    
    private func getPixelOf(color : UIColor) -> Pixel {
        let rgb = color.cgColor.components
        let alpha = color.cgColor.alpha
        return Pixel(r: UInt8(rgb![0]*255) , g: UInt8(rgb![1]*255), b: UInt8(rgb![2]*255), a: UInt8(alpha*255))
    }
    

    func draw(in image: UIImage, at location : CGPoint, isErasing : Bool) -> UIImage? {
        let contextInfo = getContextInfo(image: image)
        modifiedRelevantPixels(pixelBuffer: contextInfo.buffer!, width: contextInfo.width!, height: contextInfo.height!, location: location, isErasing: isErasing)
        
        let outputCGImage = contextInfo.context!.makeImage()!
        let outputImage = UIImage(cgImage: outputCGImage, scale: image.scale, orientation: image.imageOrientation)
        
        return outputImage
    }
    
    private func modifiedRelevantPixels(pixelBuffer:UnsafeMutablePointer<Pixel>, width: Int, height: Int, location: CGPoint, isErasing: Bool) {
        let currentColorPixel = getPixelOf(color: currentStrokeColor)
        let square = getSquareEncompassingCircle(center: location, radius: currentWidth/2)
        modifiedPixel.append(location)
        
        for row in Int(square.minX)...Int(square.maxX){
            for column in Int(square.minY)...Int(square.maxY) {
                
                let pixelLocation = CGPoint(x: row, y: column)
                let size = CGSize(width: width, height: height)
                if isValidPixel(pixelLocation: pixelLocation, size: size, origin: location, radius: currentWidth/2) {
                    
                    let pixel = row * width + column
                    let newColor = isErasing ? whitePixel : currentColorPixel
                    
                    if pixelBuffer[pixel] != newColor! {
                        pixelBuffer[pixel] = newColor!
                    }
                }
            }
        }
    }
    
    func insertModifiedPixelInDrawing(with pixels : [CGPoint], color : UIColor, width : CGFloat, image : UIImage) -> UIImage? {
        let newColorPixel = getPixelOf(color: color)
        let contextInfo = getContextInfo(image: image)
        
        for pixel in pixels {
            print("something")
            let square = getSquareEncompassingCircle(center: pixel, radius: width/2)
            for row in Int(square.minX)...Int(square.maxX) {
                for column in Int(square.minY)...Int(square.maxY) {
                    
                    let pixelLocation = CGPoint(x: row, y: column)
                    let size = CGSize(width: canvasWidth, height: canvasHeight)
                    if isValidPixel(pixelLocation: pixelLocation, size: size, origin: pixel, radius: width/2) {
                        
                        let index = row * canvasWidth + column
                        contextInfo.buffer![index] = newColorPixel
                    }
                }
            }
        }
        let outputCGImage = contextInfo.context!.makeImage()!
        let outputImage = UIImage(cgImage: outputCGImage, scale: image.scale, orientation: image.imageOrientation)
        
        return outputImage
    }

    private func getSquareEncompassingCircle(center location : CGPoint, radius : CGFloat) -> CGRect {
        let origin = CGPoint(x: (location.x - radius), y: (location.y - radius))
        let size = CGSize(width: 2*radius, height: 2*radius)
        
        return CGRect(origin: origin, size: size)
    }
    
    private func isValidPixel(pixelLocation : CGPoint, size: CGSize, origin: CGPoint, radius: CGFloat) -> Bool {
        return isContainedInCanvas(row: pixelLocation.x, column: pixelLocation.y, width: size.width, height: size.height) &&
            isContainedInBrush(row: pixelLocation.x, column: pixelLocation.y, origin: origin, radius: radius)
    }
    
    private func isContainedInBrush(row: CGFloat, column: CGFloat, origin: CGPoint, radius: CGFloat) -> Bool {
        let distanceToCenter = pow(Double(origin.x - row), 2.0) + pow(Double(origin.y - column), 2.0)
        return distanceToCenter <= pow(Double(radius), 2.0)
    }
    
    private func isContainedInCanvas(row: CGFloat, column: CGFloat, width: CGFloat, height: CGFloat) -> Bool {
        return row >= 0 && row < height && column >= 0 && column < width
    }
    
    func emptyModifiedArrayPixel() {
        modifiedPixel.removeAll()
    }
    
    func rotate(_ sender : UIRotationGestureRecognizer) {
        if currentState == State.ImageModification {
            if sender.state == .changed {
                rotation = CGAffineTransform(rotationAngle: sender.rotation)
                currentModifiengImage.transform = rotation.concatenating(scaling)
            }
        }
    }
    
    func scale(_ sender : UIPinchGestureRecognizer, scale : CGFloat) {
        if currentState == State.ImageModification {
            if sender.state == .changed {
                scaling = CGAffineTransform(scaleX: scale, y: scale)
                scaling = scaling.concatenating(panning)
            }
        }
    }
    
    func pan(_ sender : UIPanGestureRecognizer, point : CGPoint) {
        if currentState == State.ImageModification {
            if sender.state == .changed {
                panning = CGAffineTransform(translationX: point.x, y: point.y)
            }
        }
    }
    
    // SATURATION
    func changeImageSaturation(of image : UIImage, with value : Int) -> UIImage? {
        let ciimage = CIImage.init(image: image)
        let filter = CIFilter.init(name: "CIColorControls")
        filter?.setValue(ciimage, forKey: kCIInputImageKey)
        filter?.setValue(value, forKey: kCIInputSaturationKey)
        let result = filter?.value(forKey: kCIOutputImageKey) as! CIImage
        let cgImage = CIContext.init(options: nil).createCGImage(result, from: result.extent)
        
        return UIImage.init(cgImage: cgImage!)
    }
    
    // BLACK AND WHITE
    func convertToBlackAndWhite(image : UIImage) -> UIImage? {
        let context = CIContext(options: nil)
        let ciImage = CoreImage.CIImage(image: image)!
        
        // Set image color to b/w
        let bwFilter = CIFilter(name: "CIColorControls")!
        bwFilter.setValuesForKeys([kCIInputImageKey:ciImage, kCIInputBrightnessKey:NSNumber(value: 0.0), kCIInputContrastKey:NSNumber(value: 1.1), kCIInputSaturationKey:NSNumber(value: 0.0)])
        let bwFilterOutput = (bwFilter.outputImage)!
        
        // Adjust exposure
        let exposureFilter = CIFilter(name: "CIExposureAdjust")!
        exposureFilter.setValuesForKeys([kCIInputImageKey:bwFilterOutput, kCIInputEVKey:NSNumber(value: 0.7)])
        let exposureFilterOutput = (exposureFilter.outputImage)!
        
        // Create UIImage from context
        let bwCGIImage = context.createCGImage(exposureFilterOutput, from: ciImage.extent)
        
        return UIImage(cgImage: bwCGIImage!)
    }
    
    // BLUR FILTER
    func blurEffect(image : UIImage) -> UIImage?  {
        let context = CIContext(options: nil)
        let currentFilter = CIFilter(name: "CIGaussianBlur")
        let beginImage = CIImage(image: image)
        
        currentFilter!.setValue(beginImage, forKey: kCIInputImageKey)
        currentFilter!.setValue(10, forKey: kCIInputRadiusKey)
        
        let cropFilter = CIFilter(name: "CICrop")
        cropFilter!.setValue(currentFilter!.outputImage, forKey: kCIInputImageKey)
        cropFilter!.setValue(CIVector(cgRect: beginImage!.extent), forKey: "inputRectangle")
        
        let output = cropFilter!.outputImage
        let cgimg = context.createCGImage(output!, from: output!.extent)
        return UIImage(cgImage: cgimg!)
    }
    
    

    func changeSelectedPixelsColor(to color: UIColor, from image: UIImage) -> UIImage? {
        let contextInfo = getContextInfo(image: image)
        
        for pixel in selectedPixels {
            contextInfo.buffer![pixel] = getPixelOf(color: color)
        }
        
        let outputCGImage = contextInfo.context?.makeImage()!
        let outputImage = UIImage(cgImage: outputCGImage!, scale: image.scale, orientation: image.imageOrientation)
        
        return outputImage
    }
    
    func selectPixel(by color : UIColor, from image : UIImage ) {
        let contextInfo = getContextInfo(image: image)
        populateSelectedPixels(pixelBuffer: contextInfo.buffer!, width: contextInfo.width!, height: contextInfo.height!, color : color)
    }
    
    func populateSelectedPixels(pixelBuffer:UnsafeMutablePointer<Pixel>, width: Int, height: Int, color : UIColor) {
        let chosenColor = colorRange(of: color)
        
        for row in 0..<height {
            for column in 0..<width {
                
                let pixelLocation = CGPoint(x: row, y: column)
                let index = row * width + column
                let pixel = pixelBuffer[index]
                
                if selectionByColorThreshold == 0, pixel.isOfColor(color){
                    selectedPixels.append(index)
                }
                else if liesInRange(pixel: pixel, range : chosenColor) {
                    selectedPixels.append(index)
                }
            }
        }
    }
    
    private func colorRange(of color : UIColor) -> (r: (min: Int, max: Int), g: (min: Int, max: Int), b : (min: Int, max: Int)) {
        let colorRGB = color.cgColor.components
        let colorR = Int(colorRGB![0]*255)
        let colorG = Int(colorRGB![1]*255)
        let colorB = Int(colorRGB![2]*255)
        
        let window = 255 * (Double(selectionByColorThreshold)/100)
        
        let minR = colorR - Int(window/2) < 0 ? 0 : colorR - Int(window/2)
        let maxR = colorR + Int(window/2) > 255 ? 255 : colorR + Int(window/2)
        let rRange = (minR, maxR)
        
        let minG = colorG - Int(window/2) < 0 ? 0 : colorG - Int(window/2)
        let maxG = colorG + Int(window/2) > 255 ? 255 : colorG + Int(window/2)
        let gRange = (minG, maxG)
        
        let minB = colorB - Int(window/2) < 0 ? 0 : colorB - Int(window/2)
        let maxB = colorB + Int(window/2) > 255 ? 255 : colorB + Int(window/2)
        let bRange = (minB, maxB)
        
        return (rRange, gRange, bRange)
    }

    
    private func liesInRange(pixel : Pixel, range : (r: (min: Int, max: Int), g: (min: Int, max: Int), b : (min: Int, max: Int))) -> Bool {
        if pixel == whitePixel {
            return false
        }
        if pixel.r > range.r.max || pixel.r < range.r.min {
            return false
        }
        if pixel.g > range.g.max || pixel.g < range.g.min {
            return false
        }
        if pixel.b > range.b.max || pixel.b < range.b.min {
            return false
        }
        return true
    }
    
    func currentContext() -> UIImage? {
        let layer = UIApplication.shared.keyWindow?.layer
        let scale = UIScreen.main.scale
        
        UIGraphicsBeginImageContextWithOptions(layer!.frame.size, false, 1)
        layer!.render(in: UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return screenshot
    }

    
    
}
