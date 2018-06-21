//
//  LoginPageViewControllerExtension.swift
//  clientLegerSwift
//
//  Created by veronique demers on 18-04-07.
//  Copyright © 2018 log3900. All rights reserved.
//

import Foundation

extension LoginPageViewController : FBSDKLoginButtonDelegate {
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        print("completed login")
        fetchProfile()
    }
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("logOut")
        hideWelcomeLabel()
        self.username.text = ""
        self.password.text = ""
        
    }
    
    func fetchProfile() {
        print("fetch profile")
        
        let parameters = ["fields" : "email, first_name, last_name, id"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).start { (connection, result, error) in
            if error != nil {
                print(error!)
                return
            }
            let data:[String:AnyObject] = result as! [String : AnyObject]
            
            let first_name = data["first_name"] as! String
            let last_name = data["last_name"] as! String
            let id = data["id"] as! String
            
            var login : String!
            if first_name.count + last_name.count > 20 {
                login = first_name + String(last_name.prefix(1)) + "."
            }
            else {
                login = "\(first_name)\(last_name)"
            }
            
            self.setLoginInformation(with: login, and : id)
            self.animateWelcomeLabel(with: first_name)
        }
    }
    
    private func setLoginInformation(with name : String, and id : String) {
        self.username.text = name
        self.password.text = String(id.prefix(20))
    }
    
    private func animateWelcomeLabel(with name : String) {
        self.welcomeLabel.text = "Welcome \(name)"
        
        let endPoint = CGPoint(x: 384.0, y: 263.5)
        self.welcomeLabel.center = CGPoint(x: endPoint.x, y: endPoint.y - 150)
        
        self.welcomeLabel.enterScreen()
    }
    
    private func hideWelcomeLabel() {
        self.welcomeLabel.leaveScreen()
    }
    
}

extension UILabel {
    func enterScreen() {
        UILabel.animate(withDuration: 1.25, animations: {
            self.alpha = 1
            self.transform = CGAffineTransform(translationX: 0, y: 150)
        })
    }
    
    func leaveScreen() {
        UILabel.animate(withDuration: 1.25, animations: {
            self.alpha = 0
            self.transform = CGAffineTransform(translationX: 0, y: -150)
        })
    }
}
