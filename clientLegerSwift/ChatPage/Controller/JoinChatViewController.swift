//
//  ViewController.swift
//  clientLegerSwift
//
//  Created by veronique demers on 18-01-30.
//  Copyright © 2018 log3900. All rights reserved.
//

import UIKit

class JoinChatViewController : UIViewController {
    
    let networkManager = NetworkManager()
    var isNetworkSetup = false
    
    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet weak var warningMessage: UILabel!
    
    @IBOutlet weak var serverButtonView: UIView!
    @IBOutlet weak var serverIP: UITextField!
    
    
    //- - - - - - - - - - - - - - - - - -//
    
    override func viewDidLoad() {
        super.viewDidLoad()
        username.delegate = self
        password.delegate = self
        serverIP.delegate = self
        
        serverButtonView.layer.cornerRadius = 16
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        networkManager.delegate = self
        
        warningMessage.text = ""
        serverIP.isHidden = true
        
    }
    
    @IBAction func showServerIpField(_ sender: Any) {
        serverIP.isHidden = false
        serverButtonView.layer.backgroundColor = #colorLiteral(red: 0.9699423909, green: 0.9142425656, blue: 0.628785193, alpha: 1)
    }
    
    func connectClientToServer() {
        networkManager.ip = serverIP.text!
        
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
            warningMessage.text = "Please enter login information"
            return
        }
        else if !isNetworkSetup {
            warningMessage.text = "Please enter your server's IP address"
            serverButtonView.layer.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            return
        }
        
        logUser(username!, password!)
    }
    
    func logUser(_ user: String, _ psw: String) {
        networkManager.joinChat(username: user)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        // if not manually forced to false, the segue if
        // performed event is message._confirmed is false
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ChatRoomViewController{
            destination.username = username.text
            destination.networkManager = networkManager
            destination.networkManager.delegate = destination
        }
    }
}

extension JoinChatViewController : NetworkManagerDelegate {
    func receivedMessage(message: Message) {
        if let msg = message._confirmed {
            if msg {
                networkManager.username = username.text!
                usleep(200)
                performSegue(withIdentifier: "connectionIdentifier", sender: nil)
            } else {
                warningMessage.text = "Username already in use"
            }
        }
    }
}
