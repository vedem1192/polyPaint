//
//  LineDrawingExtension.swift
//  clientLegerSwift
//
//  Created by veronique demers on 18-03-30.
//  Copyright © 2018 log3900. All rights reserved.
//

import UIKit
import SpriteKit

extension LineDrawing : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func getPhotoFromSource(source : UIImagePickerControllerSourceType ) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.modalPresentationStyle = .currentContext
            imagePicker.delegate = self
            imagePicker.sourceType = source
            imagePicker.allowsEditing = false
            
            presentingVC.present(imagePicker, animated: true, completion: nil)
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
                defaults.set(UIImagePNGRepresentation(cameraRollPicture), forKey: "CameraRollPicture")
            }
        }
        currentState = LineDrawing.State.ImageModification
        picker.dismiss(animated: true, completion: {
            self.revealImage()
        })
        picker.delegate = nil
    }
    
    func revealImage() {
        if let imageDataAsDefault = defaults.object(forKey: "CameraRollPicture") as? Data {
            let myImage = UIImage(data: imageDataAsDefault)!
            let width = (myImage.cgImage?.width)!
            let height = (myImage.cgImage?.height)!

            let texture = SKTexture(image: myImage)
            let imageNode = SKSpriteNode(texture: texture, size: CGSize(width: width, height: height))
            let center = CGPoint(x: frame.width/2, y: frame.height/2)
            imageNode.position = center
            imageNode.name = "image"
            
            self.addChild(imageNode)
            presentingVC.showImageModifierMenu()
        }
    }
}

extension LineDrawing : UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let fixedWidth = textView.frame.size.width
        textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = textView.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        textView.frame = newFrame
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.isUserInteractionEnabled = false
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
}
















