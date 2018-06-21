//
//  PasswordPopupViewController.swift
//  clientLegerSwift
//
//  Created by veronique demers on 18-04-11.
//  Copyright © 2018 log3900. All rights reserved.
//

import UIKit

class PasswordPopupViewController: UIViewController {
    
    @IBOutlet weak var mainView: RoundView!
    @IBOutlet weak var passwordField: UITextField!
    var presentingVC : GalleryPageViewController!
    var expectedPassword : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presentingVC = presentingViewController as! GalleryPageViewController

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func confirmWasPressed(_ sender: Any) {
        if (passwordField.text?.isEmpty)! || passwordField.text != expectedPassword {
            shake()
            passwordField.layer.borderColor = #colorLiteral(red: 1, green: 0.374024868, blue: 0.3451677859, alpha: 1)
            passwordField.layer.borderWidth = 2
            passwordField.layer.cornerRadius = 8
            passwordField.text = ""
            passwordField.attributedPlaceholder = NSAttributedString(string: "Invalid password", attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 1, green: 0.374024868, blue: 0.3451677859, alpha: 1)])
        }
        else {
            print("Go to dessin")
            let drawingId = presentingVC.selectedDrawing?._id
            let username = presentingVC.networkManager.username
            presentingVC.galleryManager.joinDrawingSession(drawingId: drawingId!, joiningUser: username)
            presentingVC.galleryManager.sendFetchStrokesWithDrawingIdMessage(drawingId: (presentingVC.selectedDrawing?._id)!)
            dismiss(animated: true, completion: nil)
        }
    }
    
    private func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        mainView.layer.add(animation, forKey: "shake")
    }
    

}
