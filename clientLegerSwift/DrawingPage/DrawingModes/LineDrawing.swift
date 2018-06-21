//
//  Drawing.swift
//  clientLegerSwift
//
//  Created by veronique demers on 18-03-21.
//  Copyright © 2018 log3900. All rights reserved.
//

import UIKit
import SpriteKit

class LineDrawing: SKScene {

    static let instance = LineDrawing()
    var presentingVC : DrawingPageViewController!
    var objectGenerator : ObjectGenerator!
    var lineModifier : LineModifier!
    var imageModifier : ImageModifier!
    
    var defaults:UserDefaults = UserDefaults.standard
    var isGridEnable = false
    
    enum State {
        case Draw
        case Lasso
        case SplitElement
        case EraseElement
        case Selection
        case ImageModification
        case InsertShape
        case InsertText
        case Default
    }
    
    enum Shape {
        case Elipse
        case Rectangle
        case Hexagon
        case Octogon
        case Pentagon
        case Line
        case Triangle
        case Diamond
        case Arrow
        case Lightning
    }
    
    // TODO: REFACTOR the shape thing
    var currentState: State!
    var shapeOrigin : CGPoint!
    var shapeToInsert : Shape!
    
    //////// TEST ///////////////////////////////////////
    var actionCollection : [ObjectGenerator.Action] = []
    var actionBin : [ObjectGenerator.Action] = []
    var shapeCollection : [ShapeObject] = []
    var shapeBin : [ShapeObject] = []
    
    var textCollection : [UITextView] = []
    /////////////////////////////////////////////////////
    
    var bin: [LineObject] = []
    var lineCollection: [LineObject] = []
    var pointCollection: [CGPoint] = []
    
    var currentStrokeColor = #colorLiteral(red: 0.6642242074, green: 0.6642400622, blue: 0.6642315388, alpha: 1)
    var currentWidth:CGFloat = 1
    
    var currentSelection: LineObject!
    var selectedLine : [Int] = []
    var selectedLineObject: [LineObject] = []
    var pasteCollection : [LineObject] = []
    
    
    
    override func didMove(to view: SKView) {
        objectGenerator = ObjectGenerator()
        lineModifier = LineModifier()
        imageModifier = ImageModifier()
        self.backgroundColor = .white
    }
    
    override func update(_ currentTime: TimeInterval) {
        // called before each frame is rendered
        updateCanvas()
        
        if self.currentState == State.Draw {
            objectGenerator.createSegmentPath(with: &pointCollection, color: currentStrokeColor, width: currentWidth, drawCurrentLine: true)
        }
        else if self.currentState == State.Lasso {
            objectGenerator.drawLassoLine()
        }
    }
    
    private func addMovingPoint(point: CGPoint) {
        pointCollection.append(point)
    }
    
    var textFieldOrigine : CGPoint!
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        if currentState == State.InsertShape {
            shapeOrigin = location
        }
        else if currentState == State.InsertText {
            print("yup, right here")
            textFieldOrigine = location
//            currentState = State.Draw
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        
        // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        // TODO : fix the if else statement !!!!!!!!!!!!!!!!!!!!!!!!!!!!
        // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        if currentState == State.SplitElement {
            lineModifier.splitSegment(at: location)
        }
        else if currentState == State.InsertShape {
            objectGenerator.insert(shape: shapeToInsert, from: shapeOrigin, to: location)
        }
        else if currentState != State.ImageModification {
            addMovingPoint(point: location)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self )
        
        if currentState == State.Draw {
            objectGenerator.createSegmentPath(with: &pointCollection, color: currentStrokeColor, width: currentWidth, drawCurrentLine: false)
        }
        else if currentState == State.InsertShape {
            objectGenerator.set(shape : shapeToInsert)
        }
        else if currentState == State.InsertText {
            objectGenerator.insertTextView(from : textFieldOrigine, to: location)
        }
        else if currentState == State.Lasso {
            objectGenerator.createSelectionLasso()
            if lineModifier.containingLine() {
                clearPoints()
                return
            }
            
            if lineModifier.containigShapes() {
                clearPoints()
                return
            }

            if lineModifier.containigTextView() {
                lineModifier.selectedTextView.isUserInteractionEnabled = true
                lineModifier.selectedTextView.becomeFirstResponder()
            }
        }
        clearPoints()
    }
    
    func scale(_ sender : UIPinchGestureRecognizer) {
        if currentState == State.ImageModification {
            if sender.state == .changed {
                imageModifier.scaleSelectedImage(scale: sender.scale)
            }
            else if sender.state == .ended {
                imageModifier.setScale(scale: sender.scale)
            }
        }
    }
    
    
    func rotate(_ sender : UIRotationGestureRecognizer) {
        if currentState == State.ImageModification {
            handleImageModification(sender : sender)
        }
        else if currentState == State.Lasso {
            handleLassoSelection(sender: sender)
        }
           
    }
    
    private func handleImageModification(sender : UIRotationGestureRecognizer ) {
        switch sender.state {
        case .changed :
            imageModifier.rotateSelectedImage(angle : sender.rotation)
            break
        case .ended :
            imageModifier.setRotationAngle(angle: sender.rotation)
            break
        default :
            break
        }
    }
    
    private func handleLassoSelection(sender : UIRotationGestureRecognizer) {
        switch sender.state {
        case .changed :
            if selectedLine.count > 0 {
                lineModifier.rotate(selectedElements: selectedLine, of: sender.rotation)
            }
            if lineModifier.selectedShapes.count > 0 {
                lineModifier.rotateShape(of: sender.rotation)
            }
            break
        case .ended :
            currentState = State.Draw
            break
        default :
            break
        }
    }
    
    func pan(_ sender : UIPanGestureRecognizer) {
        if currentState == State.ImageModification {
            if sender.state == .changed {
                imageModifier.panSelectedImage(of: sender.translation(in: self.view)) // check if modification still needed
            }
            else if sender.state == .ended {
                imageModifier.setOrigin(to: sender.translation(in: self.view))
            }
        }
    }
    
    func changes(accepted : Bool) {
        accepted ? imageModifier.acceptChanges() : imageModifier.discardChanges()
    }
    
    private func updateCanvas() {
        enumerateChildNodes(withName: "line", using: { node, stop in
            node.removeFromParent()
        })
        
        if lineCollection.count > 0 {
            for line in lineCollection {
                self.addChild(objectGenerator.createShapeNode(with: line))
            }
        }
    }
    
    func undo() {
        guard let action = actionCollection.popLast() else { return }
        switch action {
        case .LineSegment :
            for i in 0..<lineCollection.count {
                let index = lineCollection.count - (1 + i)
                if let id = lineCollection[index].id {
                    let myUsername = objectGenerator.drawingManager.networkManager.username
                    if id.range(of: myUsername) != nil {
                        // SIMON : si ça casse, c'est probablement ici
                        let hasAuthority = objectGenerator.checkForAuthorityPermission(id:id)
                        if (hasAuthority) {
                            objectGenerator.removeAuthority(id: id)
                            objectGenerator.drawingManager.sendStrokeEraseByLineMessage(id: id)
                            bin.append(lineCollection.remove(at: index))
                        }
                        break
                    }
                }
            }
            break
        case .Shape :
            guard let elem = shapeCollection.popLast() else { return }
            elem.skNode.isHidden = true
            shapeBin.append(elem)
            break
        }
        actionBin.append(action)
    }
    
    func redo() {
        guard let action = actionBin.popLast() else { return }
        switch action {
        case .LineSegment :
            guard let elem = bin.popLast() else { return }
            drawingManager.sendLineObject(sendableLineObject: objectGenerator.createSendableLineObject(lineObject: elem))
            lineCollection.append(elem)
            break
        case .Shape :
            guard let elem = shapeBin.popLast() else { return }
            elem.skNode.isHidden = false
            shapeCollection.append(elem)
            break
        }
        actionCollection.append(action)
    }
    
    func generateBlankCanvas() {
        cleanCanvas()
        objectGenerator.drawingManager.sendReinitializeCanvasMessage()
        drawingManager.authorityIdList.removeAll()
    }
    
    func cleanCanvas() {
        actionCollection.removeAll()
        actionBin.removeAll()
        
        lineCollection.removeAll()
        bin.removeAll()
        
        textCollection.removeAll()
        clearNodes()
    }
    
    func generateBlankCanvasFromMessage() {
        actionCollection.removeAll()
        actionBin.removeAll()
        
        lineCollection.removeAll()
        bin.removeAll()
        
        clearNodes()
        drawingManager.authorityIdList.removeAll()
    }
    
    func clearNodes() {
        self.removeAllChildren()
    }
    
    private func clearPoints() {
        pointCollection.removeAll()
    }
}











