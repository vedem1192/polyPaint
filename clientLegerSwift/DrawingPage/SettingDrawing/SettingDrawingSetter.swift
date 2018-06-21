//
//  SettingDrawingSetter.swift
//  clientLegerSwift
//
//  Created by lea el hage on 2018-03-25.
//  Copyright © 2018 log3900. All rights reserved.
//

import Foundation

class SettingDrawingSetter {
    
    var needsSetting = true
    var drawingMode = true
    static let instance = SettingDrawingSetter()
    let username = NetworkManager.instance.username
    
    var password = ""
    var passConf = ""

    var visibility : Bool = true
    var protected : Bool = true
    var title : String = ""
    var type : Int = 0
    
    func passConfirmation() -> Bool {
        if password == passConf && password != nil && passConf != nil {
            return true
        }
        return false
    }
    
   
    func confirmSetting() -> Bool{
        var confirmed = false
        if !title.isEmpty {
            if protected == false {
                confirmed = true
            }
            else if protected && passConfirmation() {
                confirmed = true
            }
        }
        print(confirmed)
        return confirmed
    }
    
    func checkOwner() -> Bool {
        //verifies if allowed to change setting if owner
        //only changes public, protected , passwords
        return true
    }
    
    func createDrawing() {
        //add mode
        let drawing = DrawingObject(creator: username, title: title, visibility: visibility, password: password, drawingMode: drawingMode)
        drawingManager.saveAsNewDrawing(newDrawing: drawing)
    }
}
