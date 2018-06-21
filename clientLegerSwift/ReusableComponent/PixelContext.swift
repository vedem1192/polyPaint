//
//  customCGContext.swift
//  clientLegerSwift
//
//  Created by veronique demers on 18-03-29.
//  Copyright © 2018 log3900. All rights reserved.
//

import UIKit

class PixelContext {
    
    var context : CGContext!
    let colorSpace       = CGColorSpaceCreateDeviceRGB()
    let bytesPerPixel    = 4
    let bitsPerComponent = 8
    let bitmapInfo       = CGImageAlphaInfo.premultipliedLast.rawValue
    
    init(data : UnsafeMutableRawPointer?, width: Int, height: Int) {
        if let data = data {
            context = CGContext(data: data,
                                width: width,
                                height: height,
                                bitsPerComponent: bitsPerComponent,
                                bytesPerRow: bytesPerPixel * width,
                                space: colorSpace,
                                bitmapInfo: bitmapInfo)
        }
        else {
            context = CGContext(data: nil,
                       width: width,
                       height: height,
                       bitsPerComponent: bitsPerComponent,
                       bytesPerRow: bytesPerPixel * width,
                       space: colorSpace,
                       bitmapInfo: bitmapInfo)
        }
    }
}
