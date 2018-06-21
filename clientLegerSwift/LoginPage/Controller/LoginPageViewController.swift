//
//  ViewController.swift
//  clientLegerSwift
//
//  Created by veronique demers on 18-01-30.
//  Copyright © 2018 log3900. All rights reserved.
//

import UIKit
import AVFoundation

class LoginPageViewController : UIViewController {
    
    let networkManager = NetworkManager.instance
    let loginManager = LoginManager.loginInstance
    let drawingManager = DrawingManager.drawingInstance
    var isNetworkSetup = false
    
    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet weak var warningMessage: UILabel!
    
    @IBOutlet weak var serverButtonView: UIView!
    @IBOutlet weak var serverIP: UITextField!
    
    var audioPlayer : AVAudioPlayer!

    @IBOutlet weak var welcomeLabel: UILabel!
    let fbLoginButton: FBSDKLoginButton = {
        let button = FBSDKLoginButton()
        button.frame.size = CGSize(width: 257, height: button.frame.height)
        button.readPermissions = ["email"]
        return button
    }()
    //- - - - - - - - - - - - - - - - - -//
    
    override func viewDidLoad() {
        super.viewDidLoad()
        facebookLogin()
        
        welcomeLabel.alpha = 0
        username.delegate = self
        password.delegate = self
        serverIP.delegate = self
        
        serverButtonView.layer.cornerRadius = 16
        audioPlayer = try? AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "connectionError", ofType: "mp3")!))
        audioPlayer.prepareToPlay()
    }
    
    private func facebookLogin() {
        view.addSubview(fbLoginButton)
        fbLoginButton.center = CGPoint(x: view.center.x, y: view.center.y + 50)
        fbLoginButton.delegate = self
        
        if let token = FBSDKAccessToken.current() {
            fetchProfile()
        }

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        networkManager.loginDelegate = self 
        
        warningMessage.text = ""
        serverIP.isHidden = true
        
    }
    
    @IBAction func showServerIpField(_ sender: Any) {
        serverIP.isHidden = false
        serverButtonView.layer.backgroundColor = #colorLiteral(red: 0.9699423909, green: 0.9142425656, blue: 0.628785193, alpha: 1)
        //see if it works
        networkManager.stopChatSession()
        isNetworkSetup = false
    }
    

    func connectClientToServer() {
        //Hardcoded IP adress
        serverIP.text = "159.203.59.128"
//        serverIP.text = "10.200.8.49"
        networkManager.ip = serverIP.text!
        print(networkManager.ip)
        if !isNetworkSetup{
            networkManager.setupNetworkCommunication()
            isNetworkSetup = true
        }
        
        serverIP.isHidden = true
    }
    
    @IBAction func loginRequest(_ sender: Any) {
        verifyLoginData()
    }
    
    func verifyLoginData() {
        let username = self.username.text
        let password = self.password.text
        
        if(username == "" || password == ""){
            audioPlayer.play()
            warningMessage.text = "Please enter login information"
            return
        }
        else if !isNetworkSetup {
            audioPlayer.play()
            warningMessage.text = "Please enter your server's IP address"
            serverButtonView.layer.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            return
        }
        
        logUser(username!, password!)
    }
    
    func logUser(_ user: String, _ psw: String) {
        loginManager.authenticate(username: user, password: psw)
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        // if not manually forced to false, the segue if
        // performed event is message._confirmed is false
        return false
    }
}

extension LoginPageViewController : NetworkManagerDelegate {
    
    func receivedMessage(message: Message) {
        print("Got login delegate message: ")
        print(message)
        if let msg = loginManager.processAuthenticateMessage(message: message){
            if msg._confirmed {
                print(username.text!)
                networkManager.username = username.text!
                performSegue(withIdentifier: "connectionIdentifier", sender: nil)
            } else {
                audioPlayer!.play()
                warningMessage.text = "Username already in use"
            }
        }
    }
}
