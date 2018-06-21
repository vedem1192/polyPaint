//
//  Message.swift
//  clientLegerSwift
//
//  Created by veronique demers on 18-01-31.
//  Copyright © 2018 log3900. All rights reserved.
//

import Foundation

struct JoinChatMessage: Codable {
    
    var _username: String
    var _chatroomName: String
    var _timeStamp: String
    
    init(username: String, chatroomName: String) {
        self._username = username
        self._chatroomName = chatroomName
        self._timeStamp = ""
    }
}
// See if it works not to assign timeStamp on decode
struct BroadcastChatMessage: Codable {
    var _username: String
    var _message: String
    var _chatroomName: String
    var _timeStamp: String?
    
    init(username: String, message: String, chatroomName: String) {
        self._username = username
        self._message = message.withoutWhitespace()
        self._chatroomName = chatroomName
    }
}

struct ChatroomMessage: Codable {
    var _username: String
    var _message: String?
    var _chatroomName: String
    var _timeStamp: String?
    var _type: String?
    
    init(username: String, message: String, chatroomName: String) {
        self._username = username
        self._message = message.withoutWhitespace()
        self._chatroomName = chatroomName
    }
}
