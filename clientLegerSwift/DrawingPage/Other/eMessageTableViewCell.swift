//
//  MessageTableViewCell.swift
//  clientLegerSwift
//
//  Created by veronique demers on 18-02-01.
//  Copyright © 2018 log3900. All rights reserved.
//

import UIKit

class eMessageTableViewCell : UITableViewCell {
    var messageSender: MessageSender = .ourself
    let messageLabel = UILabel()
    let nameLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        messageLabel.clipsToBounds = true
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0

        nameLabel.textColor = .lightGray
        nameLabel.font = UIFont(name: "Helvetica", size:10)

        clipsToBounds = true
        self.addSubview(messageLabel)
        self.addSubview(nameLabel)
    }
    
    func apply(message: Message) {
        nameLabel.text = message._username
        messageLabel.text = message._message
        messageSender = message._messageSender!
        setNeedsLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

