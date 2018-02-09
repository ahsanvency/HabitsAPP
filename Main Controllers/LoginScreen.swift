//
//  LoginScreen.swift
//  Habits
//
//  Created by ahsan vency on 1/1/18.
//  Copyright © 2018 ahsan vency. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import SwiftKeychainWrapper

class LoginScreen: UIViewController {
    
    //Outlets
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordField.isSecureTextEntry = true
    }
    
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //Makes a function a lot easier to handle
    func upAlert (messages: String) {
        let myAlert = UIAlertController(title: "Alert", message: messages, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true, completion: nil)
    }
    
    func loginSuccess (messages: String) {
        let myAlert = UIAlertController(title: "Alert", message: "Logged In", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (alertAction: UIAlertAction) in
            self.performSegue(withIdentifier: "toMain", sender: nil)
        })
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true, completion: nil)
    }


    
    @IBAction func facebookBtn(_ sender: Any) {
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error == nil {
                self.loginSuccess(messages: "Logged In");
            }
            let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            self.firebaseAuth(credential)
        }
    }
    func firebaseAuth(_ credential: AuthCredential){
        Auth.auth().signIn(with: credential) { (user, error) in
            if let user = user {
                let userData = ["provider" : credential.provider]
                self.completeSignIn(id: user.uid);
            }
        }
    }
    
    
    @IBAction func loginButton(_ sender: Any) {
        if let email = emailField.text, let pwd = passwordField.text{
            if (email.isEmpty || pwd.isEmpty){
                upAlert(messages: "All Fields must be filled in")
            } else {
                Auth.auth().signIn(withEmail: email, password: pwd, completion: { (user, error) in
                    if error != nil {
                        self.upAlert(messages: "User Not Found")
                    }else {
                        if let user = user {
                            self.completeSignIn(id: user.uid)
                        }
                        self.loginSuccess(messages: "Logged In")
                    }
                })
            }
        }
    }
    
    func completeSignIn(id: String){

        KeychainWrapper.standard.set(id, forKey: KEY_UID);
    }
    
}
