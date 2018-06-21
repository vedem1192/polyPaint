//
//  crvcTextFieldExtension.swift
//  clientLegerSwift
//
//  Created by veronique demers on 18-02-02.
//  Copyright © 2018 log3900. All rights reserved.
//

import UIKit

extension ChatRoomViewController : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let characterCountLimit = 500

        let startingLength = textField.text?.count ?? 0
        let lengthToAdd = string.count
        let lengthToReplace = range.length

        let newLength = startingLength + lengthToAdd - lengthToReplace    
        return newLength <= characterCountLimit
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        // Perform an animation to grow the dockView
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.25, animations: {
            
            self.dockViewHeightConstraint.constant = 390
            self.view.layoutIfNeeded()
            
        }, completion: nil)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        // Perform an animation to grow the dockView
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.25, animations: {
            
            self.dockViewHeightConstraint.constant = 80
            self.view.layoutIfNeeded()
            
        }, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendMessage()
        return true
    }
}
