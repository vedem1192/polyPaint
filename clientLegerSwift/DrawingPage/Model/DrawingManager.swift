//
//  DrawingManager.swift
//  clientLegerSwift
//
//  Created by Simon Barrette on 18-03-14.
//  Copyright © 2018 log3900. All rights reserved.
//

import Foundation
import AVFoundation

class DrawingManager: NetworkManager {
    
    
    static let drawingInstance = DrawingManager()
    var networkManager = NetworkManager.instance
    var drawingId: Int = 0
    var authorityIdList: Array<AuthorityList> = Array()
    
    
    func sendSaveStrokeInDbMessage(sendableLineObject: SendableLineObject) {
        let lineObjectMessage = LineObjectMessage(sendableLineObject: sendableLineObject)
        let saveStrokeInDbMessage = SaveStrokeInDbMessage(jsonStroke: lineObjectMessage)
        let encodedData = try? JSONEncoder().encode(saveStrokeInDbMessage)
        let content = String(data: encodedData!, encoding: .utf8)!
        let encodedMessage = networkManager.encodeMessage(messageType: MessageType.DrawingMessage, subMessageType: SubMessageType.SaveStrokeInDbMessage, content: content)
        networkManager.sendMessage(encodedData: encodedMessage!)
    }
    
    func sendReinitializeCanvasMessage() {
        let reinitialiseCanvasMessage = ReinitializeCanvasMessage()
        let encodedData = try? JSONEncoder().encode(reinitialiseCanvasMessage)
        let content = String(data: encodedData!, encoding: .utf8)!
        let encodedMessage = networkManager.encodeMessage(messageType: MessageType.DrawingMessage, subMessageType: SubMessageType.ReinitializeCanvasMessage, content: content)
        networkManager.sendMessage(encodedData: encodedMessage!)
    }
    
    func sendAuthorityRequestMessage(strokeIdList: Array<String>) {
        let authorityRequestMessage = AuthorityRequestMessage(strokeIDAuthority: strokeIdList, username: networkManager.username)
        let encodedData = try? JSONEncoder().encode(authorityRequestMessage)
        let content = String(data: encodedData!, encoding: .utf8)!
        let encodedMessage = networkManager.encodeMessage(messageType: MessageType.DrawingMessage, subMessageType: SubMessageType.AuthorityRequestMessage, content: content)
        networkManager.sendMessage(encodedData: encodedMessage!)
    }
    
    func sendStrokeMovedMessage(sendableLineObject: SendableLineObject) {
        let lineObjectMessage = StrokeMovedMessage(sendableLineObject: sendableLineObject)
        let encodedData = try? JSONEncoder().encode(lineObjectMessage)
        let content = String(data: encodedData!, encoding: .utf8)!
        let encodedMessage = networkManager.encodeMessage(messageType: MessageType.DrawingMessage, subMessageType: SubMessageType.StrokeMovedMessage, content: content)
        networkManager.sendMessage(encodedData: encodedMessage!)
    }
    
    func sendStrokeEraseByLineMessage(id:String) {
        let strokeEraseMessage = StrokeErasedByLineMessage(id: id)
        let encodedData = try? JSONEncoder().encode(strokeEraseMessage)
        let content = String(data: encodedData!, encoding: .utf8)!
        let encodedMessage = networkManager.encodeMessage(messageType: MessageType.DrawingMessage, subMessageType: SubMessageType.StrokeErasedByLineMessage, content: content)
        networkManager.sendMessage(encodedData: encodedMessage!)
    }
    
    func sendLineObject(sendableLineObject: SendableLineObject) {
        let lineObjectMessage = LineObjectMessage(sendableLineObject: sendableLineObject)
        let encodedData = try? JSONEncoder().encode(lineObjectMessage)
        let content = String(data: encodedData!, encoding: .utf8)!
        let encodedMessage = networkManager.encodeMessage(messageType: MessageType.DrawingMessage, subMessageType: SubMessageType.LineObjectMessage, content: content)
        networkManager.sendMessage(encodedData: encodedMessage!)
    }
    
    func saveDrawing(drawing: DrawingObject) {
        let encodedData = try? JSONEncoder().encode(drawing)
        let content = String(data: encodedData!, encoding: .utf8)!
        let encodedMessage = networkManager.encodeMessage(messageType: MessageType.DrawingMessage, subMessageType: SubMessageType.SaveDrawingMessage, content: content)
        networkManager.sendMessage(encodedData: encodedMessage!)
    }
    
    func saveAsNewDrawing(newDrawing: DrawingObject) {
        let encodedData = try? JSONEncoder().encode(newDrawing)
        let content = String(data: encodedData!, encoding: .utf8)!
        let encodedMessage = networkManager.encodeMessage(messageType: MessageType.DrawingMessage, subMessageType: SubMessageType.SaveAsDrawingMessage, content: content)
        networkManager.sendMessage(encodedData: encodedMessage!)
    }
    
    func leaveDrawingSession(leavingUser: String) {
        let leaveDrawingSessionMessage = LeaveDrawingSessionMessage(leavingArtist: leavingUser)
        let encodedData = try? JSONEncoder().encode(leaveDrawingSessionMessage)
        let content = String(data: encodedData!, encoding: .utf8)!
        let encodedMessage = networkManager.encodeMessage(messageType: MessageType.DrawingMessage, subMessageType: SubMessageType.LeaveDrawingSessionMessage, content: content)
        networkManager.sendMessage(encodedData: encodedMessage!)
    }
    
    func sendModifiedPixelMessage(modifiedPixelMessage: ModifiedPixelMessage) {
        let encodedData = try? JSONEncoder().encode(modifiedPixelMessage)
        let content = String(data: encodedData!, encoding: .utf8)!
        let encodedMessage = networkManager.encodeMessage(messageType: MessageType.DrawingMessage, subMessageType: SubMessageType.ModifiedPixelMessage, content: content)
        networkManager.sendMessage(encodedData: encodedMessage!)
    }
    
    func processLineObjectMessage(message: Message) -> LineObjectMessage? {
        if (message._type == .DrawingMessage) {
            if(message._subtype == .LineObjectMessage) {
                let lineObjectMessage = try? JSONDecoder().decode(LineObjectMessage.self, from: (message._content).data(using: .utf8)!)
                do {
                   _ = try JSONDecoder().decode(LineObjectMessage.self, from: (message._content).data(using: .utf8)!)
                    
                } catch let jsonErr {
                    print("Error decoding Json", jsonErr)
                }
                if let lineObjectMsg = lineObjectMessage {
                    if lineObjectMsg._drawingId == self.drawingId {
                        print(lineObjectMsg)
                        return lineObjectMsg
                    }
                    return nil
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
    
    func processModifiedPixelMessage(message: Message) -> ModifiedPixelMessage? {
        if (message._type == .DrawingMessage) {
            if(message._subtype == .ModifiedPixelMessage) {
                let modifiedPixelMessage = try? JSONDecoder().decode(ModifiedPixelMessage.self, from: (message._content).data(using: .utf8)!)
                do {
                    _ = try JSONDecoder().decode(ModifiedPixelMessage.self, from: (message._content).data(using: .utf8)!)
                    
                } catch let jsonErr {
                    print("Error decoding Json", jsonErr)
                }
                if let modifiedPixelMsg = modifiedPixelMessage {
                    print(modifiedPixelMsg)
                    return modifiedPixelMsg
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
    
    func processNewDrawingIdMessage(message: Message) {
        if (message._type == .DrawingMessage) {
            if(message._subtype == .NewDrawingIdMessage) {
                let drawingId = try? JSONDecoder().decode(NewDrawingIdMessage.self, from: (message._content).data(using: .utf8)!)
                do {
                    _ = try JSONDecoder().decode(NewDrawingIdMessage.self, from: (message._content).data(using: .utf8)!)
                    
                } catch let jsonErr {
                    print("Error decoding Json", jsonErr)
                }
                if let response = drawingId {
                    self.drawingId = response._drawingId
                }
            }
        }
    }
    
    func processStrokeEraseByLineMessage(message: Message) -> String? {
        if (message._type == .DrawingMessage) {
            if(message._subtype == .StrokeErasedByLineMessage) {
                let eraseID = try? JSONDecoder().decode(StrokeErasedByLineMessage.self, from: (message._content).data(using: .utf8)!)
                do {
                    _ = try JSONDecoder().decode(StrokeErasedByLineMessage.self, from: (message._content).data(using: .utf8)!)
                    
                } catch let jsonErr {
                    print("Error decoding Json", jsonErr)
                }
                if let response = eraseID {
                    print(response)
                    return response._Id
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
    
    func processReinitializeCanvasMessage(message: Message) -> Bool? {
        if (message._type == .DrawingMessage) {
            if(message._subtype == .ReinitializeCanvasMessage) {
                return true
            }
            return false
        }
        return false
    }
    
    func processStrokeMovedMessage(message: Message) -> StrokeMovedMessage? {
        if (message._type == .DrawingMessage) {
            if(message._subtype == .StrokeMovedMessage) {
                let strokeMovedMessage = try? JSONDecoder().decode(StrokeMovedMessage.self, from: (message._content).data(using: .utf8)!)
                do {
                    _ = try JSONDecoder().decode(StrokeMovedMessage.self, from: (message._content).data(using: .utf8)!)
                    
                } catch let jsonErr {
                    print("Error decoding Json", jsonErr)
                }
                if let strokeMovedMsg = strokeMovedMessage {
                    print(strokeMovedMsg)
                    return strokeMovedMsg
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
    
    func processAuthorityRequestMessage(message: Message) {
        if (message._type == .DrawingMessage) {
            if(message._subtype == .AuthorityRequestMessage) {
                let authorityMessage = try? JSONDecoder().decode(AuthorityRequestMessage.self, from: (message._content).data(using: .utf8)!)
                do {
                    _ = try JSONDecoder().decode(AuthorityRequestMessage.self, from: (message._content).data(using: .utf8)!)
                    
                } catch let jsonErr {
                    print("Error decoding Json", jsonErr)
                }
                if let authorityMsg = authorityMessage {
                    let tempDictionnary: Array<AuthorityList> = authorityIdList
                    let tempIndex = tempDictionnary.count - 1
                    for i in 0..<tempDictionnary.count {
                        if (authorityMsg._username == tempDictionnary[(tempIndex - i)]._username) {
                            authorityIdList.remove(at: (tempIndex - i))
                        }
                    }
                    if (!authorityMsg._strokeIdAuthority.isEmpty) {
                        for strokeId in authorityMsg._strokeIdAuthority {
                            let tempAuthorityObj = AuthorityList(_strokeId: strokeId, _username: authorityMsg._username)
                            self.authorityIdList.append(tempAuthorityObj)
                        }
                    }
                }
            }
        }
    }
    
}
