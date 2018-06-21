//
//  NetworkManager.swift
//  clientLegerSwift
//
//  Created by Simon Barrette on 18-03-14.
//  Copyright © 2018 Luke Parham & log3900. All rights reserved.
//

protocol NetworkManagerDelegate: class {
    func receivedMessage(message: Message)
}


import UIKit
class NetworkManager: NSObject {
    
    static let instance = NetworkManager()
    let maxReadLength = 32000
    var ip = ""
    
    var inputStream: InputStream!
    var outputStream: OutputStream!
    
    var username = ""
    weak var delegate: NetworkManagerDelegate?
    weak var loginDelegate: NetworkManagerDelegate?
    weak var galleryDelegate: NetworkManagerDelegate?
    weak var drawingDelegate: NetworkManagerDelegate?
    weak var chatDelegate: NetworkManagerDelegate?
    
    
    // VERO TEST CHATROOMS MESSAGES
    var missedMessagesChatroom : [Message] = []
    var missedMessagesChat: [Message] = []
    // VERO HANDLES NEW USER
    var isFirstConnection = false
    
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
    
    // For encoding
    func encodeMessage(message: Message) -> Data? {
        let encodedData = try? JSONEncoder().encode(message)
        return encodedData
    }
    
    func encodeMessage(messageType: MessageType, subMessageType: SubMessageType, content: String) -> Data? {
        let message = Message(type: messageType, subtype: subMessageType, content: content)
        let encodedData = try? JSONEncoder().encode(message)
        return encodedData
    }
    
    func sendMessage(encodedData: Data) {
        let msg = String(data: encodedData, encoding: .utf8)! + "ENDOFMESSAGE"
        let msgToSend = msg.data(using: .utf8)
        _ = msgToSend?.withUnsafeBytes { outputStream.write(UnsafePointer<UInt8>($0), maxLength: (msgToSend?.count)!)}
        print("sent message")
        print(msgToSend!)
    }
    
    func stopChatSession() {
        if let input = inputStream, let output = outputStream {
            print("closing")
            input.close()
            output.close()
            print("closed")
        }
    }
}

extension NetworkManager : StreamDelegate {
    
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        switch eventCode {
        case Stream.Event.hasBytesAvailable:
            print("new message received")
            readAvailableBytes(stream: aStream as! InputStream)
        case Stream.Event.endEncountered:
            //stopChatSession()
            print("Empty message received or end encoutered")
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
            
            processedMessageString(buffer: buffer, length: numberOfBytesRead)
        }
    }
    
    private func processedMessageString(buffer: UnsafeMutablePointer<UInt8>, length: Int) {
        print("Size of message: ", length)
        let stringArray = String(bytesNoCopy: buffer, length: length, encoding: .utf8, freeWhenDone: true)
        // DO IT
        let trimmedArray = stringArray?.replacingLastOccurrenceOfString("ENDOFMESSAGE", with: "")
        let dataArray = trimmedArray?.components(separatedBy: "ENDOFMESSAGE")
        for message in dataArray! {
            if (length != 0) {
                let data = message.data(using: String.Encoding.utf8, allowLossyConversion: false)!
                do {
                    let message = try JSONDecoder().decode(Message.self, from: data)
                    print(message)
                    print("Delegate notifiying!")
                    loginDelegate?.receivedMessage(message: message)
                    chatDelegate?.receivedMessage(message: message)
                    drawingDelegate?.receivedMessage(message: message)
                    galleryDelegate?.receivedMessage(message: message)
                    
                    // VERO FOR CHATROOM CREATION
                    handleOtherMessages(message: message)
                    
                } catch let jsonErr {
                    print("Error decoding Json", jsonErr)
                }
            }
        }
    }
    
    // VERO HANDLES END OF PROJECT
    private func handleOtherMessages(message : Message) {
        // VERO FOR CHATROOM CREATION
        if chatDelegate == nil, message._type == MessageType.ChatMessage {
            missedMessagesChat.append(message)
            missedMessagesChatroom.append(message)
        }
        if message._type == MessageType.LoginMessage, message._subtype == SubMessageType.IsNewUserMessage {
            isFirstConnection = true
        }
    }
}

extension String {
    func replacingLastOccurrenceOfString(_ searchString: String, with replacementString: String, caseInsensitive: Bool = true) -> String {
        let options: String.CompareOptions
        if caseInsensitive {
            options = [.backwards, .caseInsensitive]
        }
        else {
            options = [.backwards]
        }
        
        if let range = self.range(of: searchString, options: options, range: nil, locale: nil) {
            return self.replacingCharacters(in: range, with: replacementString)
        }
        return self
    }
}


