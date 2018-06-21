//
//  ColorPickerViewController.swift
//  clientLegerSwift
//
//  Created by veronique demers on 18-03-02.
//  Copyright © 2018 log3900. All rights reserved.
//

import UIKit

class ColorPickerViewController: UIViewController, SwiftHUEColorPickerDelegate {
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var colorView: RoundView!
    
    @IBOutlet weak var horizontalColorPicker: SwiftHUEColorPicker!
    @IBOutlet weak var verticalBrightnessPicker: SwiftHUEColorPicker!
    @IBOutlet weak var verticalSaturationPicker: SwiftHUEColorPicker!
    var currentColor: UIColor!
    
    var presentingVC : DrawingPageViewController!
    let drawing = LineDrawing.instance
    var pixelDrawing : PixelDrawing?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presentingVC = presentingViewController as! DrawingPageViewController
        
        setPickers()
        
        if presentingVC.drawingMode == .Pixel {
            pixelDrawing = PixelDrawing.instance
            setColorView(with: pixelDrawing!.currentStrokeColor)
        }
        else {
            setColorView(with: drawing.currentStrokeColor)
        }

    }
    
    private func setPickers() {
        horizontalColorPicker.delegate = self;
        horizontalColorPicker.direction = .horizontal
        horizontalColorPicker.type = .color
        
        verticalBrightnessPicker.delegate = self
        verticalBrightnessPicker.direction = .vertical
        verticalBrightnessPicker.type = .brightness
        
        verticalSaturationPicker.delegate = self
        verticalSaturationPicker.direction = .vertical
        verticalSaturationPicker.type = .saturation
    }
    
    private func setColorView(with color: UIColor) {
        // color view background
        colorView.backgroundColor = color
        
        // pickers background
        valuePicked(color, type: horizontalColorPicker.type)
        valuePicked(color, type: verticalBrightnessPicker.type)
        valuePicked(color, type: verticalSaturationPicker.type)
    }
    
    
    @IBAction func selectColor(_ sender: UIButton) {
        if presentingVC.drawingMode == .Pixel {
            pixelDrawing!.currentStrokeColor = currentColor
        }
        else {
            drawing.currentStrokeColor = currentColor
        }
        
        presentingVC.setColorButton(to : currentColor)
        dismiss(animated: true, completion: nil)
    }
    
    func valuePicked(_ color: UIColor, type: SwiftHUEColorPicker.PickerType) {
        colorView.backgroundColor = color
        currentColor = color
        
        switch type {
        case .color:
            verticalBrightnessPicker.currentColor = color
            verticalSaturationPicker.currentColor = color
            break
        case .brightness:
            horizontalColorPicker.currentColor = color
            verticalSaturationPicker.currentColor = color
            break
        case .saturation:
            horizontalColorPicker.currentColor = color
            verticalBrightnessPicker.currentColor = color
        default :
            break
        }
    }
}

