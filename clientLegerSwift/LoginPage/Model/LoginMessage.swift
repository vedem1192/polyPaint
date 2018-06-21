//
//  LoginMessage.swift
//  clientLegerSwift
//
//  Created by Simon Barrette on 18-03-14.
//  Copyright © 2018 log3900. All rights reserved.
//

import Foundation

struct AuthenticateMessage: Codable {
    var _username: String
    var _password: String
    var _confirmed: Bool
    
    init(username: String, password: String, confirmed: Bool) {
        self._username = username
        self._password = password
        self._confirmed = confirmed
    }
}

struct QuitAppMessage: Codable {
    
    init() {}
}
