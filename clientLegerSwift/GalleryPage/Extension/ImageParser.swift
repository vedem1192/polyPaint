//
//  ImageParser.swift
//  clientLegerSwift
//
//  Created by Simon Barrette on 18-04-07.
//  Copyright © 2018 log3900. All rights reserved.
//

import Foundation
import UIKit
extension GalleryManager {
    
    func convertByteArrayToUIImage(stringImage: String) -> UIImage? {
        // convert string to byte array
        let option = Data.Base64DecodingOptions.ignoreUnknownCharacters
        let dataDecoded:NSData = NSData(base64Encoded: stringImage, options: option)!
        
        let testImage = UIImage(data: dataDecoded as! Data, scale: 1.0)
        return testImage
    }
    
    func convertUIImageToByteArray(image: UIImage) -> String {
        // encoding
        let imageData = UIImageJPEGRepresentation(image, 0.1)
        let encodingBase64 = imageData?.base64EncodedString(options: .lineLength64Characters)
        return encodingBase64!
    }
}
