//
//  ChatManager.swift
//  clientLegerSwift
//
//  Created by Simon Barrette on 18-03-14.
//  Copyright © 2018 Luke Parham & log3900. All rights reserved.
//

import UIKit
class ChatManager: NetworkManager {
    
    static let chatInstance = ChatManager()
    var networkManager = NetworkManager.instance
    var chatroomName : String!
    var chatrooms: [String:[ChatroomMessage]] = ["General":[]]
    var chatroomNames: [String] = ["General"]
    
    func cleanManagerLogout() {
        self.delegate = nil
        self.chatroomNames.removeAll()
        self.chatrooms.removeAll()
        
        // ICI
        self.chatrooms = ["General":[]]
        self.chatroomNames = ["General"]
    }
    
    func createChat(chatroom: String) {
        let encodedMessage = networkManager.encodeMessage(messageType: MessageType.ChatMessage, subMessageType: SubMessageType.CreateChatroomMessage, content: chatroom)
        networkManager.sendMessage(encodedData: encodedMessage!)
    }
    
    func joinChat(username: String, chatroom: String) {
        let joinChatMessage = JoinChatMessage(username: username, chatroomName: chatroom)
        let encodedData = try? JSONEncoder().encode(joinChatMessage)
        let content = String(data: encodedData!, encoding: .utf8)!
        let encodedMessage = networkManager.encodeMessage(messageType: MessageType.ChatMessage, subMessageType: SubMessageType.JoinChatMessage, content: content)
        networkManager.sendMessage(encodedData: encodedMessage!)
    }

    func sendChatMessage(username: String, message: String, chatroom: String) {
        let broadcastChatMessage = BroadcastChatMessage(username: username, message: message, chatroomName: chatroom)
        let encodedData = try? JSONEncoder().encode(broadcastChatMessage)
        let content = String(data: encodedData!, encoding: .utf8)!
        let encodedMessage = networkManager.encodeMessage(messageType: MessageType.ChatMessage, subMessageType: SubMessageType.BroadcastChatMessage, content: content)
        networkManager.sendMessage(encodedData: encodedMessage!)
    }

    func processChatroomMessage(message: Message) -> ChatroomMessage? {
        if (message._type == .ChatMessage) {
            if(message._subtype == .JoinChatMessage) {
                var chatMessage = try? JSONDecoder().decode(ChatroomMessage.self, from: (message._content).data(using: .utf8)!)
                chatMessage?._type = "JoinChatMessage"
                chatMessage?._message = ""
                if let chatMsg = chatMessage {
                    if (chatMsg._chatroomName != chatroomName) {
                        let messages: [ChatroomMessage] = (self.chatrooms[chatMsg._chatroomName])!
                        var isInDictionnary = false
                        for message in messages {
                            if (message._message == chatMsg._message && message._username == chatMsg._username && message._timeStamp == chatMsg._timeStamp && !isInDictionnary) {
                                isInDictionnary = true
                            }
                        }
                        if (!isInDictionnary) {
                            self.chatrooms[chatMsg._chatroomName]?.append(chatMsg)
                        }
                    }
                    return chatMsg
                } else {
                    return nil
                }
            } else if(message._subtype == .BroadcastChatMessage) {
                var chatMessage = try? JSONDecoder().decode(ChatroomMessage.self, from: (message._content).data(using: .utf8)!)
                chatMessage?._type = "BroadcastChatMessage"
                if let chatMsg = chatMessage {
                    if (chatMsg._chatroomName != chatroomName) {
                        
                        let messages: [ChatroomMessage] = (self.chatrooms[chatMsg._chatroomName])!
                        var isInDictionnary = false
                        for message in messages {
                            if (message._message == chatMsg._message && message._username == chatMsg._username && message._timeStamp == chatMsg._timeStamp && !isInDictionnary) {
                                isInDictionnary = true
                            }
                        }
                        if (!isInDictionnary) {
                            self.chatrooms[chatMsg._chatroomName]?.append(chatMsg)
                        }
                    }
                    return chatMsg
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
    
    func processChatroomMessageToDictionnary(message: Message) {
        if (message._type == .ChatMessage) {
            if(message._subtype == .JoinChatMessage) {
                var chatMessage = try? JSONDecoder().decode(ChatroomMessage.self, from: (message._content).data(using: .utf8)!)
                chatMessage?._type = "JoinChatMessage"
                chatMessage?._message = ""
                if let chatMsg = chatMessage {
                    let messages: [ChatroomMessage] = (self.chatrooms[chatMsg._chatroomName])!
                    var isInDictionnary = false
                    for message in messages {
                        if (message._message == chatMsg._message && message._username == chatMsg._username && message._timeStamp == chatMsg._timeStamp && !isInDictionnary) {
                            isInDictionnary = true
                        }
                    }
                    if (!isInDictionnary) {
                        self.chatrooms[chatMsg._chatroomName]?.append(chatMsg)
                    }
                }
            } else if(message._subtype == .BroadcastChatMessage) {
                var chatMessage = try? JSONDecoder().decode(ChatroomMessage.self, from: (message._content).data(using: .utf8)!)
                chatMessage?._type = "BroadcastChatMessage"
                if let chatMsg = chatMessage {
                    let messages: [ChatroomMessage] = (self.chatrooms[chatMsg._chatroomName])!
                    var isInDictionnary = false
                    for message in messages {
                        if (message._message == chatMsg._message && message._username == chatMsg._username && message._timeStamp == chatMsg._timeStamp && !isInDictionnary) {
                            isInDictionnary = true
                        }
                    }
                    if (!isInDictionnary) {
                        self.chatrooms[chatMsg._chatroomName]?.append(chatMsg)
                    }
                }
            }
        }
    }
    
    func processCreateChatroomMessage(message: Message) -> String? {
        print("Create Chatroom")
        var name : String?
        if (message._type == .ChatMessage) {
            if(message._subtype == .CreateChatroomMessage) {
                let newChatroomName = message._content
                name = newChatroomName
            }
        }
        return name
    } 
}


