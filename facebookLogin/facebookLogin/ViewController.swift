//
//  ViewController.swift
//  facebookLogin
//
//  Created by veronique demers on 18-01-24.
//  Copyright © 2018 log3900. All rights reserved.
//

//https://www.youtube.com/watch?v=MNfrBdyEvmY
import UIKit

class ViewController: UIViewController {
    
    let loginButton: FBSDKLoginButton = {
        let button = FBSDKLoginButton()
        button.readPermissions = ["email"]
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(loginButton)
        loginButton.center = view.center
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

