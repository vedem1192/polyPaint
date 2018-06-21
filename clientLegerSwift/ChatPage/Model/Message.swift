//
//  Message.swift
//  clientLegerSwift
//
//  Created by veronique demers on 18-01-31.
//  Copyright © 2018 log3900. All rights reserved.
//

import Foundation

struct Message: Codable {
    
    var _type: String?
    var _username: String
    var _message: String
    var _timeStamp: String
    var _messageSender: MessageSender?
    var _confirmed:Bool?
    
    private enum CodingKeys: String, CodingKey {
        case _type
        case _username
        case _message
        case _timeStamp
        
    }
    
    init(type: String?, message: String, username: String, messageSender: MessageSender, confirmed:Bool?, timeStamp: String) {
        self._type = type
        self._username = username
        self._message = message.withoutWhitespace()
        self._messageSender = messageSender
        self._confirmed = confirmed
        self._timeStamp = timeStamp
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _type = try values.decode(String.self, forKey: ._type)
        _username = try values.decode(String.self, forKey: ._username)
        _message = try values.decode(String.self, forKey: ._message)
        _timeStamp = try values.decode(String.self, forKey: ._timeStamp)
    }
}

struct AuthMessage: Codable {
    var _type: String
    var _username: String
    var _confirmed: Bool
    var _timeStamp: String
}

struct JoinChatMessage: Codable {
    var _type: String
    var _newUser: String
    var _timeStamp: String
}

