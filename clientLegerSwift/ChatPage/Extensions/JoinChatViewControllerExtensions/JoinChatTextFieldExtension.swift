//
//  TextFieldExtension.swift
//  clientLegerSwift
//
//  Created by veronique demers on 18-02-07.
//  Copyright © 2018 log3900. All rights reserved.
//

import UIKit



extension JoinChatViewController : UITextFieldDelegate {
   
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let characterCountLimit = 20
        
        let startingLength = textField.text?.count ?? 0
        let lengthToAdd = string.count
        let lengthToReplace = range.length
        
        let newLength = startingLength + lengthToAdd - lengthToReplace
        if newLength > characterCountLimit {
            textField.textColor = .red
            warningMessage.text = "Exceeding expected length"
        }
        else {
            textField.textColor = .black
            warningMessage.text = ""
        }

        return newLength <= characterCountLimit
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == serverIP {
            if (serverIP.text?.isValidIP())!{
                connectClientToServer()
                warningMessage.text = ""
            }
            else {
                warningMessage.text = "Invalid IP address"
            }
        }
        else {
            verifyLoginData()
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        warningMessage.text = ""
    }
    
}
