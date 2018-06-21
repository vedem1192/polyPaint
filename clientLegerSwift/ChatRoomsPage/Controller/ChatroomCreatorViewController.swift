//
//  ChatroomCreatorViewController.swift
//  clientLegerSwift
//
//  Created by veronique demers on 18-04-11.
//  Copyright © 2018 log3900. All rights reserved.
//

import UIKit

class ChatroomCreatorViewController: UIViewController {

    var presentingVC : RoomViewController!
    let chatManager = ChatManager.chatInstance
    
    @IBOutlet weak var mainView: RoundView!
    @IBOutlet weak var nameLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presentingVC = presentingViewController as! RoomViewController
    }
    
    @IBAction func confirmWasPressed(_ sender: Any) {
        if isNameUnique() {
            dismiss(animated: true, completion: nil)
            presentingVC.addChatroom(named: nameLabel.text!)
        }
        else {
            triggerError()
        }
    }
    
    @IBAction func cancelWasPressed(_ sender: RoundButton) {
        dismiss(animated: true, completion: nil)
    }
    
    private func isNameValid() -> Bool {
        if let name = nameLabel.text {
            let trimmedName = name.trimmingCharacters(in: .whitespaces)
            if !trimmedName.isEmpty {
                return true
            }
        }
        return false
    }
    
    private func isNameUnique() -> Bool {
        if chatManager.chatrooms.index(forKey: nameLabel.text!) != nil {
            return false
        }
        return true
    }
    
    private func triggerError() {
        shake()
        nameLabel.layer.borderColor = #colorLiteral(red: 1, green: 0.374024868, blue: 0.3451677859, alpha: 1)
        nameLabel.layer.borderWidth = 2
        nameLabel.layer.cornerRadius = 8
        nameLabel.text = ""
        nameLabel.attributedPlaceholder = NSAttributedString(string: "Room name already in use", attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 1, green: 0.374024868, blue: 0.3451677859, alpha: 1)])
    }
    
    private func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        mainView.layer.add(animation, forKey: "shake")
    }
    
}
