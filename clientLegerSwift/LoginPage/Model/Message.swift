//
//  Message.swift
//  clientLegerSwift
//
//  Created by Simon Barrette on 18-03-14.
//  Copyright © 2018 log3900. All rights reserved.
//

import Foundation

struct Message: Codable {
    
    var _type: MessageType
    var _subtype: SubMessageType
    var _content: String
    
    private enum CodingKeys: String, CodingKey {
        case _type
        case _subtype
        case _content
    }
    
    
    init(type: MessageType, subtype: SubMessageType, content: String) {
        self._type = type
        self._subtype = subtype
        self._content = content
    }
    
    //For decoding
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _type = try values.decode(MessageType.self, forKey: ._type)
        _subtype = try values.decode(SubMessageType.self, forKey: ._subtype)
        _content = try values.decode(String.self, forKey: ._content)
    }

}

enum MessageType: Int, Codable {
    case LoginMessage
    case ChatMessage
    case DrawingMessage
    case GalleryMessage
}

enum SubMessageType: Int, Codable {
    case AuthenticateMessage
    case InvalidMessage
    case JoinChatMessage
    case QuitAppMessage
    case BroadcastChatMessage
    case SaveAsDrawingMessage
    case SaveDrawingMessage
    case FetchPublicGalleryImagesMessage
    case RetrievePublicGalleryImagesMessage
    case LineObjectMessage
    case JoinDrawingSessionMessage
    case StrokeErasedByLineMessage
    case CanvasResizeMessage
    case ReinitializeCanvasMessage
    case AuthorityRequestMessage
    case StrokeMovedMessage
    case SelectionDoneMessage
    case FetchUserGalleryImagesMessage
    case RetrieveUserGalleryImagesMessage
    case ModifiedPixelMessage
    case UpdateSettingsDrawingMessage
    case NewDrawingIdMessage
    case CreateChatroomMessage
    case ConfirmDrawingSessionEntryMessage
    case LeaveDrawingSessionMessage
    case GetUserIdMessage
    case IsNewUserMessage
    case SaveStrokeInDbMessage
    case FetchStrokesWithDrawingIdMessage
}

