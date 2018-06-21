//
//  GalleryPageViewControllerExtension.swift
//  clientLegerSwift
//
//  Created by veronique demers on 18-04-09.
//  Copyright © 2018 log3900. All rights reserved.
//

import UIKit

extension GalleryPageViewController :  UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == self.collectionView ? self.drawings.count : self.privateDrawings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "galleryCell", for: indexPath as IndexPath) as! GalleryViewCell
            constructCell(from: drawings, cell: cell)
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "galleryPrivateCell", for: indexPath as IndexPath) as! GalleryViewPrivateCell
            constructPrivateCell(from: privateDrawings, cell: cell)
            return cell
        }
    }
    
    private func constructPrivateCell(from array : [DrawingObject], cell : GalleryViewPrivateCell) {
        let index = array.count - 1
        
        if let image = array[index]._image {
            if let uiimage = galleryManager.convertByteArrayToUIImage(stringImage: array[index]._image!) {
                cell.imageView.image = uiimage
            }
            else {
                cell.imageView.image = UIImage(named: "6")
            }
        }
        else {
            cell.imageView.image = UIImage(named: "7")
        }
        
        // the rest
        cell.title.text = array[index]._title
        cell.layer.borderColor = #colorLiteral(red: 0.658308804, green: 0.8193534017, blue: 0.9075077176, alpha: 1)
        cell.layer.borderWidth = 2
        cell.layer.cornerRadius = 8
    }
    
    private func constructCell(from array : [DrawingObject], cell : GalleryViewCell) {
        let index = array.count - 1
        
        if let image = array[index]._image {
            if let uiimage = galleryManager.convertByteArrayToUIImage(stringImage: array[index]._image!) {
                cell.imageView.image = uiimage
            }
            else {
                cell.imageView.image = UIImage(named: "6")
            }
        }
        else {
            cell.imageView.image = UIImage(named: "7")
        }
        
        
        // password
        if let password = array[index]._password, password != "" {
            cell.protection.image = UIImage(named : "lock")
            cell.protection.tintColor = #colorLiteral(red: 1, green: 0.374024868, blue: 0.3451677859, alpha: 1)
        }
        else {
            cell.protection.image = UIImage(named : "unlock")
            cell.protection.tintColor = #colorLiteral(red: 0.1571377814, green: 0.7910693288, blue: 0.2539199889, alpha: 1)
        }
        
        
        // the rest
        cell.title.text = array[index]._title
        cell.layer.borderColor = #colorLiteral(red: 0.658308804, green: 0.8193534017, blue: 0.9075077176, alpha: 1)
        cell.layer.borderWidth = 2
        cell.layer.cornerRadius = 8
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("tapped")
        print(indexPath)
        
        if collectionView == self.collectionView {
            selectedDrawing = drawings[indexPath[1]]
            let cell = self.collectionView.cellForItem(at: indexPath) as! GalleryViewCell
            if cell.protection.tintColor == #colorLiteral(red: 1, green: 0.374024868, blue: 0.3451677859, alpha: 1) {
                performSegue(withIdentifier: "passwordPopup", sender: nil)
            }
            else {
                galleryManager.joinDrawingSession(drawingId: selectedDrawing!._id, joiningUser: networkManager.username)
                galleryManager.sendFetchStrokesWithDrawingIdMessage(drawingId: selectedDrawing!._id)
            }
        }
        else {
            selectedDrawing = privateDrawings[indexPath[1]]
            print("go to my drawing")
            galleryManager.joinDrawingSession(drawingId: selectedDrawing!._id, joiningUser: networkManager.username)
            galleryManager.sendFetchStrokesWithDrawingIdMessage(drawingId: selectedDrawing!._id)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PasswordPopupViewController {
            destination.expectedPassword = selectedDrawing?._password!
        }
        else if let destination = segue.destination as? DrawingPageViewController {
            destination.drawingMode = selectedDrawing!._mode ? Mode.Pixel : Mode.Line
            destination.drawingManager.drawingId = selectedDrawing!._id
            
            destination.setting.needsSetting = false
            destination.setting.title = selectedDrawing!._title
            destination.setting.visibility = selectedDrawing!._visibility
            destination.setting.drawingMode = selectedDrawing!._mode 
            
            if let password = selectedDrawing?._password {
                destination.setting.password = password
                destination.setting.protected = true
            }
            else {
                destination.setting.protected = false
            }
            
        }
    }
}
















