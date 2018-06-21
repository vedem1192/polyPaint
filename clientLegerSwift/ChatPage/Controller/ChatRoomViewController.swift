//
//  ChatRoomViewController.swift
//  clientLegerSwift
//
//  Created by veronique demers on 18-01-30.
//  Copyright © 2018 log3900. All rights reserved.
//

import UIKit

class ChatRoomViewController: UIViewController {
    
    let notificationCenter = NotificationCenter.default
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var dockViewHeightConstraint: NSLayoutConstraint!
    
    let networkManager = NetworkManager.instance
    var chatManager = ChatManager.chatInstance
    var loginManager = LoginManager.loginInstance
    var chatMessages = [ChatroomMessage]()
    var username: String!
    
    //- - - - - - - - - - - - - - - - - -//
    
    // happens only once
    override func viewDidLoad() {
        super.viewDidLoad()
        networkManager.chatDelegate = self
        setDelegates()
        addGestureRecognizer()
        setInitialUI()
        loadMessageFromDictionnary()

        notificationCenter.addObserver(self, selector: #selector(appIsGoingToBackgroundState),
                                       name: Notification.Name.UIApplicationWillResignActive,
                                       object: nil)
    }
    
    private func setDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
        messageTextField.delegate = self
    }
    
    private func addGestureRecognizer() {
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        tableView.addGestureRecognizer(tapGesture)
        tableView.separatorStyle = .none
    }
    
    private func setInitialUI() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80
    }
    
    @objc func tableViewTapped() {
        messageTextField.endEditing(true)
    }
    
    @objc func appIsGoingToBackgroundState() {
        print("App is going to background state!")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @IBAction func sendButtonTapped(_ sender: UIButton) {
        sendMessage()
    }
    
    func loadMessageFromDictionnary() {
        fillDictionnaryWithMissedMessages()
        let messages: [ChatroomMessage] = chatManager.chatrooms[chatManager.chatroomName!]!
        for message in messages {
            insertNewMessageCell(message)
        }
        // Should I?
        chatManager.chatrooms[chatManager.chatroomName!]!.removeAll()
    }
    
    func fillDictionnaryWithMissedMessages() {
        for message in networkManager.missedMessagesChat {
            chatManager.processChatroomMessageToDictionnary(message: message)
        }
        networkManager.missedMessagesChat.removeAll()
    }
    
    func sendMessage() {
        let message = messageTextField.text!
        let trimmedMessage = message.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if !trimmedMessage.isEmpty{
            //Chatroom to take into account
            chatManager.sendChatMessage(username: username, message: trimmedMessage, chatroom: chatManager.chatroomName)
            self.messageTextField.text = ""
        }
        else {
            self.messageTextField.text = ""
        }
    }
    
    @IBAction func leaveChatroomWasPressed(_ sender: Any) {
        chatManager.chatroomName = nil
        performSegue(withIdentifier: "backSegue", sender: nil)
    }
    
}

extension ChatRoomViewController : NetworkManagerDelegate {
    func receivedMessage(message: Message) {
        print("Chat delegate notified!")
        // chatManager.processCreateChatroomMessage(message: message)
        if let msg = chatManager.processChatroomMessage(message: message) {
            if (chatManager.chatroomName == msg._chatroomName) {
                insertNewMessageCell(msg)
            }
        }
    }
}
