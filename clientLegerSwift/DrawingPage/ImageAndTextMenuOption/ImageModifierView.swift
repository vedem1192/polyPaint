//
//  ImageModifierView.swift
//  clientLegerSwift
//
//  Created by veronique demers on 18-04-06.
//  Copyright © 2018 log3900. All rights reserved.
//

import UIKit

class ImageModifierView : UIView {
    
    let nibName = "ImageModifierView"
    var contentView:UIView?
    
    var pixelDrawing : PixelDrawing!
    let lineDrawing = LineDrawing.instance
    
    @IBOutlet weak var alphaOptionView: UIView!
    @IBOutlet weak var alphaValueLabel: UILabel!
    @IBOutlet weak var alphaSlider: UISlider!
    @IBOutlet weak var alphaDisplaySquare: UIView!
    
    @IBOutlet weak var acceptButton: RoundButton!
    @IBOutlet weak var cancelButton: RoundButton!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        contentView = view
    }
    
    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    func show() {
        if parentViewController?.drawingMode == .Pixel {
            alphaOptionView.alpha = 1
            alphaDisplaySquare.alpha = 1
            alphaSlider.value = Float(100)
        }
        
        UIView.animate(withDuration: 0.75) {
            self.alpha = 1
        }
    }
    
    func hide() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }, completion: { finished in
            if self.parentViewController!.drawingMode == Mode.Pixel {
                self.updateCanvas()
            }
        })
    }
    
    @IBAction func alphaChanged(_ sender: UISlider) {
        alphaValueLabel.text = String(Int(sender.value))
        alphaDisplaySquare.alpha = CGFloat(sender.value)/100
        
        pixelDrawing = PixelDrawing.instance
        pixelDrawing.currentModifiengImage.alpha = alphaDisplaySquare.alpha
    }
    
    @IBAction func acceptWasPressed(_ sender: Any) {
        // alpha 0 -> drawingMode = .Line
        if alphaOptionView.alpha == 0 {
            lineDrawing.currentState = LineDrawing.State.Draw
            lineDrawing.changes(accepted: true)
        }
        else {
            pixelDrawing = PixelDrawing.instance
            pixelDrawing.currentState = PixelDrawing.State.Draw
            pixelDrawing.currentModifiengImage.alpha = alphaDisplaySquare.alpha
        }
        self.hide()
    }
    
    private func updateCanvas() {
        parentViewController?.prepareCanvas()
        let image = pixelDrawing.currentContext()
        parentViewController?.restoreCanvas()
        
        parentViewController?.imageview.image = image
        pixelDrawing.currentModifiengImage.removeFromSuperview()
    }
    
    @IBAction func cancelWasPressed(_ sender: Any) {
        // alpha 0 -> drawingMode = .Line
        if alphaOptionView.alpha == 0 {
            lineDrawing.currentState = LineDrawing.State.Draw
            lineDrawing.changes(accepted: false)
        }
        else {
            pixelDrawing = PixelDrawing.instance
            pixelDrawing.currentState = PixelDrawing.State.Draw
            pixelDrawing.currentModifiengImage.removeFromSuperview()
        }
        self.hide()
    }
}

extension ImageModifierView {
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


