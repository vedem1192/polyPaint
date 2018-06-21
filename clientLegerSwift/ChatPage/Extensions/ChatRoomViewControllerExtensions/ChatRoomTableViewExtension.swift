//
//  ChatRoomViewControllerExtension.swift
//  clientLegerSwift
//
//  Created by veronique demers on 18-02-01.
//  Copyright © 2018 log3900. All rights reserved.
//

import UIKit

extension ChatRoomViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = self.chatMessages[indexPath.row]
        let isLogin = isLoginRequest(message)
        var identifier: String!
        
        // Create a table cell
        if(message._username == self.username) {
            identifier = isLogin ? "loginMessageCell" : "myMessageCell"
        } else {
            identifier = isLogin ? "loginMessageCell" : "messageCell"
        }

        let cell = self.tableView.dequeueReusableCell(withIdentifier: identifier) as! MessageTableViewCell
        cell.apply(message: message, identifier: identifier)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatMessages.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func insertNewMessageCell(_ message: ChatroomMessage) {
        chatMessages.append(message)
        let indexPath = IndexPath(row: chatMessages.count - 1, section: 0)
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPath], with: .bottom)
        tableView.endUpdates()
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    private func isLoginRequest(_ msg: ChatroomMessage) -> Bool{
        if msg._type == "JoinChatMessage" {
            return true
        }
        return false
    }
}
