//
//  ImageAndTextMenuViewController.swift
//  clientLegerSwift
//
//  Created by veronique demers on 18-03-30.
//  Copyright © 2018 log3900. All rights reserved.
//

import UIKit

class ImageAndTextMenuViewController: UIViewController {
    
    let lineDrawing = LineDrawing.instance
    var pixelDrawing : PixelDrawing!

    @IBOutlet weak var addElipseButton: RoundButton!
    @IBOutlet weak var addRectangleButton: RoundButton!
    @IBOutlet weak var addHexagonButton: RoundButton!
    @IBOutlet weak var addOctogonButton: RoundButton!
    @IBOutlet weak var addPentagonButton: RoundButton!
    @IBOutlet weak var addTriangleButton: RoundButton!
    @IBOutlet weak var addDiamondButton: RoundButton!
    @IBOutlet weak var addArrowButton: RoundButton!
    @IBOutlet weak var addLightningButton: RoundButton!
    @IBOutlet weak var addLineButton: RoundButton!
    
    @IBOutlet weak var importImageButton: RoundButton!
    @IBOutlet weak var addTextButton: RoundButton!
    
    var buttons: [RoundButton] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttons = [addElipseButton, addRectangleButton, addHexagonButton, addOctogonButton, addPentagonButton, addLineButton, addTriangleButton, addDiamondButton, addArrowButton, addLightningButton]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let presentingVC = presentingViewController as! DrawingPageViewController
        if presentingVC.drawingMode == Mode.Line {
            setUpButtonDisplay()
        }
        else {
            for button in buttons {
                button.isHidden = true
            }
            addTextButton.isHidden = true
            importImageButton.transform = CGAffineTransform(translationX: 120, y: -100)
        }
    }
    
    private func setUpButtonDisplay() {
        if lineDrawing.currentState == LineDrawing.State.InsertShape {
            switch lineDrawing.shapeToInsert! {
            case .Elipse :
                addElipseButton.set(background:  #colorLiteral(red: 0.658308804, green: 0.8193534017, blue: 0.9075077176, alpha: 1))
                break
            case .Hexagon :
                addHexagonButton.set(background:  #colorLiteral(red: 0.658308804, green: 0.8193534017, blue: 0.9075077176, alpha: 1))
                break
            case .Rectangle :
                addRectangleButton.set(background:  #colorLiteral(red: 0.658308804, green: 0.8193534017, blue: 0.9075077176, alpha: 1))
                break
            case .Octogon :
                addOctogonButton.set(background: #colorLiteral(red: 0.658308804, green: 0.8193534017, blue: 0.9075077176, alpha: 1))
                break
            case .Pentagon :
                addPentagonButton.set(background: #colorLiteral(red: 0.658308804, green: 0.8193534017, blue: 0.9075077176, alpha: 1))
                break
            case .Line :
                addLineButton.set(background: #colorLiteral(red: 0.658308804, green: 0.8193534017, blue: 0.9075077176, alpha: 1))
                break
            case .Triangle :
                addTriangleButton.set(background: #colorLiteral(red: 0.658308804, green: 0.8193534017, blue: 0.9075077176, alpha: 1))
                break
            case .Diamond :
                addDiamondButton.set(background: #colorLiteral(red: 0.658308804, green: 0.8193534017, blue: 0.9075077176, alpha: 1))
                break
            case .Arrow :
                addArrowButton.set(background: #colorLiteral(red: 0.658308804, green: 0.8193534017, blue: 0.9075077176, alpha: 1))
                break
            case .Lightning :
                addLightningButton.set(background: #colorLiteral(red: 0.658308804, green: 0.8193534017, blue: 0.9075077176, alpha: 1))
                break
            }
        }
    }
    
    private func aButtonWasSelected(button : RoundButton) {
        unselectAllButtons(but: button)
        button.set(background: button.tintColor)
    }
    
    @IBAction func importImageWasPressed(_ sender: Any) {
        let savedPhotoAlbum = UIImagePickerControllerSourceType.savedPhotosAlbum        
        self.dismiss(animated: false, completion: nil)
        
        let presentingVC = presentingViewController as! DrawingPageViewController
        if presentingVC.drawingMode == Mode.Line {
            lineDrawing.getPhotoFromSource(source: savedPhotoAlbum)
        }
        else {
            print("import image for pixel")
            presentingVC.getPhotoFromSource(source: savedPhotoAlbum)
        }
    }
    
    @IBAction func addTextWasPressed(_ sender: Any) {
        lineDrawing.currentState = LineDrawing.State.InsertText
        self.dismiss(animated: false, completion: nil)
    }
    
    
    @IBAction func addElipseWasSelected(_ sender: RoundButton) {
        aButtonWasSelected(button: sender)
    }
    
    @IBAction func addRectangleWasSelected(_ sender: RoundButton) {
        aButtonWasSelected(button: sender)
    }
    
    @IBAction func addHexagonWasSelected(_ sender: RoundButton) {
        aButtonWasSelected(button: sender)
    }
    
    @IBAction func addOctogonWasSelected(_ sender: RoundButton) {
        aButtonWasSelected(button: sender)
    }
    
    @IBAction func addPentagonWasSelected(_ sender: RoundButton) {
        aButtonWasSelected(button: sender)
    }
    
    @IBAction func addLineWasSelected(_ sender: RoundButton) {
        aButtonWasSelected(button: sender)
    }
    
    @IBAction func addTriangleWasSelected(_ sender: RoundButton) {
        aButtonWasSelected(button: sender)
    }
    
    @IBAction func addDiamondWasSelected(_ sender: RoundButton) {
        aButtonWasSelected(button: sender)
    }
    
    @IBAction func addArrowWasSelected(_ sender: RoundButton) {
        aButtonWasSelected(button: sender)
    }
    
    @IBAction func addLightningWasSelected(_ sender: RoundButton) {
        aButtonWasSelected(button: sender)
    }
    
    private func unselectAllButtons( but sender: RoundButton) {
        for button in buttons {
            if button != sender{
                button.set(background: .white)
            }
        }
    }

    @IBAction func selectWasPressed(_ sender: Any) {
        var selectedButton:RoundButton!
        for button in buttons {
            if button.backgroundColor == #colorLiteral(red: 0.658308804, green: 0.8193534017, blue: 0.9075077176, alpha: 1) {
                selectedButton = button
            }
        }
        
        guard (selectedButton) != nil else {
            lineDrawing.currentState = LineDrawing.State.Draw
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        lineDrawing.currentState = LineDrawing.State.InsertShape
        handleShapeSelection(selectedButton : selectedButton)
        self.dismiss(animated: true, completion: nil)
    }
    
    private func handleShapeSelection(selectedButton : RoundButton) {
        switch selectedButton {
        case addElipseButton :
            lineDrawing.shapeToInsert = LineDrawing.Shape.Elipse
            break
        case addRectangleButton :
            lineDrawing.shapeToInsert = LineDrawing.Shape.Rectangle
            break
        case addHexagonButton :
            lineDrawing.shapeToInsert = LineDrawing.Shape.Hexagon
            break
        case addOctogonButton :
            lineDrawing.shapeToInsert = LineDrawing.Shape.Octogon
            break
        case addPentagonButton :
            lineDrawing.shapeToInsert = LineDrawing.Shape.Pentagon
            break
        case addLineButton :
            lineDrawing.shapeToInsert = LineDrawing.Shape.Line
            break
        case addTriangleButton :
            lineDrawing.shapeToInsert = LineDrawing.Shape.Triangle
            break
        case addDiamondButton :
            lineDrawing.shapeToInsert = LineDrawing.Shape.Diamond
            break
        case addArrowButton :
            lineDrawing.shapeToInsert = LineDrawing.Shape.Arrow
            break
        case addLightningButton :
            lineDrawing.shapeToInsert = LineDrawing.Shape.Lightning
            break
        default :
            break
        }
    }

    
    
    
}
