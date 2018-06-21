//
//  LoginManager.swift
//  clientLegerSwift
//
//  Created by Simon Barrette on 18-03-16.
//  Copyright © 2018 log3900. All rights reserved.
//

import Foundation
import UIKit
class LoginManager: NetworkManager {
    
    static let loginInstance = LoginManager()
    var networkManager = NetworkManager.instance
    
    
    func authenticate(username: String, password: String) {
        let authenticateMessage = AuthenticateMessage(username: username, password: password, confirmed: false)
        let encodedData = try? JSONEncoder().encode(authenticateMessage)
        let content = String(data: encodedData!, encoding: .utf8)!
        let encodedMessage = networkManager.encodeMessage(messageType: MessageType.LoginMessage, subMessageType: SubMessageType.AuthenticateMessage, content: content)
        networkManager.sendMessage(encodedData: encodedMessage!)
    }
    
    func quitApp() {
        let quitAppMessage = QuitAppMessage()
        let encodedData = try? JSONEncoder().encode(quitAppMessage)
        let content = String(data: encodedData!, encoding: .utf8)!
        let encodedMessage = networkManager.encodeMessage(messageType: MessageType.LoginMessage, subMessageType: SubMessageType.QuitAppMessage, content: content)
        networkManager.sendMessage(encodedData: encodedMessage!)
    }

    func processAuthenticateMessage(message: Message) -> AuthenticateMessage? {
        if (message._type == .LoginMessage) {
            if(message._subtype == .AuthenticateMessage) {
                let authMessage = try? JSONDecoder().decode(AuthenticateMessage.self, from: (message._content).data(using: .utf8)!)
                if let authMsg = authMessage {
                    print(authMsg)
                        return authMsg
                } else {
                    return nil
                }
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    func processQuitAppMessageMessage(message: Message) -> QuitAppMessage? {
        
        let quitAppMessage = try? JSONDecoder().decode(QuitAppMessage.self, from: (message._content).data(using: .utf8)!)
        if let quitAppMsg = quitAppMessage {
            return quitAppMsg
        } else {
            return nil
        }
    }
}
