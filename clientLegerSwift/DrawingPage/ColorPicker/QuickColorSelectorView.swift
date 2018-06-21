//
//  QuickColorSelectorView.swift
//  clientLegerSwift
//
//  Created by veronique demers on 18-04-06.
//  Copyright © 2018 log3900. All rights reserved.
//

import UIKit

class QuickColorSelectorView : UIView, SwiftHUEColorPickerDelegate {

    let nibName = "QuickColorSelectorView"
    var contentView:UIView?
    var initialImage : UIImage!
    var tempImg : [UIImageView] = []
    
    var pixelDrawing : PixelDrawing!
    @IBOutlet weak var horizontalColorPicker: SwiftHUEColorPicker!
    var currentColor : UIColor!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        contentView = view
        horizontalColorPicker.delegate = self
    }
    
    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    func show() {
        pixelDrawing = PixelDrawing.instance
        initialImage = parentViewController?.imageview.image
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
        }
    }
    
    func hide() {
        pixelDrawing = PixelDrawing.instance
        pixelDrawing.selectionByColorThreshold = 0
        
        UIView.animate(withDuration: 0.3) {
            self.alpha = 0
        }
    }
    
    @IBAction func okWasPressed(_ sender: Any) {
        pixelDrawing.currentState = PixelDrawing.State.Draw
        
        // TODO : Send to server
        
        pixelDrawing.selectedPixels.removeAll()
        self.hide()
    }
    
    @IBAction func cancelWasPressed(_ sender: Any) {
        parentViewController?.imageview.image = initialImage
        
        pixelDrawing.currentState = PixelDrawing.State.Draw
        pixelDrawing.selectedPixels.removeAll()
        self.hide()
    }
    
    func valuePicked(_ color: UIColor, type: SwiftHUEColorPicker.PickerType) {
        let parentVC = parentViewController
        let newImage = pixelDrawing.changeSelectedPixelsColor(to: color, from: parentVC!.imageview.image!)
        parentVC?.imageview.image! = newImage!
    }
    

    
}

extension QuickColorSelectorView {
    var parentViewController: DrawingPageViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? DrawingPageViewController {
                return viewController
            }
        }
        return nil
    }
}
