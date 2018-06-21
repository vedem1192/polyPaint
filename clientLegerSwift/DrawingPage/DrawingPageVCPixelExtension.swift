//
//  DrawingPageVCPixelExtension.swift
//  clientLegerSwift
//
//  Created by veronique demers on 18-04-06.
//  Copyright © 2018 log3900. All rights reserved.
//

import UIKit

// FOR PIXEL DRAWING ONLY Import image
extension DrawingPageViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func getPhotoFromSource(source : UIImagePickerControllerSourceType ) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.modalPresentationStyle = .currentContext
            imagePicker.delegate = self
            imagePicker.sourceType = source
            imagePicker.allowsEditing = false

            self.present(imagePicker, animated: true, completion: nil)
        }
        else {
            print("Invalid device choice")
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        picker.delegate = nil
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if picker.sourceType == .photoLibrary || picker.sourceType == .savedPhotosAlbum {
            if let cameraRollPicture = info[UIImagePickerControllerOriginalImage] as? UIImage {
                pixelDrawing.defaults.set(UIImagePNGRepresentation(cameraRollPicture), forKey: "CameraRollPicture")
            }
        }
        pixelDrawing.currentState = PixelDrawing.State.ImageModification
        picker.dismiss(animated: true, completion: {
            self.revealImage()
        })
        picker.delegate = nil
    }
    
    func revealImage() {
        if let imageDataAsDefault = pixelDrawing.defaults.object(forKey: "CameraRollPicture") as? Data {
            let myImage = UIImage(data: imageDataAsDefault)!
            let imageView = UIImageView(image: myImage)
            imageView.layer.position = CGPoint(x: view.frame.width/2, y: view.frame.width/2)
            pixelDrawing.currentModifiengImage = imageView
            showImageModifierMenu()
            
            self.view.insertSubview(imageView, belowSubview: drawingMenuView)
        }
    }
}








