//
//  EyeDropper.swift
//  clientLegerSwift
//
//  Created by veronique demers on 18-04-04.
//  Copyright © 2018 log3900. All rights reserved.
//

import UIKit
import SpriteKit

class EyeDropper : UIView {
    
    let nibName = "EyeDropperView"
    var contentView:UIView?
    
    @IBOutlet weak var colorDisplayView: RoundView!
    @IBOutlet weak var hexaLabel: UILabel!
    @IBOutlet weak var rgbLabel: UILabel!
    @IBOutlet weak var cmykLabel: UILabel!
    
    @IBOutlet weak var selectButton: RoundButton!
    @IBOutlet weak var cancelButton: RoundButton!
    
    var isSelected = false
    var pixelDrawing : PixelDrawing!
    
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
        if pixelDrawing == nil {
            pixelDrawing = PixelDrawing.instance
        }
        self.layer.cornerRadius = 10
        UIView.animate(withDuration: 0.75) {
            self.alpha = 1
        }
        
        updateColor(color : pixelDrawing.currentStrokeColor)
    }
    
    func updateColor( color : UIColor ) {

        // color display
        colorDisplayView.backgroundColor = color
        
        // labels
        let rgb = color.rgb()
        rgbLabel.text = "\(rgb!.red) , \(rgb!.green) , \(rgb!.blue)"
        
        hexaLabel.text = "#\(color.toHexString)"
        
        let cmyk = color.cmyk()!
        cmykLabel.text = "\(cmyk.c)% , \(cmyk.y)% , \(cmyk.m)% , \(cmyk.k)%"
        
    }
    
    func hide() {
        UIView.animate(withDuration: 0.3) {
            self.alpha = 0
        }
    }
    
    @IBAction func selectWasPressed(_ sender: RoundButton) {
        pixelDrawing.currentStrokeColor = colorDisplayView.backgroundColor!
        
        let parentVC = self.parentViewController
        parentViewController?.colorButton.backgroundColor = colorDisplayView.backgroundColor
        
        pixelDrawing.currentState = PixelDrawing.State.Draw
        hide()
    }
    
    @IBAction func cancelWasPressed(_ sender: Any) {
        pixelDrawing.currentState = PixelDrawing.State.Draw
        hide()
    }
    
}

extension UIColor {

    func rgb() -> (red:Int, green:Int, blue:Int, alpha:Int)? {
        var fRed : CGFloat = 0
        var fGreen : CGFloat = 0
        var fBlue : CGFloat = 0
        var fAlpha: CGFloat = 0
        if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
            let iRed = Int(fRed * 255.0)
            let iGreen = Int(fGreen * 255.0)
            let iBlue = Int(fBlue * 255.0)
            let iAlpha = Int(fAlpha * 255.0)

            return (red:iRed, green:iGreen, blue:iBlue, alpha:iAlpha)
        } else {
            return nil
        }
    }
    
    var toHexString: String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        return String(
            format: "%02X%02X%02X",
            Int(r * 0xff),
            Int(g * 0xff),
            Int(b * 0xff)
        )
    }
    
    func cmyk() -> (c:Int, m:Int, y:Int, k:Int)? {
        let cmyk = self.cgColor.converted(to: CGColorSpaceCreateDeviceCMYK(), intent: CGColorRenderingIntent.defaultIntent, options: nil)!
        let c = Int(cmyk.components![0] * 100)
        let m = Int(cmyk.components![1] * 100)
        let y = Int(cmyk.components![2] * 100)
        let k = Int(cmyk.components![3] * 100)
        
        return (c,m,y,k)
        
    }
}


extension EyeDropper {
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

