//
//  SelectionMenuViewController.swift
//  clientLegerSwift
//
//  Created by lea el hage on 2018-03-24.
//  Copyright © 2018 log3900. All rights reserved.
//

import Foundation
import UIKit

class SelectionMenuViewController: UIViewController {
    let drawing = LineDrawing.instance
    var pixelDrawing : PixelDrawing!
    var intThreshold = 0
    
    @IBOutlet weak var thresholdView: UIView!
    @IBOutlet weak var thresholdValue: UILabel!
    @IBOutlet weak var eyeDropperButton: RoundButton!
    @IBOutlet weak var lassoButton: RoundButton!
    @IBOutlet weak var selectionByColorButton: RoundButton!
    
    var drawingMode : Mode!
    var buttons : [RoundButton] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttons = [lassoButton, eyeDropperButton, selectionByColorButton]
        setUpButtonDisplay()
    }
    
    func setUpButtonDisplay() {
        let presentingVC = presentingViewController as! DrawingPageViewController
        drawingMode = presentingVC.drawingMode
        
        if drawingMode == Mode.Line {
            eyeDropperButton.isHidden = true
            selectionByColorButton.isHidden = true
            if drawing.currentState == LineDrawing.State.Lasso {
                lassoButton.set(background: #colorLiteral(red: 0.658308804, green: 0.8193534017, blue: 0.9075077176, alpha: 1))
            }
        }
        else {
            pixelDrawing = PixelDrawing.instance
            lassoButton.isHidden = true
        }
    }
    
    private func aButtonWasSelected(button : RoundButton) {
        unselectAllButtons(but: button)
        button.set(background: button.tintColor)
    }
    
    private func unselectAllButtons( but sender: RoundButton) {
        for button in buttons {
            if button != sender{
                button.set(background: .white)
            }
        }
    }
    
    private func showThreshold() {
        UIView.animate(withDuration: 0.5) {
            self.thresholdView.alpha = 1
        }
    }
    
    private func hideThreshold() {
        UIView.animate(withDuration: 0.5) {
            self.thresholdView.alpha = 0
        }
    }
    
    @IBAction func lassoSelected(_ sender: RoundButton) {
        aButtonWasSelected(button: sender)
    }
    
    @IBAction func eyeDropperWasSelected(_ sender: RoundButton) {
        aButtonWasSelected(button: sender)
        hideThreshold()
    }
    
    @IBAction func selectionByColorWasSelected(_ sender: RoundButton) {
        aButtonWasSelected(button: sender)
        sender.backgroundColor == #colorLiteral(red: 0.658308804, green: 0.8193534017, blue: 0.9075077176, alpha: 1) ? showThreshold() : hideThreshold()
    }
    
    @IBAction func thresholdValueChanged(_ sender: UISlider) {
        pixelDrawing = PixelDrawing.instance
        thresholdValue.text = String(Int(sender.value))
        intThreshold = Int(sender.value)
    }
    
    @IBAction func selectWasPressed(_ sender: Any) {
        var selectedButton : RoundButton!
        for button in buttons {
            if button.backgroundColor == #colorLiteral(red: 0.658308804, green: 0.8193534017, blue: 0.9075077176, alpha: 1) {
                selectedButton = button
            }
        }
        
        guard selectedButton != nil else {
            if drawingMode == Mode.Line {
                drawing.currentState = LineDrawing.State.Draw
            }
            else {
                pixelDrawing.currentState = PixelDrawing.State.Draw
            }
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        handleSelection(selectedButton: selectedButton)
    }
    
    private func handleSelection(selectedButton : RoundButton) {
        if drawingMode == Mode.Line {
            drawing.currentState = LineDrawing.State.Lasso
            dismiss(animated: true, completion: nil)
        }
        else {
            switch selectedButton {
            case eyeDropperButton :
                handleEyeDropper()
                break
            case selectionByColorButton :
                handleSelectionByColor()
                break
            default :
                break
            }
        }
    }
    
    private func handleEyeDropper() {
        pixelDrawing.currentState = PixelDrawing.State.EyeDropping
        let presentingVC = presentingViewController as! DrawingPageViewController
        dismiss(animated: true, completion: nil)
        presentingVC.eyeDropperView.show()
    }
    
    private func handleSelectionByColor() {
        pixelDrawing.currentState = PixelDrawing.State.SelectByColor
        pixelDrawing.selectionByColorThreshold = intThreshold
        
        dismiss(animated: true, completion: nil)
    }
}















