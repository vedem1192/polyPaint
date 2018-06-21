//
//  GalleryManager.swift
//  clientLegerSwift
//
//  Created by lea el hage on 2018-04-06.
//  Copyright © 2018 log3900. All rights reserved.
//

import Foundation

class GalleryManager: NetworkManager {
    
    static let galleryInstance = GalleryManager()
    var networkManager = NetworkManager.instance
    
    func getAllDrawings() {
        let encodedMessage = networkManager.encodeMessage(messageType: MessageType.GalleryMessage, subMessageType: SubMessageType.FetchPublicGalleryImagesMessage, content: String(networkManager.username))
        networkManager.sendMessage(encodedData: encodedMessage!)
    }
    
    func getPrivateDrawings() {
        let encodedMessage = networkManager.encodeMessage(messageType: MessageType.GalleryMessage, subMessageType: SubMessageType.FetchUserGalleryImagesMessage, content: String(networkManager.username))
        networkManager.sendMessage(encodedData: encodedMessage!)
    }
    
    func sendFetchStrokesWithDrawingIdMessage(drawingId: Int) {
        let fetchStrokesWithDrawingIdMessage = FetchStrokesWithDrawingIdMessage(drawingId: drawingId)
        let encodedData = try? JSONEncoder().encode(fetchStrokesWithDrawingIdMessage)
        let content = String(data: encodedData!, encoding: .utf8)!
        let encodedMessage = networkManager.encodeMessage(messageType: MessageType.DrawingMessage, subMessageType: SubMessageType.FetchStrokesWithDrawingIdMessage, content: content)
        networkManager.sendMessage(encodedData: encodedMessage!)
    }
    
    func joinDrawingSession(drawingId: Int, joiningUser: String) {
        let joinDrawingSessionMessage = JoinDrawingSessionMessage(drawingId: drawingId, joiningArtist: joiningUser)
        let encodedData = try? JSONEncoder().encode(joinDrawingSessionMessage)
        let content = String(data: encodedData!, encoding: .utf8)!
        let encodedMessage = networkManager.encodeMessage(messageType: MessageType.DrawingMessage, subMessageType: SubMessageType.JoinDrawingSessionMessage, content: content)
        networkManager.sendMessage(encodedData: encodedMessage!)
    }
    
    // HELP SIMON
    func processDrawingSessionMessage(message: Message) -> Bool? {
        if (message._type == .DrawingMessage) {
            if(message._subtype == .ConfirmDrawingSessionEntryMessage) {
                //ASK VERO
                return message._content.toBool()
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    func processPublicGalleryMessage(message: Message) -> DrawingObject? {
        if (message._type == .GalleryMessage) {
            if(message._subtype == .RetrievePublicGalleryImagesMessage) {
                let drawingObjectMessage = try? JSONDecoder().decode(DrawingObject.self, from: (message._content).data(using: .utf8)!)
                do {
                    _ = try JSONDecoder().decode(DrawingObject.self, from: (message._content).data(using: .utf8)!)
                    
                } catch let jsonErr {
                    print("Error decoding Json", jsonErr)
                }
                if let drawingObject = drawingObjectMessage {
                    print(drawingObject)
                    return drawingObject
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
    
    func processPrivateGalleryMessage(message: Message) -> DrawingObject? {
        if (message._type == .GalleryMessage) {
            if(message._subtype == .RetrieveUserGalleryImagesMessage) {
                let drawingObjectMessage = try? JSONDecoder().decode(DrawingObject.self, from: (message._content).data(using: .utf8)!)
                do {
                    _ = try JSONDecoder().decode(DrawingObject.self, from: (message._content).data(using: .utf8)!)
                    
                } catch let jsonErr {
                    print("Error decoding Json", jsonErr)
                }
                if let drawingObject = drawingObjectMessage {
                    print(drawingObject)
                    return drawingObject
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

}
