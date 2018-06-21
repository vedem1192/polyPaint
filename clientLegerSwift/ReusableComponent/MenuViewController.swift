//
//  MenuViewController.swift
//  clientLegerSwift
//
//  Created by veronique demers on 18-02-19.
//  Copyright © 2018 log3900. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var menu: RoundButton!
    @IBOutlet weak var home: RoundButton!
    @IBOutlet weak var draw: RoundButton!
    @IBOutlet weak var chat: RoundButton!
    
    let drawingPageVC = "<clientLegerSwift.DrawingPageViewControl"
    
    var destinationLocation: [CGPoint] = []
    var movingButtons: [RoundButton] = []
    
    let settings = SettingDrawingSetter.instance
    var isMenuOpen = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        destinationLocation = [home.center, draw.center, chat.center]
        movingButtons = [home, draw, chat]
        centerButtons()
    }

    private func centerButtons() {
        for i in 0..<movingButtons.count {
            movingButtons[i].alpha = 0
            movingButtons[i].center = menu.center
        }
    }

    @IBAction func menuWasPressed(_ sender: RoundButton) {

        if !isMenuOpen {
            sender.set(background: #colorLiteral(red: 0.658308804, green: 0.8193534017, blue: 0.9075077176, alpha: 1))
            expandButtons()
        }
        else {
            sender.set(background: .white)
            collapseButtons()
        }
        isMenuOpen.toogle()
    }
    
    @IBAction func homeWasPressed(_ sender: RoundButton) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyboard.instantiateViewController(withIdentifier: "galleryPage")
        
        // logout from drawing
        if String(describing : UIApplication.topViewController()!).prefix(40) == drawingPageVC {
            leavingDrawingPageVC()
        }
        
        self.present(newViewController, animated: true, completion: nil)
    }
    
    @IBAction func drawWasPressed(_ sender: RoundButton) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let drawingViewController = storyboard.instantiateViewController(withIdentifier: "drawingPage") as! DrawingPageViewController
        let settingViewController = storyboard.instantiateViewController(withIdentifier: "settingPage") as! SettingDrawingViewController
        
        var newViewController : UIViewController?
        if settings.needsSetting {
            menu.sendActions(for: .touchUpInside)
            newViewController = settingViewController 
        }
        else {
            if settings.drawingMode {
                drawingViewController.drawingMode = Mode.Pixel
            }
            else {
                drawingViewController.drawingMode = Mode.Line
            }
            newViewController = drawingViewController
        }
        
        // prevent reload of the same view controller
        if String(describing: newViewController!).prefix(40) != String(describing : UIApplication.topViewController()!).prefix(40) {
            self.present(newViewController!, animated: true, completion: nil)
        }
        else {
            menu.sendActions(for: .touchUpInside)
        }
    }
    
    @IBAction func chatWasPressed(_ sender: RoundButton) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyboard.instantiateViewController(withIdentifier: "roomSelectionPage") as! RoomViewController
        
        // logout from drawing
        if String(describing : UIApplication.topViewController()!).prefix(40) == drawingPageVC {
            leavingDrawingPageVC()
        }
        
        // prevent reload of the same view controller
        if String(describing: newViewController).prefix(30) != String(describing : UIApplication.topViewController()!).prefix(30) {
            self.present(newViewController, animated: true, completion: nil)
        }
        else {
            menu.sendActions(for: .touchUpInside)
        }
    }
    
    private func leavingDrawingPageVC() {
        let vc = UIApplication.topViewController() as! DrawingPageViewController
        vc.stopTimer()
        vc.setting.needsSetting = true
        vc.drawingManager.leaveDrawingSession(leavingUser: vc.drawingManager.networkManager.username)
        
        // clean canvas on leave. Do not notify server
        if vc.drawingMode == Mode.Line {
            vc.drawing.cleanCanvas()
        }
    }
    
    private func triggerMenuAnimation(alpha : CGFloat) {
        UIView.animate(withDuration: 0.3) {
            for i in 0..<self.movingButtons.count {
                self.movingButtons[i].alpha = alpha
                self.movingButtons[i].center = alpha == 1 ? self.destinationLocation[i] : self.menu.center
            }
        }
    }
    
    private func expandButtons() {
        triggerMenuAnimation(alpha: 1)
    }
    
    private func collapseButtons() {
        triggerMenuAnimation(alpha: 0)
    }
    
}


extension Bool {
    mutating func toogle() {
        self = !self
    }
}

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

