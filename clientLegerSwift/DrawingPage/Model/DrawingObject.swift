//
//  Drawing.swift
//  clientLegerSwift
//
//  Created by Simon Barrette on 18-03-18.
//  Copyright © 2018 log3900. All rights reserved.
//

import Foundation

struct DrawingObject: Codable {
    
    var _id: Int!
    var _creator: String!
    var _title: String
    var _image: String?
    var _visibility: Bool
    var _password: String?
    var _mode: Bool!
    
    init(creator: String, title: String, visibility: Bool, password: String?) {
        self._creator = creator
        self._title = title
        self._visibility = visibility
        self._mode = false
        if let psw = password {
            self._password = password
        }
        else {
            self._password = nil
        }
    }
    
    init(creator: String, title: String, visibility: Bool, password: String?, drawingMode: Bool) {
        self._creator = creator
        self._title = title
        self._visibility = visibility
        self._mode = drawingMode
        if let psw = password {
            self._password = password
        }
        else {
            self._password = nil
        }
    }
    
    init(image: String?, title: String, visibility: Bool, password: String?, id: Int) {
        // CHECK WITH SIMON
        if let img = image {
            self._image = img
        }
        else {
            self._image = nil
        }
        
        if let psw = password {
            self._password = password
        }
        else {
            self._password = nil
        }
        
        self._title = title
        self._visibility = visibility
        self._mode = false
        self._id = id
    }
    
    init(image: String?, title: String, visibility: Bool, password: String?, id: Int, drawingMode: Bool) {
        // CHECK WITH SIMON
        if let img = image {
            self._image = img
        }
        else {
            self._image = nil
        }
        
        if let psw = password {
            self._password = password
        }
        else {
            self._password = nil
        }
        
        self._title = title
        self._visibility = visibility
        self._mode = false
        self._id = id
        self._mode = drawingMode
    }
}

struct AuthorityList {
    var _strokeId: String
    var _username: String
}
