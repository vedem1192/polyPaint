//
//  SettingDrawingMenuViewController.swift
//  clientLegerSwift
//
//  Created by lea el hage on 2018-03-28.
//  Copyright © 2018 log3900. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class SettingDrawingViewController: UITableViewController {
    
    @IBOutlet weak var protectedSwitch: UISwitch!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passConfField: UITextField!
    @IBOutlet weak var visibilitySeg: UISegmentedControl!
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var confirm: UIButton!
    @IBOutlet weak var drawingSeg: UISegmentedControl!
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var visibilityView: UIView!
    @IBOutlet weak var drawingOptionView: UIView!
    
    
    let setting = SettingDrawingSetter.instance
    let drawingManager = DrawingManager.drawingInstance
    var audioPlayer : AVAudioPlayer!
    var confirmed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioPlayer = try? AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "connectionError", ofType: "mp3")!))
        audioPlayer.prepareToPlay()
    
        if !setting.needsSetting {
            titleField.text = setting.title
            titleField.isUserInteractionEnabled = false
            titleField.backgroundColor = .white
            titleView.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
            
            drawingSeg.selectedSegmentIndex = setting.drawingMode == true ? 0 : 1
            drawingSeg.isUserInteractionEnabled = false
            drawingSeg.backgroundColor = .white
            drawingOptionView.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
            
            visibilitySeg.selectedSegmentIndex = setting.password.isEmpty ? 1 : 0
            visibilitySeg.isUserInteractionEnabled = false
            visibilitySeg.backgroundColor = .white
            visibilityView.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
            
            protectedSwitch.isOn = setting.password.isEmpty
            
        }
    }
    
    @IBAction func logoutWasPressed(_ sender: Any) {
        // ASK SIMON
        let networkManager = NetworkManager.instance
        
        let loginManager = LoginManager()
        loginManager.quitApp()
        networkManager.stopChatSession()
        performSegue(withIdentifier: "logoutFromSettings", sender: nil)
    }
    
    @IBAction func cancelWasPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func visibilitySwitch(_ sender: Any) {
        //private
        if visibilitySeg.selectedSegmentIndex == 1 {
            protectedSwitch.setOn(false, animated: false)
            protectedSwitch.isEnabled = false
            
            passwordField.isEnabled = false
            passConfField.isEnabled = false
            
            setting.visibility = false
            setting.protected = false
        }
        //public
        else {
            protectedSwitch.setOn(true, animated: true)
            protectedSwitch.isEnabled = true
            
            passwordField.isEnabled = true
            passConfField.isEnabled = true
            
            setting.visibility = true
            setting.protected = true
        }
    }
    
    @IBAction func protectedChanged(_ sender: Any) {
        setting.protected = protectedSwitch.isOn
        if protectedSwitch.isOn {
            passwordField.isEnabled = true
            passConfField.isEnabled = true
            setting.protected = true
        }
        else{
            passwordField.isEnabled = false
            passConfField.isEnabled = false
            setting.protected = false
        }
    }
    
    @IBAction func passChanged(_ sender: Any) {
        setting.password = passwordField.text!
        setting.passConf = ""
        passConfField.text = ""
    }
    
    @IBAction func passConfChanged(_ sender: Any) {
        setting.passConf = passConfField.text!
        if (!setting.passConfirmation()){
            passwordField.text = nil
            setting.password = ""
            passConfField.text = nil
            setting.passConf = ""
        }
    }
    
    @IBAction func titleChanged(_ sender: Any) {
        setting.title = titleField.text!
        confirm.isHidden = !setting.confirmSetting()
    }

    @IBAction func confirmeWasPressed(_ sender: Any) {
        if informationsAreCorrect() {
            goToDrawingPage()
        }
    }
    
    private func informationsAreCorrect() -> Bool {
        // check title
        if let title = titleField.text {
            let trimTittle = title.trimmingCharacters(in: .whitespacesAndNewlines)
            if trimTittle.isEmpty {
                warningMessage(field: titleField, message: "Please enter a valid title")
                return false
            }
            setting.title = trimTittle
        }
        
        // check password
        let visibility = visibilitySeg.titleForSegment(at: visibilitySeg.selectedSegmentIndex)
        if  visibility == "Public" && protectedSwitch.isOn {
            if passwordField.text != passConfField.text {
                warningMessage(field: passConfField, message: "Must matches password")
                return false
            }
            if let password = passwordField.text?.trimmingCharacters(in: .whitespaces), password.isEmpty {
                warningMessage(field: passwordField, message: "Enter password")
                return false
            }
            setting.password = passwordField.text!
        }
        return true
    }
    
    private func warningMessage(field : UITextField, message : String) {
        audioPlayer.play()
        field.layer.borderColor = #colorLiteral(red: 1, green: 0.374024868, blue: 0.3451677859, alpha: 1)
        field.layer.borderWidth = 2
        field.text = ""
        field.attributedPlaceholder = NSAttributedString(string: message,
                                                         attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 1, green: 0.374024868, blue: 0.3451677859, alpha: 1)])
    }
    
    private func goToDrawingPage() {
        if setting.needsSetting {
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let drawingViewController = storyboard.instantiateViewController(withIdentifier: "drawingPage") as! DrawingPageViewController
            
            let mode = drawingSeg.titleForSegment(at: drawingSeg.selectedSegmentIndex)!
            drawingViewController.drawingMode = mode == "Pixel" ? Mode.Pixel : Mode.Line
            setting.needsSetting = false
            setting.drawingMode = mode == "Pixel"

            self.present(drawingViewController, animated: true, completion: nil)
            setting.createDrawing()
        }
        else {
            dismiss(animated: true, completion: nil)
            // HELP SIMON
            // send update message!
        }
    }
}
