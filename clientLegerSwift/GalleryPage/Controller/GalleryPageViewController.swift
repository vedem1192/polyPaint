//
//  GalleryPageViewController.swift
//  clientLegerSwift
//
//  Created by veronique demers on 18-02-19.
//  Copyright © 2018 log3900. All rights reserved.
//

import UIKit

class GalleryPageViewController:  UIViewController {
    
    let networkManager = NetworkManager.instance
    let galleryManager = GalleryManager.galleryInstance
    
    @IBOutlet  var collectionView: UICollectionView!
    @IBOutlet weak var privateCollectionView: UICollectionView!
    
    var drawings : [DrawingObject] = []
    var privateDrawings : [DrawingObject] = []
    var privateDrawingWereFetched = false
    var selectedDrawing : DrawingObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkManager.galleryDelegate = self
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isUserInteractionEnabled = true
        
        privateCollectionView.delegate = self
        privateCollectionView.dataSource = self
        privateCollectionView.isUserInteractionEnabled = false
        privateCollectionView.alpha = 0
        
        getAllPublicDrawing()
    }
    
    func getAllPublicDrawing(){
        galleryManager.getAllDrawings()
        
    }
    
    func getAllPrivateDrawing(){
        galleryManager.getPrivateDrawings()
    }
    
    @IBAction func galleryPrivacyChanged(_ sender: UISegmentedControl) {
        // private drawings
        if sender.selectedSegmentIndex == 1 {
            collectionView.isUserInteractionEnabled = false
            collectionView.alpha = 0
            
            privateCollectionView.isUserInteractionEnabled = true
            privateCollectionView.alpha = 1
            
            if !privateDrawingWereFetched {
                privateDrawingWereFetched = true
                getAllPrivateDrawing()
            }
        }
        // public drawings
        else {
            privateCollectionView.isUserInteractionEnabled = false
            privateCollectionView.alpha = 0
            
            collectionView.isUserInteractionEnabled = true
            collectionView.alpha = 1
        }
    }
    
    // pas sure...
    func goToDrawingPage() {
        performSegue(withIdentifier: "galleryToDrawing", sender: nil)
    }
    
    func insertGalleryCell() {
        let indexPath = IndexPath(item: (self.drawings.count-1), section: 0)
        self.collectionView.insertItems(at: [indexPath])
    }
    
    func insertPrivateGalleryCell() {
        let indexPath = IndexPath(item: (self.privateDrawings.count-1), section: 0)
        self.privateCollectionView.insertItems(at: [indexPath])
    }
    
    func tooManyUsersPopup() {
        let alert = UIAlertController(title: "Oups!", message: "This drawing session is full at the moment", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Awwhh..", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    @IBAction func logoutWasPressed(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.quitApp()
        networkManager.stopChatSession()
        performSegue(withIdentifier: "logoutFromGallery", sender: nil)
    }
    
}

extension GalleryPageViewController : NetworkManagerDelegate {
    func receivedMessage(message: Message) {
        print("Got gallery delegate message")
        if let msg = galleryManager.processPublicGalleryMessage(message: message){
            self.drawings.append(msg)
            insertGalleryCell()
        }
        if let msg = galleryManager.processPrivateGalleryMessage(message: message){
            self.privateDrawings.append(msg)
            insertPrivateGalleryCell()
        }
        // HELP SIMON
        if let msg = galleryManager.processDrawingSessionMessage(message : message) {
            if msg {
                self.goToDrawingPage()
            }
            else {
                self.tooManyUsersPopup()
            }
        }
    }
}


