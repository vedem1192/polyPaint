//
//  DrawingPageViewControllerExtensions.swift
//  clientLegerSwift
//
//  Created by veronique demers on 18-03-31.
//  Copyright © 2018 log3900. All rights reserved.
//

import UIKit
import AVFoundation

extension DrawingPageViewController {
    
    // MARK: Backbone of pixel and line image exportation
    func exportImage() {
        if drawingMode == .Line {
            prepareCanvas()
            let image = captureScreen()
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
            restoreCanvas()
        }
        else if drawingMode == .Pixel {
            UIImageWriteToSavedPhotosAlbum(imageview.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
    
    func prepareCanvas() {
        settingButton.isHidden = true
        undoButton.isHidden = true
        redoButton.isHidden = true
        colorButton.isHidden = true
        drawingMenuView.isHidden = true
        appNavigationView.isHidden = true
        facebookButton.isHidden = true
    }
    
     func captureScreen() -> UIImage {
        let bounds = self.view.bounds
        UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0)
        self.view.drawHierarchy(in: bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    func restoreCanvas() {
        settingButton.isHidden = false
        if drawingMode == Mode.Line {
            undoButton.isHidden = false
            redoButton.isHidden = false
        }
        colorButton.isHidden = false
        drawingMenuView.isHidden = false
        appNavigationView.isHidden = false
        facebookButton.isHidden = false
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
        else {
            let ac = UIAlertController(title: "Amazing!", message: "Your drawing has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    
    // MARK: Image Modification handlers
    func showImageModifierMenu() {
        imageModifierView.show()
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc func scale(_ sender: UIPinchGestureRecognizer) {
        if drawingMode == .Line {
            drawing.scale(sender)
        }
        else {
            pixelDrawing.scale(sender, scale : sender.scale)
        }
    }
    
    @objc func rotate(_ sender: UIRotationGestureRecognizer) {
        if drawingMode == .Line {
            drawing.rotate(sender)
        }
        else {
            pixelDrawing.rotate(sender)
        }
    }
    
    @objc func pan(_ sender: UIPanGestureRecognizer) {
        if drawingMode == .Line {
            drawing.pan(sender)
        }
        else {
            let location = sender.translation(in: self.view)
            pixelDrawing.pan(sender, point: location)
        }
    }
    
    
}
