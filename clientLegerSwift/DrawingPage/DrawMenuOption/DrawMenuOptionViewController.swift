//
//  DrawMenuOptionViewController.swift
//  clientLegerSwift
//
//  Created by veronique demers on 18-03-04.
//  Copyright © 2018 log3900. All rights reserved.
//

import UIKit

class DrawMenuOptionViewController: UIViewController {
    
    @IBOutlet weak var headSize: RoundView!
    @IBOutlet weak var headSizeLeading: NSLayoutConstraint!
    @IBOutlet weak var headSizeTop: NSLayoutConstraint!
    
    @IBOutlet weak var roundViewHeight: NSLayoutConstraint!
    @IBOutlet weak var roundViewWidth: NSLayoutConstraint!
    
    @IBOutlet weak var headSizeSlider: UISlider!
    @IBOutlet weak var headSizeDisplay: UILabel!
    
    // boutons
    @IBOutlet weak var newCanvasButton: RoundButton!
    @IBOutlet weak var splitSegmentEraserButton: RoundButton!
    @IBOutlet weak var eraseSegmentButton: RoundButton!
    @IBOutlet weak var gridButton: RoundButton!
    @IBOutlet weak var selectButton: RoundButton!
    
    // grid view
    @IBOutlet weak var gridSpacingView: DrawingMenuView!
    @IBOutlet weak var gridSpacingTextFiled: UITextField!
    @IBOutlet weak var mustBeInteger: UILabel!
    var gridSpacing : Int = 5
    
    
    
    var brushSize: CGFloat = 2
    var buttons : [RoundButton] = []
    let lineDrawing = LineDrawing.instance
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        brushSize = lineDrawing.currentWidth
        buttons = [newCanvasButton, splitSegmentEraserButton, eraseSegmentButton, gridButton]
        
        setUpSliderDisplay()
        setUpButtonDisplay()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpSliderDisplay()
        setUpButtonDisplay()
    }

    private func setUpSliderDisplay() {
        // brush slider
        setBrushSizeDisplay(value: brushSize)
        
        // set the brush size (number)
        headSizeDisplay.text = Int(brushSize).description
        
        // set the slider
        headSizeSlider.value = Float(brushSize)
    }
    
    private func setUpButtonDisplay() {
        switch lineDrawing.currentState! {
        case .EraseElement :
            eraseSegmentButton.set(background: #colorLiteral(red: 0.658308804, green: 0.8193534017, blue: 0.9075077176, alpha: 1))
            break
        case .SplitElement :
            splitSegmentEraserButton.set(background: #colorLiteral(red: 0.658308804, green: 0.8193534017, blue: 0.9075077176, alpha: 1))
            break
        default:
            break
        }
        
        gridSpacingView.alpha = 0
        if lineDrawing.isGridEnable {
            gridButton.set(background: #colorLiteral(red: 0.658308804, green: 0.8193534017, blue: 0.9075077176, alpha: 1))
        }
    }
    
    
    @IBAction func brushSizeChanged(_ sender: UISlider) {
        setBrushSizeDisplay(value: CGFloat(sender.value))
        brushSize = CGFloat(sender.value)
    }
    
    private func setBrushSizeDisplay(value : CGFloat) {
        headSizeDisplay.text = Int(value).description
        
        roundViewWidth.constant = value
        roundViewHeight.constant = value
        
        headSize.cornerRaidus = value/2
        
        // center the brush head
        headSizeLeading.constant = 22 + (50 - (value/2))
        headSizeTop.constant = 20 + (50 - (value/2))
    }
    
    @IBAction func newCanvasWasPressed(_ sender: RoundButton) {
        unselectAllButtons(but : sender)
        sender.set(background: sender.tintColor)
    }
    
    @IBAction func splitSegmentWasPressed(_ sender: RoundButton) {
        unselectAllButtons(but : sender)
        sender.set(background: sender.tintColor)
    }
    
    @IBAction func eraseSegmentWasPressed(_ sender: RoundButton) {
        unselectAllButtons(but : sender)
        sender.set(background: sender.tintColor)
    }
    
    @IBAction func gridWasPressed(_ sender: RoundButton) {
        unselectAllButtons(but : sender)
        sender.set(background: sender.tintColor)
        
        if sender.backgroundColor == #colorLiteral(red: 0.658308804, green: 0.8193534017, blue: 0.9075077176, alpha: 1) {
            gridSpacingView.showSlowly()
        }
        else {
            lineDrawing.isGridEnable = false
            lineDrawing.objectGenerator.removeGrid()
        }
    }
    
    private func unselectAllButtons( but sender: RoundButton) {
        for button in buttons {
            if button != sender {
                button.set(background: .white)
            }
        }
        
        // managing grid
        if lineDrawing.isGridEnable {
            gridButton.set(background: #colorLiteral(red: 0.658308804, green: 0.8193534017, blue: 0.9075077176, alpha: 1) )
        }
        gridSpacingView.hide()
    }
    
    @IBAction func selectWasPressed(_ sender: Any) {
        lineDrawing.currentWidth = brushSize
        var selectedButton:RoundButton!
        for button in buttons {
            if lineDrawing.isGridEnable {
                if button.backgroundColor == #colorLiteral(red: 0.658308804, green: 0.8193534017, blue: 0.9075077176, alpha: 1) && button != gridButton {
                    selectedButton = button
                }
            }
            else {
                if button.backgroundColor == #colorLiteral(red: 0.658308804, green: 0.8193534017, blue: 0.9075077176, alpha: 1) {
                    selectedButton = button
                }
            }
        }
        
        guard (selectedButton) != nil else {
            lineDrawing.currentState = LineDrawing.State.Draw
            dismiss(animated: true, completion: nil)
            return
        }
        
        handleSelection(selectedButton : selectedButton)
    }
    
    private func handleSelection(selectedButton : RoundButton) {
        switch selectedButton {
        case newCanvasButton :
            handleNewCanvasSelection(button : selectedButton)
            break
        case splitSegmentEraserButton :
            handleSplitSegmentSelection(button: selectedButton)
            break
        case eraseSegmentButton :
            handleEraseSegmentSelection(button: selectedButton)
            break
        case gridButton :
            handleGridSelection(button: selectedButton)
            break
        default :
            break
        }
    }
    
    private func handleNewCanvasSelection(button : RoundButton) {
        button.set(background: UIColor.white)
        lineDrawing.generateBlankCanvas()
        dismiss(animated: true, completion: nil)
    }
    
    private func handleSplitSegmentSelection(button : RoundButton) {
        lineDrawing.currentState = LineDrawing.State.SplitElement
        dismiss(animated: true, completion: nil)
    }

    private func handleEraseSegmentSelection(button : RoundButton) {
        lineDrawing.currentState = LineDrawing.State.EraseElement
        dismiss(animated: true, completion: nil)
    }
    
    private func handleGridSelection(button : RoundButton) {
        if let spacing = gridSpacingTextFiled.text {
            if !spacing.isNumber {
                mustBeInteger.show()
                gridSpacingTextFiled.layer.borderColor = #colorLiteral(red: 1, green: 0.374024868, blue: 0.3451677859, alpha: 1)
                gridSpacingTextFiled.layer.borderWidth = 2
            }
            else {
                lineDrawing.isGridEnable = true
                lineDrawing.objectGenerator.generateGridOf(spacing: Int(spacing)!)
                dismiss(animated: true, completion: nil)
            }
        }
    }
}

extension String  {
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}

extension UILabel {
    func show() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 1
        })
    }
}

