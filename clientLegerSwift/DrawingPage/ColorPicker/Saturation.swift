//
//  Saturation.swift
//  clientLegerSwift
//
//  Created by veronique demers on 18-04-14.
//  Copyright © 2018 log3900. All rights reserved.
//

import UIKit

class Saturation : UIView {
    
    var pixelDrawing : PixelDrawing!
    
    let nibName = "Saturation"
    var contentView:UIView?
    var initialImage : UIImage!
    var pixels : [Int] = []
    
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
        pixelDrawing = PixelDrawing.instance
        initialImage = parentViewController?.imageview.image
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
        }
    }
    
    func hide() {
        pixelDrawing = PixelDrawing.instance
        UIView.animate(withDuration: 0.3) {
            self.alpha = 0
        }
    }
    
    @IBAction func okWasPressed(_ sender: Any) {
        pixelDrawing.currentState = PixelDrawing.State.Draw
        self.hide()
    }
    
    @IBAction func saturationChanged(_ sender: UIStepper) {
        let parentVC = parentViewController
        let newImage = pixelDrawing.changeImageSaturation(of: initialImage!, with: Int(sender.value))
        parentVC?.imageview.image! = newImage!
    }

}




extension Saturation {
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

