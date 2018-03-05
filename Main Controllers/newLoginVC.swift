//
//  newLoginController.swift
//  Habits
//
//  Created by Ahsan Vency on 2/28/18.
//  Copyright © 2018 ahsan vency. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import SwiftKeychainWrapper

class newLoginVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var screenTitle: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID){
            performSegue(withIdentifier: "toMain", sender: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        setupScreen()
        
        self.hideKeyboardWhenTappedAround()
    }
    
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
    
    
    @IBAction func facebookLogin(_ sender: Any) {
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
                        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let newViewController = storyBoard.instantiateViewController(withIdentifier: "MainScreenViewCID") as! MainScreenViewC
                        self.present(newViewController, animated: true, completion: nil)
                    }
                })
            }
        }
    }
    
    func completeSignIn(id: String){
        KeychainWrapper.standard.set(id, forKey: KEY_UID);
    }
    
    
    func setupScreen(){
        let myGradient = UIImage(named: "textMainLogin.png")
        screenTitle.textColor = UIColor(patternImage: myGradient ?? UIImage())
        
        emailField.layer.borderWidth = 0
        passwordField.layer.borderWidth = 0
        emailField.textColor = satinColor
        passwordField.textColor = satinColor
        emailField.backgroundColor = seaFoamColor
        passwordField.backgroundColor = seaFoamColor
        emailField.attributedPlaceholder = NSAttributedString(string: "Email",
                                                              attributes: [NSAttributedStringKey.foregroundColor: satinColor])
        passwordField.attributedPlaceholder = NSAttributedString(string: "Password",
                                                                 attributes: [NSAttributedStringKey.foregroundColor: satinColor])
        passwordField.isSecureTextEntry = true
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
