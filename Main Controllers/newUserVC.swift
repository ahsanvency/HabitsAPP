//
//  newUserVC.swift
//  Habits
//
//  Created by Ahsan Vency on 3/28/18.
//  Copyright © 2018 ahsan vency. All rights reserved.
//


import UIKit
import Firebase
import SwiftKeychainWrapper
import TransitionButton

class newUserVC: UIViewController {
    
    //Outlets
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    
    let button = TransitionButton(frame: CGRect(x: 30, y: 557, width: 315, height: 50))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        setupScreen()
        
        self.hideKeyboardWhenTappedAround()
    }
    
    
    @IBAction func buttonAction(_ button: TransitionButton) {
        button.startAnimation() // 2: Then start the animation when the user tap the button
        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
        backgroundQueue.async(execute: {
            
            sleep(UInt32(2.0)); // 3: Do your networking task or background work here.
            
            DispatchQueue.main.async(execute: { () -> Void in
                
                if let email = self.emailField.text, let pwd = self.passwordField.text, let name = self.nameField.text, let pwd2 = self.confirmPasswordField.text {
                    if (email.isEmpty || name.isEmpty || pwd.isEmpty || pwd2.isEmpty) {
                        
                        self.upAlert(messages: "All fields must be filled in.")
                        button.stopAnimation()
                        
                    } else if pwd != pwd2 {
                        
                        self.upAlert(messages: "Please enter the same passwords.")
                        button.stopAnimation()
                        
                    } else if !(validateEmail(enteredEmail: email)){ //If they enter an invalid email based off characters only
                        self.upAlert(messages: "Please Enter a Valid Email")
                        button.stopAnimation()
                    }
                        //If everything else works the user will be created
                    else {
                        Auth.auth().createUser(withEmail: email, password: pwd, completion: { (user, error) in
                            //If there are no errors it will register the user
                            if error == nil {
                                if let user = user {
                                    let userData = [ "name": name, "email" : email]
                                    self.completeSignIn(id: user.uid, userData: userData as Dictionary<String, AnyObject>);
                                    button.stopAnimation(animationStyle: .expand, completion: {
                                        self.performSegue(withIdentifier: "toAdd", sender: nil)
                                    })
                                }
                            } else {//If the password was too short
                                if pwd.count < 6{
                                    self.upAlert(messages: "Passwords Must Be 6+ Characters");
                                    button.stopAnimation()
                                }else {//If the account already exists
                                    self.upAlert(messages: "Account Already Exists");
                                    button.stopAnimation()
                                }
                            }
                        })
                    }
                }
            })
        })
    }
    
    @IBAction func goBack(_ sender: Any) {
        
        view.window?.layer.add(leftTransition(duration: 0.5), forKey: nil)
        dismiss(animated: false, completion: nil)
    }
    
    
    //This function will be called everytime there is an error with the values the user entered. The message determining the error will be passed through to the function and displayed on the screen.
    func upAlert (messages: String) {
        let myAlert = UIAlertController(title: "Alert", message: messages, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true, completion: nil)
    }
    
    //Function that makes completing the sign in easier
    func completeSignIn(id: String, userData: Dictionary<String, AnyObject>){
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        KeychainWrapper.standard.set(id, forKey: KEY_UID);
    }
    
    func setupScreen(){
        self.view.addSubview(button)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20).isActive = true
        button.topAnchor.constraint(equalTo: confirmPasswordField.bottomAnchor, constant: 20).isActive = true
        
        button.backgroundColor = .white
        button.setTitle("Create Account", for: .normal)
        button.titleLabel?.font =  UIFont(name: "D-DIN-Bold", size: 20)
        button.cornerRadius = 8.0
        button.spinnerColor = .white
        button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        buttonGradient(button: button)
        
        
        nameField.attributedPlaceholder = NSAttributedString(string: "Name",
                                                             attributes: [NSAttributedStringKey.foregroundColor: blueColor])
        emailField.attributedPlaceholder = NSAttributedString(string: "Email",
                                                              attributes: [NSAttributedStringKey.foregroundColor: blueColor])
        passwordField.attributedPlaceholder = NSAttributedString(string: "Password",
                                                                 attributes: [NSAttributedStringKey.foregroundColor: blueColor])
        confirmPasswordField.attributedPlaceholder = NSAttributedString(string: "Confirm Password",
                                                                        attributes: [NSAttributedStringKey.foregroundColor: blueColor])
        passwordField.isSecureTextEntry = true
        confirmPasswordField.isSecureTextEntry = true
        nameField.autocorrectionType = .no
        emailField.autocorrectionType = .no
        nameField.textContentType = UITextContentType("")
        emailField.textContentType = UITextContentType("")
        passwordField.textContentType = UITextContentType("")
        confirmPasswordField.textContentType = UITextContentType("")
        emailField.keyboardType = .emailAddress
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= (keyboardSize.height - 60)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += (keyboardSize.height - 60)
            }
        }
    }
}

