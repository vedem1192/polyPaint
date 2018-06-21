//
//  PixelDrawMenuOptionViewController.swift
//  clientLegerSwift
//
//  Created by veronique demers on 18-03-28.
//  Copyright © 2018 log3900. All rights reserved.
//

import UIKit

class PixelDrawMenuOptionViewController : UIViewController {
    
    @IBOutlet weak var headSize: RoundView!
    @IBOutlet weak var headSizeLeading: NSLayoutConstraint!
    @IBOutlet weak var headSizeTop: NSLayoutConstraint!
    
    @IBOutlet weak var roundViewHeight: NSLayoutConstraint!
    @IBOutlet weak var roundViewWidth: NSLayoutConstraint!
    
    @IBOutlet weak var headSizeSlider: UISlider!
    @IBOutlet weak var headSizeDisplay: UILabel!
    
    // buttons
    @IBOutlet weak var newCanvasButton: RoundButton!
    @IBOutlet weak var eraseButton: RoundButton!
    @IBOutlet weak var blackAndWhiteButton: RoundButton!
    @IBOutlet weak var blurButton: RoundButton! // if time
    @IBOutlet weak var saturationButton: RoundButton!
    @IBOutlet weak var selectButton: RoundButton!
    
    var brushSize : CGFloat = 2
    var buttons : [RoundButton] = []
    let pixelDrawing = PixelDrawing.instance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        brushSize = pixelDrawing.currentWidth
        buttons = [newCanvasButton, eraseButton, blackAndWhiteButton, blurButton, saturationButton]
        
        setUpSliderDisplay()
        setUpButtonDisplay()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpSliderDisplay()
        setUpButtonDisplay()
    }
    
    private func setUpSliderDisplay() {
         setBrushSizeDisplay(value: brushSize)
        headSizeDisplay.text = Int(brushSize).description
        headSizeSlider.value = Float(brushSize)
    }
    
    private func setUpButtonDisplay() {
        // newCanvas, black&White and Blur at not persistant mode, only ponctual actions
        if pixelDrawing.currentState == PixelDrawing.State.Erase {
            eraseButton.set(background: #colorLiteral(red: 0.658308804, green: 0.8193534017, blue: 0.9075077176, alpha: 1))
        }
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
    
    @IBAction func brushSizeChanged(_ sender: UISlider) {
        setBrushSizeDisplay(value: CGFloat(sender.value))
        brushSize = CGFloat(sender.value)
    }
    
    @IBAction func newCanvasWasPressed(_ sender: RoundButton) {
        unselecteAllButtons(but: sender)
        sender.set(background: sender.tintColor)
    }
    
    @IBAction func eraseWasPressed(_ sender: RoundButton) {
        unselecteAllButtons(but: sender)
        sender.set(background: sender.tintColor)
    }
    
    @IBAction func blackAndWhiteWasPressed(_ sender: RoundButton) {
        unselecteAllButtons(but: sender)
        sender.set(background: sender.tintColor)
    }
    
    @IBAction func blurWasPressed(_ sender: RoundButton) {
        unselecteAllButtons(but: sender)
        sender.set(background: sender.tintColor)
    }
    
    @IBAction func saturationWasPressed(_ sender: RoundButton) {
        unselecteAllButtons(but: sender)
        sender.set(background: sender.tintColor)
    }
    
    
    @IBAction func selectWasPressed(_ sender: RoundButton) {
        pixelDrawing.currentWidth = brushSize
        var selectedButton : RoundButton!
        for button in buttons {
            if button.backgroundColor == #colorLiteral(red: 0.658308804, green: 0.8193534017, blue: 0.9075077176, alpha: 1) {
                selectedButton = button
            }
        }
        
        guard (selectedButton) != nil else {
            pixelDrawing.currentState = PixelDrawing.State.Draw
            dismiss(animated: true, completion: nil)
            return
        }
        
        handleSelection(selectedButton: selectedButton)
        dismiss(animated: true, completion: nil)
    }
    
    private func unselecteAllButtons( but sender : RoundButton) {
        for button in buttons {
            if button != sender {
                button.set(background: .white)
            }
        }
    }
    
    private func handleSelection(selectedButton : RoundButton) {
        switch selectedButton {
        case newCanvasButton :
            handleNewCanvasSelection(button: selectedButton)
            break
        case eraseButton :
            handleEraseSelection(button: selectedButton)
            break
        case blackAndWhiteButton :
            handleBlackAndWhiteSelection(button: selectedButton)
            break
        case blurButton :
            handleBlurSelection(button: selectedButton)
            break
        case saturationButton :
            handleSaturationSelection(button: selectedButton)
            break
        default :
            break
        }
    }
    
    private func handleNewCanvasSelection(button : RoundButton) {
        button.set(background: UIColor.white)
        let presentingVC = presentingViewController as! DrawingPageViewController
        presentingVC.imageview.image = pixelDrawing.blankCanvas
    }

    private func handleEraseSelection(button : RoundButton) {
        pixelDrawing.currentState = PixelDrawing.State.Erase
    }
    
    private func handleBlackAndWhiteSelection(button : RoundButton) {
        button.set(background: UIColor.white)
        let presentingVC = presentingViewController as! DrawingPageViewController
        presentingVC.imageview.image = pixelDrawing.convertToBlackAndWhite(image: presentingVC.imageview.image!)
    }
    
    private func handleSaturationSelection(button : RoundButton) {
        pixelDrawing.currentState = PixelDrawing.State.Saturation
        // show the slider menu
        let presentingVC = presentingViewController as! DrawingPageViewController
        presentingVC.saturationView.show()
    }
    
    private func handleBlurSelection(button : RoundButton) {
        button.set(background: UIColor.white)
        let presentingVC = presentingViewController as! DrawingPageViewController
        presentingVC.imageview.image = pixelDrawing.blurEffect(image: presentingVC.imageview.image!)
    }
}
