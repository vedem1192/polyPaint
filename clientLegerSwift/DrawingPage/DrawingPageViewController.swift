//
//  DrawingPageViewController.swift
//  clientLegerSwift
//
//  Created by veronique demers on 18-02-19.
//  Copyright © 2018 log3900. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import Social
import AVFoundation

enum Mode {
    case Line
    case Pixel
}

class DrawingPageViewController: UIViewController, UIGestureRecognizerDelegate {
    
    
    
    let drawing = LineDrawing.instance
    let setting = SettingDrawingSetter.instance
    let math = MathBasic()
    
    @IBOutlet weak var colorButton: RoundButton!
    @IBOutlet weak var pasteSelection: UIButton!
    
//    var drawingMode : Mode!
    var drawingMode : Mode!
    var pixelDrawing : PixelDrawing!
    
    public let imageview = UIImageView()
    
    
    @IBOutlet weak var appNavigationView: UIView!

    let objectGenerator = ObjectGenerator()
    let networkManager = NetworkManager.instance
    let drawingManager = DrawingManager.drawingInstance
    let chatManager = ChatManager.chatInstance
    
    var buttonCollection: [RoundButton] = []
    var selectedMenuButton: RoundButton!
    
    
    @IBOutlet weak var drawingMenuView: DrawingMenuView!
    
    @IBOutlet weak var cutCopyMenuView: CutCopyMenuView!
    @IBOutlet weak var cutSelection: RoundButton!
    @IBOutlet weak var copySelection: RoundButton!
    
    @IBOutlet weak var editButton: RoundButton!
    @IBOutlet weak var selectionToolsButton: RoundButton!
    @IBOutlet weak var paintToolsButton: RoundButton!
    @IBOutlet weak var formsAndTypeButton: RoundButton!
    @IBOutlet weak var helpButton: RoundButton!
    
    @IBOutlet weak var undoButton: UIButton!
    @IBOutlet weak var redoButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var facebookButton: RoundButton!
    
    // eye dropper view
    @IBOutlet weak var eyeDropperView: EyeDropper!
    // image modifier view
    @IBOutlet weak var imageModifierView : ImageModifierView!
    // quick color selector
    @IBOutlet weak var quickColorSelectorView: QuickColorSelectorView!
    @IBOutlet weak var messageReceivedIndicator: RoundButton!
    // Saturation
    @IBOutlet weak var saturationView: Saturation!
    
    
    
    var timer : Timer?
    var audioPlayer : AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawingMode = setting.drawingMode ? Mode.Pixel : Mode.Line
        networkManager.drawingDelegate = self
        initMenuPresentation()
        buttonCollection = [editButton, selectionToolsButton,
                            paintToolsButton, paintToolsButton,
                            formsAndTypeButton, helpButton]
        
        setColorButton(to: drawing.currentStrokeColor)

        drawingMode == Mode.Line ? initLineDrawingPage() : initPixelDrawingPage()
        //save every minute
        scheduledSaving()
        
        initGestureRecognizers()
        audioPlayer = try? AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "messageSound", ofType: "mp3")!))
        audioPlayer.prepareToPlay()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        startTutorial()
    }
    
    private func startTutorial() {
        if networkManager.isFirstConnection {
            helpButton.sendActions(for: .touchUpInside)
            networkManager.isFirstConnection = false
        }
    }
    
    private func initMenuPresentation() {
        self.view.backgroundColor = .white
        drawingMenuView.alpha = 0
        imageModifierView.alpha = 0
        cutCopyMenuView.alpha = 0
        eyeDropperView.alpha = 0
        quickColorSelectorView.alpha = 0
        pasteSelection.isHidden = true
    }
    
    private func initLineDrawingPage() {
        let skView = view as! SKView
        skView.ignoresSiblingOrder = true
        drawing.scaleMode = .resizeFill
        skView.presentScene(drawing)
        
        drawing.currentState = LineDrawing.State.Draw
        drawing.presentingVC = self
    }
    
    private func initPixelDrawingPage() {
        PixelDrawing.setup(controller: self, imageview: imageview)
        pixelDrawing = PixelDrawing.instance
        pixelDrawing.resetSingleton()
        pixelDrawing.currentState = PixelDrawing.State.Draw
        
        undoButton.isHidden = true
        redoButton.isHidden = true
    }
    
    private func initGestureRecognizers() {
        initPichGestureRecognizer()
        initRotationGestureRecognizer()
        initPanGestureRecognizer()
    }
    
    private func initPichGestureRecognizer() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(scale))
        pinchGesture.delegate = self
        view.addGestureRecognizer(pinchGesture)
    }
    
    private func initRotationGestureRecognizer() {
        let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(rotate))
        rotationGesture.delegate = self
        view.addGestureRecognizer(rotationGesture)
    }
    
    private func initPanGestureRecognizer() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(pan))
        
        // so touches is not picked up by the pangesturerecognizer
        panGesture.delegate = self
        panGesture.maximumNumberOfTouches = 2
        panGesture.minimumNumberOfTouches = 2
        
        view.addGestureRecognizer(panGesture)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if drawingMode == .Pixel {
            if pixelDrawing.currentState == PixelDrawing.State.EyeDropping {
                guard let touch = touches.first else { return }
                let location = touch.location(in: self.view)
                
                let eyeDropperViewFrame = self.view.convert(eyeDropperView.frame, from: eyeDropperView.superview)
                if eyeDropperViewFrame.contains(location) {
                    eyeDropperView.isSelected = true
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if drawingMode == .Line {
            drawing.touchesMoved(touches, with: event)
        }
        else {
            guard let touch = touches.first else { return }
            var location = touch.location(in: self.view)
            
            if pixelDrawing.currentState == PixelDrawing.State.EyeDropping {
                if eyeDropperView.isSelected {
                    eyeDropperView.center = location
                }
            }
            else if pixelDrawing.currentState == PixelDrawing.State.Saturation{
                print("saturation")
            }
            else if pixelDrawing.currentState != PixelDrawing.State.ImageModification {
                let eraseEnable = pixelDrawing.currentState == PixelDrawing.State.Erase
                imageview.image = pixelDrawing.draw(in: imageview.image!, at: location.invert(), isErasing: eraseEnable)
                if pixelDrawing.modifiedPixel.count > 100 {
                    sendPixels()
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if drawingMode == .Line {
            if drawing.currentState == LineDrawing.State.Lasso , drawing.selectedLine.count > 0 {
                    cutCopyMenuView.alpha = 1
            }
        }
        else {
            if pixelDrawing.currentState == PixelDrawing.State.EyeDropping {
                eyeDropperView.isSelected = false
            }
            sendPixels()
        }
    }
    
    private func sendPixels() {
        let color = pixelDrawing.currentState == PixelDrawing.State.Draw ? pixelDrawing.currentStrokeColor : UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        drawingManager.sendModifiedPixelMessage(modifiedPixelMessage: pixelDrawing.createPixelMessage(modifiedPixelArray: pixelDrawing.modifiedPixel, width: pixelDrawing.currentWidth, color: color))
        pixelDrawing.emptyModifiedArrayPixel()
    }
    
    
    @IBAction func userTapped(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: self.view)
        
        // with singleton
        if drawingMode == .Line {
            if drawing.currentState == LineDrawing.State.EraseElement {
                drawing.lineModifier.eraseFullElement(location)
            }
        }
        else {
            if pixelDrawing.currentState == PixelDrawing.State.EyeDropping {
                eyeDropperView.updateColor(color: imageview.getColor(at: location))
            }
            else if pixelDrawing.currentState == PixelDrawing.State.SelectByColor && quickColorSelectorView.alpha != 1 {
                pixelDrawing.selectPixel(by: imageview.getColor(at: location), from: imageview.image!)
                quickColorSelectorView.show()
            }
        }
    }

    
    
    @IBAction func showDrawingMenu(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            drawingMenuView.show(at: sender.location(in: self.view))
            break
        case .changed:
            handleUserMoving(at: sender.location(in: self.view))
            break
        case .ended:
            drawingMenuView.hide()
            handleUserDrawingMenuSelection(at: sender.location(in: self.view))
            resetButtons()
            break
        default:
            break
        }
    }
    
    private func handleUserDrawingMenuSelection(at location: CGPoint) {
        if let button = selectedMenuButton, math.checkFor(point: location, inside: button) {
            print(button)
            button.sendActions(for: .touchUpInside)
        }
    }
    
    @IBAction func triggerMenu(sender: AnyObject) {
        // https://stackoverflow.com/questions/37870701/how-to-use-one-ibaction-for-multiple-buttons-in-swift
        // only connected to drawingMenu and image&Text buttons!!
        guard let button = sender as? UIButton else {
            return
        }
        
        switch button.tag {
        case 1:
            print("Perform segue depending on the drawingMode")
            let id = drawingMode == .Line ? "drawMenuOption" : "pixelDrawMenuOption"
            performSegue(withIdentifier: id, sender: button)
            break
        default:
            print("Unknown language")
            return
        }
    }
    
    private func handleUserMoving(at location : CGPoint) {
        setButtonsRelativeCenter()
        
        for button in buttonCollection {
            if math.checkFor(point: location, inside: button) {
                button.set(background: #colorLiteral(red: 0.658308804, green: 0.8193534017, blue: 0.9075077176, alpha: 1))
                selectedMenuButton = button
            }
            else {
                button.set(background: .white)
            }
        }
    }
    
    func setColorButton(to color : UIColor) {
        colorButton.backgroundColor = color
    }
    
    private func resetButtons() {
        for button in buttonCollection {
            button.set(background: .white)
        }
        selectedMenuButton = nil
        setCurrentState(to : "Draw")
    }
    
    private func setCurrentState(to state: String) {
        switch state {
        case "Draw":
            if drawingMode == .Line {
                drawing.currentState = LineDrawing.State.Draw;
            }
            else {
                pixelDrawing.currentState = PixelDrawing.State.Draw
            }
            break
        default:
            break
        }
    }
    
    private func setButtonsRelativeCenter() {
        for button in buttonCollection {
            button.relativeCenter = button.convert(button.center, to: nil)
            button.relativeCenter.x -= button.frame.minX
            button.relativeCenter.y -= button.frame.minY
        }
    }
    
    private func scheduledSaving() {
        timer = Timer.scheduledTimer(timeInterval: 30, target: self, selector:#selector(self.saveDrawing), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        if timer != nil {
            timer!.invalidate()
            timer = nil
        }
    }
    
    @objc func saveDrawing() {
        //ASK VERO
        // get the drawing
        let canvasThumbnail = getCanvasThumbnailInBase64()
        drawingManager.saveDrawing(drawing: DrawingObject(image: canvasThumbnail!, title: setting.title, visibility: setting.visibility , password: setting.password, id: drawingManager.drawingId, drawingMode: setting.drawingMode))
        for stroke in drawing.lineCollection {
            drawingManager.sendSaveStrokeInDbMessage(sendableLineObject: objectGenerator.createSendableLineObject(lineObject: stroke))
        }
    }
    
    private func getCanvasThumbnailInBase64() -> String? {
        prepareCanvas()
        let testing = captureScreen()
        restoreCanvas()
        let smallImage = resizeImage(image: testing, newWidth: 40.0)
        
        let jpeg = UIImageJPEGRepresentation(smallImage, 0.5)
        return jpeg?.base64EncodedString(options: .lineLength64Characters)
    }
    
    private func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func saveNewDrawing() {
        //ASK VERO
        //Deal with the public/private with and without password
        drawingManager.saveAsNewDrawing(newDrawing: DrawingObject(creator: networkManager.username, title: setting.title , visibility: setting.visibility, password: setting.password))
    }
    
    func convertUIImageToByteArray(image: UIImage) -> String {
        // encoding
        let imageData = UIImageJPEGRepresentation(image, 0.1)
        let encodingBase64 = imageData?.base64EncodedString(options: .lineLength64Characters)
        return encodingBase64!
    }
   
    
    @IBAction func undoButtonWasPressed(_ sender: Any) {
        drawing.undo()
    }
    
    @IBAction func redoButtonWasPressed(_ sender: Any) {
        drawing.redo()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func exportImage(_ sender: RoundButton) {
        self.exportImage()
    }
    
    @IBAction func cutSelected(_ sender: Any) {
        cutCopyMenuView.alpha = 0
        pasteSelection.isHidden = false
        drawing.lineModifier.cutSelection()
        drawing.currentState = LineDrawing.State.Draw
    }
    
    @IBAction func copySelected(_ sender: Any) {
        cutCopyMenuView.alpha = 0
        drawing.lineModifier.copy()
        drawing.currentState = LineDrawing.State.Draw
    }
    
    
    @IBAction func pasteSelected(_ sender: Any) {
        drawing.lineModifier.paste()
        pasteSelection.isHidden = true
    }
    
    @IBAction func sharedFacebook(_ sender: Any) {
        prepareCanvas()
        let img = captureScreen()
        restoreCanvas()
        let share = [img]
        
            let activityViewController = UIActivityViewController(activityItems:share, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func settingsWasPressed(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let settingViewController = storyboard.instantiateViewController(withIdentifier: "settingPage") as! SettingDrawingViewController
        self.present(settingViewController, animated: true, completion: nil)
    }
}


extension DrawingPageViewController : NetworkManagerDelegate {
    func receivedMessage(message: Message) {
        print("Got drawing delegate message: ")
        print(message)
        if (message._type == .ChatMessage) {
            if(message._subtype == .BroadcastChatMessage) {
                self.messageReceivedIndicator.show()
                audioPlayer.play()
                self.messageReceivedIndicator.hide()
                chatManager.processChatroomMessageToDictionnary(message: message)
            }
        }
            drawingManager.processAuthorityRequestMessage(message: message)
            drawingManager.processNewDrawingIdMessage(message: message)
        if let msg = drawingManager.processLineObjectMessage(message: message){
            objectGenerator.addLineObject(lineObjectMessage: msg)
        } else {
            if let msg = drawingManager.processModifiedPixelMessage(message: message) {
                self.imageview.image = pixelDrawing.addModifiedPixel(modifiedPixelMessage: msg, image : imageview.image!)
            } else {
            if let msg = drawingManager.processStrokeEraseByLineMessage(message: message) {
                objectGenerator.eraseDrawingObjectWithId(id: msg)
            } else {
                if let msg = drawingManager.processStrokeMovedMessage(message: message) {
                    objectGenerator.movedStroke(strokeMovedMessage: msg)
                } else {
                    if let msg = drawingManager.processReinitializeCanvasMessage(message: message) {
                        if (msg == true) {
                            drawing.generateBlankCanvasFromMessage()
                            }
                        }
                    }
                }
            }
        }
    }
}
