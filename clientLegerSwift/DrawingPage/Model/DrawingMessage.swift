//
//  DrawingMessage.swift
//  clientLegerSwift
//
//  Created by Simon Barrette on 18-03-14.
//  Copyright © 2018 log3900. All rights reserved.
//

import Foundation
var drawingManager = DrawingManager.drawingInstance

struct SaveStrokeInDbMessage: Codable {
    var _drawingId: Int = drawingManager.drawingId
    var _jsonStroke: LineObjectMessage
    
    init(jsonStroke: LineObjectMessage) {
        self._jsonStroke = jsonStroke
    }
}
struct FetchStrokesWithDrawingIdMessage: Codable {
    var _drawingId: Int
    
    init(drawingId: Int) {
        self._drawingId = drawingId
    }
}

struct ReinitializeCanvasMessage: Codable {
    var _drawingId: Int = drawingManager.drawingId
}

struct AuthorityRequestMessage: Codable {
    var _strokeIdAuthority: Array<String> = Array()
    var _username: String
    var _drawingId: Int = drawingManager.drawingId
    
    init(strokeIDAuthority: Array<String>, username: String) {
        self._strokeIdAuthority = strokeIDAuthority
        self._username = username
    }
}

struct SelectionDoneMessage: Codable {
    var _ids: Array<String> = Array()
    var _drawingId: Int = drawingManager.drawingId
    
    init(ids: Array<String>) {
        self._ids = ids
    }
}

struct NewDrawingIdMessage: Codable {
    var _drawingId: Int
    var _mode: Bool
}

struct StrokeMovedMessage: Codable {
    var ListOfPoints: Array<Points> = Array()
    var _Id: String!
    var _drawingId: Int = drawingManager.drawingId
    var _color: [Float]
    var _width: Float
    var _height: Float
    
    init(sendableLineObject: SendableLineObject) {
        self.ListOfPoints = sendableLineObject._listOfPoints
        self._Id = sendableLineObject._Id
        self._color = sendableLineObject._color
        self._width = sendableLineObject._width
        self._height = sendableLineObject._height
    }
}

struct StrokeErasedByLineMessage: Codable {
    var _Id: String
    var _drawingId: Int = drawingManager.drawingId
    
    init(id: String) {
        self._Id = id
    }
}

struct JoinDrawingSessionMessage: Codable {
    var _drawingId: Int
    var _joiningArtist: String
    
    init(drawingId: Int, joiningArtist: String) {
        self._drawingId = drawingId
        self._joiningArtist = joiningArtist
    }
}

struct LeaveDrawingSessionMessage: Codable {

    var _leavingArtist: String
    var _drawingId: Int = drawingManager.drawingId
    
    init(leavingArtist: String) {
        self._leavingArtist = leavingArtist
    }
}

struct SaveAsDrawingMessage: Codable {
    var _drawing: DrawingObject
    
    init(drawing: DrawingObject) {
        self._drawing = drawing
    }
}

struct SaveAsNewDrawingMessage: Codable {
    var _drawing: DrawingObject
    
    init(drawing: DrawingObject) {
        self._drawing = drawing
    }
}

struct LineObjectMessage: Codable {
    var ListOfPoints: Array<Points> = Array()
    var _width: Float
    var _height: Float
    var _color: [Float]
    var _drawingId: Int!
    var _Id: String!
    
    init(sendableLineObject: SendableLineObject) {
        self.ListOfPoints = sendableLineObject._listOfPoints
        self._width = sendableLineObject._width
        self._height = sendableLineObject._height
        self._color = sendableLineObject._color
        self._drawingId = sendableLineObject._drawingId
        self._Id = sendableLineObject._Id
    }
}
    
struct ModifiedPixelMessage: Codable {
    var _pixels: Array<SendablePixel> = Array()
    var _width: Int
    var _color: [Int]
    var _id: Int = drawingManager.drawingId
    
    init(pixels: Array<SendablePixel>, width: Int, color: [Int]) {
        self._pixels = pixels
        self._width = width
        self._color = color
    }
}
