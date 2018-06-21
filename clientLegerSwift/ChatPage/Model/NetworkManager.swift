//
//  ChatRoom.swift
//  DogeChat
//
//  Created by veronique demers on 18-01-17.
//  Copyright © 2018 Luke Parham. All rights reserved.
//

protocol NetworkManagerDelegate: class {
    func receivedMessage(message: Message)
}


import UIKit
class NetworkManager: NSObject {
    
    let maxReadLength = 4096
    var ip = ""
    
    var inputStream: InputStream!
    var outputStream: OutputStream!
    
    var username = ""
    weak var delegate: NetworkManagerDelegate?
    
    
    /* * * * * * * * * * * * * */
    /*  Function definitions   */
    /* * * * * * * * * * * * * */
    func setupNetworkCommunication() {
        var readStream: Unmanaged<CFReadStream>?
        var writeStream: Unmanaged<CFWriteStream>?

        // TODO: Change the hostname for the IP address of the server we'll be using
        CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault,
                                           ip as CFString, 5006,
                                           &readStream, &writeStream) // Steph: 10.200.26.152

        inputStream = readStream!.takeRetainedValue()
        outputStream = writeStream!.takeRetainedValue()

        inputStream.delegate = self

        inputStream.schedule(in: .current, forMode: .commonModes)
        outputStream.schedule(in: .current, forMode: .commonModes)

        inputStream.open()
        outputStream.open()
    }
    
    func joinChat(username: String) {
        let authMessage = AuthMessage(_type: "AUTHENTICATE", _username: username, _confirmed: false, _timeStamp: "")

        let encodedData = try? JSONEncoder().encode(authMessage)
        //let msgToSend = String(data: encodedData!, encoding: .utf8)?.data(using: .ascii)
        let msgToSend = String(data: encodedData!, encoding: .utf8)?.data(using: .utf8)
       
        _ = msgToSend?.withUnsafeBytes { outputStream.write($0, maxLength: (msgToSend?.count)!)}
        
    }

    func sendMessage(username: String, userMessage: String) {
        let message = Message(type: "ONBROADCASTCHATMESSAGE", message: userMessage, username: username, messageSender: .ourself, confirmed: nil,  timeStamp: "")
        
        let encodedData = try? JSONEncoder().encode(message)
        let msgToSend = String(data: encodedData!, encoding: .utf8)?.data(using: .utf8)
        
        _ = msgToSend?.withUnsafeBytes { outputStream.write($0, maxLength: (msgToSend?.count)!)}
    }
    
    func disconnectFromChat(username: String, userMessage: String) {
        let message = Message(type: "ONQUIT", message: userMessage, username: username, messageSender: .ourself, confirmed: nil,  timeStamp: "")
        
        let encodedData = try? JSONEncoder().encode(message)
        let msgToSend = String(data: encodedData!, encoding: .utf8)?.data(using: .utf8)
        
        _ = msgToSend?.withUnsafeBytes { outputStream.write($0, maxLength: (msgToSend?.count)!)}
    }
    
    func stopChatSession() {
        inputStream.close()
        outputStream.close()
    }
}

extension NetworkManager : StreamDelegate {
    
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        switch eventCode {
        case Stream.Event.hasBytesAvailable:
            print("new message received")
            readAvailableBytes(stream: aStream as! InputStream)
        case Stream.Event.endEncountered:
            stopChatSession()
            print("Session ended")
        case Stream.Event.errorOccurred:
            print("error occurred")
        case Stream.Event.hasSpaceAvailable:
            print("has space available")
        default:
            print("some other event...")
            break
        }
    }
    
    private func readAvailableBytes(stream: InputStream) {

        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: maxReadLength)
        while stream.hasBytesAvailable {
            let numberOfBytesRead = inputStream.read(buffer, maxLength: maxReadLength)

            if numberOfBytesRead < 0 {
                if let _ = stream.streamError {
                    break
                }
            }
            
            if let message = processedMessageString(buffer: buffer, length: numberOfBytesRead){
                // Notify people!
                delegate?.receivedMessage(message: message)
            }
        }
    }
    
    private func processedMessageString(buffer: UnsafeMutablePointer<UInt8>, length: Int) -> Message? {
        guard let stringArray = String(bytesNoCopy: buffer, length: length, encoding: .utf8, freeWhenDone: true)
            else {
                return nil
        }
        
        let data = stringArray.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        
        let authMessage = try? JSONDecoder().decode(AuthMessage.self, from: data)
        if let authMsg = authMessage {
            if authMsg._type == "AUTHENTICATE"{
                return Message(type: authMsg._type, message: "\(authMsg._username) has join", username: authMsg._username, messageSender: .someoneElse, confirmed: authMsg._confirmed,  timeStamp: authMsg._timeStamp)
            }
        } else {
            let chatMessage = try? JSONDecoder().decode(Message.self, from: data)
            if let chatMsg = chatMessage {
                if chatMsg._type == "ONBROADCASTCHATMESSAGE" {
                    let sender = chatMsg._username == username ? MessageSender.ourself : MessageSender.someoneElse
                    return Message(type: chatMsg._type, message: chatMsg._message, username: chatMsg._username, messageSender: sender, confirmed: nil, timeStamp: chatMsg._timeStamp)
                }
            } else {
                let onJoinMessage = try? JSONDecoder().decode(JoinChatMessage.self, from: data)
                if let onJoinMsg = onJoinMessage {
                    if onJoinMsg._type == "ONJOINCHAT" {
                        return Message(type: onJoinMsg._type, message: "\(onJoinMsg._newUser) has joined", username: onJoinMsg._newUser, messageSender: .someoneElse, confirmed: nil, timeStamp: onJoinMsg._timeStamp)
                    }
                }
            }
        }
        return nil
    }
}


