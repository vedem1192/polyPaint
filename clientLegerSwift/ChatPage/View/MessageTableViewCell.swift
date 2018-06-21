//
//  MessageTableViewCell.swift
//  clientLegerSwift
//
//  Created by veronique demers on 18-02-03.
//  Copyright © 2018 log3900. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    
    // login
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var userConnectedLabel: UILabel!
    
    // my message
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var myMessageLabel: UILabel!
    @IBOutlet weak var myTimestampLabel: UILabel!
    @IBOutlet weak var myMessageBubbleView: UIView!
    
    // received message
    @IBOutlet weak var senderUsername: UILabel!
    @IBOutlet weak var receivedMessageBubbleView: UIView!
    @IBOutlet weak var receivedMessageLabel: UILabel!
    @IBOutlet weak var receivedMessageTimestamp: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    
    func apply(message: ChatroomMessage, identifier: String) {
        switch identifier {
        case "loginMessageCell" :
            loginLayout(message)
        case "myMessageCell":
            myMessage(message)
        case "messageCell":
            receiveMessage(message)
        default:
            return
        }
        
        setNeedsLayout()
    }
    
    private func setTimestampLabel(_ timestamp: UILabel, _ timeString: String) {
        timestamp.font = timestamp.font.withSize(12)
        timestamp.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        timestamp.text = timeString
    }
    
    private func setMessageView(_ bubble: UIView, _ messagelabel: UILabel, _ message: String){
        bubble.layer.cornerRadius = 10
        bubble.layer.masksToBounds = true;
        
        messagelabel.text = message
    }
    
    private func setSender(_ label: UILabel, _ username: String) {
        label.text = username
        label.font = label.font.withSize(15)
        label.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
    }
    
    private func setUserHasJoined(_ label: UILabel, _ message : String) {
        //user has joined message has the same param as the sender label
        let joinMessage = message + " has joined"
        setSender(label, joinMessage)
    }
    
    
    
    private func loginLayout(_ message: ChatroomMessage){
        layoutIfNeeded()
        
        var timeStamp = ""
        if let time = message._timeStamp {
            timeStamp = time
        }
        setTimestampLabel(timestampLabel, timeStamp)
        setUserHasJoined(userConnectedLabel, message._username)
        
    }
    
    private func myMessage(_ message: ChatroomMessage){
        layoutIfNeeded()
        
        setTimestampLabel(myTimestampLabel, message._timeStamp!)
        setSender(usernameLabel, "")
        setMessageView(myMessageBubbleView, myMessageLabel, message._message!)
        
        myMessageLabel.textColor = .white
        
    }
    
    private func receiveMessage(_ message: ChatroomMessage){
        layoutIfNeeded()
        
        setTimestampLabel(receivedMessageTimestamp, message._timeStamp!)
        setSender(senderUsername, message._username)
        setMessageView(receivedMessageBubbleView, receivedMessageLabel, message._message!)
    }
}
