//
//  ChatRoomViewController.swift
//  clientLegerSwift
//
//  Created by Simon Barrette on 18-02-21.
//  Copyright © 2018 log3900. All rights reserved.
//

import Foundation
import UIKit

class RoomViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var mainMenuView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    let chatManager = ChatManager.chatInstance
    let networkManager = NetworkManager.instance
    
    let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
    var imageName = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18"]

    override func viewDidLoad() {
        super.viewDidLoad()
        networkManager.chatDelegate = self
        
        // Do any additional setup after loading the view.
        mainMenuView.layer.zPosition = 2
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        for message in networkManager.missedMessagesChatroom {
            if let name = chatManager.processCreateChatroomMessage(message: message) {
                addChatroom(named: name)
            }
        }
        networkManager.missedMessagesChatroom.removeAll()
    }

    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chatManager.chatrooms.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! RoomViewCell
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        cell.myLabel.text = chatManager.chatroomNames[indexPath.item]
        cell.roomImage.image = UIImage(named: imageName[(indexPath.item)%18])
        cell.backgroundColor = #colorLiteral(red: 0.658308804, green: 0.8193534017, blue: 0.9075077176, alpha: 1)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        let chatroom = chatManager.chatroomNames[indexPath[1]]
        chatManager.chatroomName = chatroom
        if chatroom != "General" {
            print("Joined chat \(chatroom)")
            chatManager.joinChat(username: networkManager.username, chatroom: chatManager.chatroomName)
        }
        performSegue(withIdentifier: "openChatroom", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ChatRoomViewController {
            destination.username = networkManager.username
        }
    }
    
    @IBAction func logoutWasPressed(_ sender: Any) {
        // ASK SIMON
        let loginManager = LoginManager()
        loginManager.quitApp()
        loginManager.networkManager.stopChatSession()
        chatManager.cleanManagerLogout()
        collectionView.reloadData()
        performSegue(withIdentifier: "logoutFromChatrooms", sender: nil)
    }
    
    
    @IBAction func addChatroomWasPressed(_ sender: RoundButton) {
        performSegue(withIdentifier: "createChatroom", sender: nil)
    }
    
    func addChatroom(named name : String) {
        chatManager.chatroomNames.append(name)
        chatManager.chatrooms[name] = []
        let index = chatManager.chatrooms.count - 1
        let indexPath = IndexPath(row:index, section: 0)
        
        self.collectionView.insertItems(at: [indexPath])
        self.collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
        
        chatManager.createChat(chatroom : name)
    }
}

extension RoomViewController : NetworkManagerDelegate {
    
    func receivedMessage(message: Message) {
        print("Chatroom delegate notified!")
        chatManager.processChatroomMessageToDictionnary(message: message)
        if let name = chatManager.processCreateChatroomMessage(message: message) {
            addChatroom(named: name)
        }
    }
}
