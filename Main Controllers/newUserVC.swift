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

class newUserVC: UIViewController {
    
    //Outlets
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        setupScreen()
        
        self.hideKeyboardWhenTappedAround()
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
    
    //Handles the registration of the text field
    @IBAction func createAccountButton(_ sender: Any) {
        //Makes sure all the textfields have a value
        if let email = emailField.text, let pwd = passwordField.text, let name = nameField.text, let pwd2 = confirmPasswordField.text {
            if (email.isEmpty || name.isEmpty || pwd.isEmpty || pwd2.isEmpty) {
                
                upAlert(messages: "All fields must be filled in.")
                
            } else if pwd != pwd2 {
                
                upAlert(messages: "Please enter the same passwords.")
                
            } else if !(validateEmail(enteredEmail: email)){ //If they enter an invalid email based off characters only
                upAlert(messages: "Please Enter a Valid Email")
            }
                //If everything else works the user will be created
            else {
                Auth.auth().createUser(withEmail: email, password: pwd, completion: { (user, error) in
                    //If there are no errors it will register the user
                    if error == nil {
                        if let user = user {
                            let userData = [ "name": name, "email" : email]
                            self.completeSignIn(id: user.uid, userData: userData as Dictionary<String, AnyObject>);
                            self.performSegue(withIdentifier: "toAdd", sender: nil)
                        }
                        
                    } else {//If the password was too short
                        if pwd.count < 6{
                            self.upAlert(messages: "Please Enter a Valid Pasword");
                        }else {//If the account already exists
                            self.upAlert(messages: "Account Already Exists");
                        }
                    }
                })
            }
        }
    }
    //Function that makes completing the sign in easier
    func completeSignIn(id: String, userData: Dictionary<String, AnyObject>){
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        KeychainWrapper.standard.set(id, forKey: KEY_UID);
    }
    
    func setupScreen(){
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
                self.view.frame.origin.y -= (keyboardSize.height - 75)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += (keyboardSize.height - 75)
            }
        }
    }
}

