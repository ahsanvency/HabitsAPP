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

class LoginScreen: UIViewController, UITextFieldDelegate {
    
    //Outlets
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var logoPic: logoView!
    @IBOutlet weak var sloganLbl: UILabel!
    @IBOutlet weak var emailField: fancyField!
    @IBOutlet weak var passwordField: fancyField!
    @IBOutlet weak var loginBtn: fancyButton!
    @IBOutlet weak var forgotPasswordBtn: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        setupScreen()
        
        self.hideKeyboardWhenTappedAround()
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
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email","public_profile"], from: self) { (result, error) -> Void in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                if(fbloginresult.grantedPermissions.contains("email"))
                {
                    self.getFBUserData()
                    
                }
            }
        }
    }
    
    func getFBUserData(){
        let graphRequest:FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"first_name,email, picture.type(large)"])
        
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                print("Error: \(error)")
            }
            else
            {
                let data:[String:AnyObject] = result as! [String : AnyObject]
                print(data)
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)

                self.loginSuccess(messages: "Logged In");
            }
        })
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
    
    func setupScreen(){

        emailField.layer.borderWidth = 0
        passwordField.layer.borderWidth = 0
        passwordField.isSecureTextEntry = true
        forgotPasswordBtn.isHidden = true
        emailField.autocorrectionType = .no
        emailField.keyboardType = .emailAddress
        passwordField.textContentType = UITextContentType("")
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= (keyboardSize.height - 125)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += (keyboardSize.height - 125)
            }
        }
    }
}


