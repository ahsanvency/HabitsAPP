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
import DTTextField


//class newUserVC: UIViewController {
//
//    //Outlets
//
//    @IBOutlet weak var nameField: DTTextField!
//    @IBOutlet weak var emailField: DTTextField!
//    @IBOutlet weak var passwordField: DTTextField!
//    @IBOutlet weak var confirmPasswordField: DTTextField!
//
//
//
//    @IBOutlet weak var signIntoExistingAccount: UIButton!
//    @IBOutlet weak var backgroundLoginButton: roundedButton!
//
//
//
//    let button = TransitionButton()
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//
//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
//
//        setupScreen()
//
//        self.hideKeyboardWhenTappedAround()
//    }
//
//
//    @IBAction func buttonAction(_ button: TransitionButton) {
//        guard (validateData())else{
//            return
//        }
//
//        button.startAnimation() // 2: Then start the animation when the user tap the button
//        let qualityOfServiceClass = DispatchQoS.QoSClass.background
//        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
//        backgroundQueue.async(execute: {
//
//            sleep(UInt32(2.0)); // 3: Do your networking task or background work here.
//
//            DispatchQueue.main.async(execute: { () -> Void in
//                Auth.auth().createUser(withEmail: self.emailField.text!, password: self.passwordField.text!, completion: { (user, error) in
//                    //If there are no errors it will register the user
//                    if error == nil {
//                        if let user = user {
//                            let userData = [ "name": self.nameField.text!, "email" : self.emailField.text!, "profileImage": "https://firebasestorage.googleapis.com/v0/b/habitsapp-7ea48.appspot.com/o/myImage.png?alt=media&token=867310eb-eb88-40e1-932d-236ea372061c"]
//                            self.completeSignIn(id: user.uid, userData: userData as Dictionary<String, AnyObject>);
//                            button.stopAnimation(animationStyle: .expand, completion: {
//                                self.performSegue(withIdentifier: "toAdd", sender: nil)
//                            })
//                        }
//                    } else {//If the password was too short
//                        self.upAlert(messages: "Account Already Exists");
//                        button.stopAnimation()
//                    }
//                })
//            })
//        })
//    }
//
//    @IBAction func signIntoExistingAccount(_ sender: Any) {
//
//        view.window?.layer.add(leftTransition(duration: 0.5), forKey: nil)
//        dismiss(animated: false, completion: nil)
//    }
//
//
//    //This function will be called everytime there is an error with the values the user entered. The message determining the error will be passed through to the function and displayed on the screen.
//    func upAlert (messages: String) {
//        let myAlert = UIAlertController(title: "Alert", message: messages, preferredStyle: UIAlertControllerStyle.alert)
//        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
//        myAlert.addAction(okAction)
//        self.present(myAlert, animated: true, completion: nil)
//    }
//
//    //Function that makes completing the sign in easier
//    func completeSignIn(id: String, userData: Dictionary<String, AnyObject>){
//        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
//        KeychainWrapper.standard.set(id, forKey: KEY_UID);
//    }
//
//    func setupScreen(){
//
//        let placeHolderColor = blueColor
//
//        nameField.dtLayer.backgroundColor = UIColor.clear.cgColor
//        nameField.dtLayer.borderWidth = 0
//        nameField.textColor = placeHolderColor
//        nameField.floatPlaceholderActiveColor = placeHolderColor
//        nameField.floatPlaceholderColor = placeHolderColor
//        nameField.placeholderColor = placeHolderColor
//
//        emailField.dtLayer.backgroundColor = UIColor.clear.cgColor
//        emailField.dtLayer.borderWidth = 0
//        emailField.paddingYErrorLabel = 10
//        emailField.textColor = placeHolderColor
//        emailField.floatPlaceholderActiveColor = placeHolderColor
//        emailField.floatPlaceholderColor = placeHolderColor
//        emailField.placeholderColor = placeHolderColor
//
//        passwordField.dtLayer.backgroundColor = UIColor.clear.cgColor
//        passwordField.dtLayer.borderWidth = 0
//        passwordField.textColor = placeHolderColor
//        passwordField.floatPlaceholderActiveColor = placeHolderColor
//        passwordField.floatPlaceholderColor = placeHolderColor
//        passwordField.placeholderColor = placeHolderColor
//
//        confirmPasswordField.dtLayer.backgroundColor = UIColor.clear.cgColor
//        confirmPasswordField.dtLayer.borderWidth = 0
//        confirmPasswordField.textColor = placeHolderColor
//        confirmPasswordField.floatPlaceholderActiveColor = placeHolderColor
//        confirmPasswordField.floatPlaceholderColor = placeHolderColor
//        confirmPasswordField.placeholderColor = placeHolderColor
//
//        self.view.addSubview(button)
//        button.heightAnchor.constraint(equalTo: backgroundLoginButton.heightAnchor).isActive = true
//        button.leadingAnchor.constraint(equalTo: backgroundLoginButton.leadingAnchor, constant: 0).isActive = true
//        button.trailingAnchor.constraint(equalTo: backgroundLoginButton.trailingAnchor, constant: 0).isActive = true
//        button.topAnchor.constraint(equalTo: backgroundLoginButton.topAnchor, constant: 0).isActive = true
//
//        button.backgroundColor = .white
//        button.setTitle("Create Account", for: .normal)
//        button.titleLabel?.font =  UIFont(name: "D-DIN-Bold", size: 20)
//        button.cornerRadius = 25.0
//        button.spinnerColor = .white
//        button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
//        buttonGradient(button: button)
//
//
//
//        nameField.textContentType = UITextContentType("")
//        emailField.textContentType = UITextContentType("")
//        passwordField.textContentType = UITextContentType("")
//        confirmPasswordField.textContentType = UITextContentType("")
//        emailField.keyboardType = .emailAddress
//    }
//
//    @objc func keyboardWillShow(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            if self.view.frame.origin.y == 0{
//                self.view.frame.origin.y -= (keyboardSize.height - 40)
//            }
//        }
//    }
//
//    @objc func keyboardWillHide(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            if self.view.frame.origin.y != 0{
//                self.view.frame.origin.y += (keyboardSize.height - 40)
//            }
//        }
//    }
//}
//
//
//extension newUserVC{
//
//    func validateData() -> Bool {
//
//        guard nameField.text != "" else{
//            nameField.showError(message: "Please Enter Name.")
//            return false
//        }
//
//        guard emailField.text != "" else{
//            emailField.showError(message: "Please Enter Email.")
//            return false
//        }
//
//        guard validateEmail(enteredEmail: self.emailField.text!) else{
//            emailField.showError(message: "Please Enter Valid Email")
//            return false
//        }
//
//        guard (passwordField.text?.count)! > 5 else {
//            passwordField.showError(message: "Password must be atleast 6 characters")
//            return false
//        }
//
//        guard passwordField.text != "" else{
//            passwordField.showError(message: "Please Enter Password.")
//            return false
//        }
//
//        guard confirmPasswordField.text != "" else{
//            confirmPasswordField.showError(message: "Please Confirm Password.")
//            return false
//        }
//
//        guard passwordField.text == confirmPasswordField.text else{
//            confirmPasswordField.showError(message: "Passwords Must Match")
//            return false
//        }
//        return true
//    }
//
//}

class newUserVC: UIViewController, UITextFieldDelegate{

    //Outlets
    @IBOutlet weak var nameField: DTTextField!
    @IBOutlet weak var emailField: DTTextField!
    @IBOutlet weak var passwordField: DTTextField!
    @IBOutlet weak var confirmPasswordField: DTTextField!


    @IBOutlet weak var signIntoExistingAccount: UIButton!
    @IBOutlet weak var backgroundLoginButton: roundedButton!


    let button = TransitionButton()

    override func viewDidLoad() {
        super.viewDidLoad()


        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        setupScreen()

        self.hideKeyboardWhenTappedAround()
    }


    @IBAction func createAccountPressed(_ button: TransitionButton) {
        guard (validateData())else{
            return
        }

        button.startAnimation() // 2: Then start the animation when the user tap the button
        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
        backgroundQueue.async(execute: {

            sleep(UInt32(1.5)); // 3: Do your networking task or background work here.

            DispatchQueue.main.async(execute: { () -> Void in
                Auth.auth().createUser(withEmail: self.emailField.text!, password: self.passwordField.text!, completion: { (user, error) in
                            //If there are no errors it will register the user
                            if error == nil {
                                if let user = user {
                                    //sets up a dictionary to upload all these values to firebase
                                    let userData = [ "name": self.nameField.text!, "email" : self.emailField.text!, "profileImage": "https://firebasestorage.googleapis.com/v0/b/habitsapp-7ea48.appspot.com/o/profilePic.png?alt=media&token=b97f4349-3bc1-433e-81ac-792c5beafec1"]
                                    //completes the sign in and see how the userData is uploaded as a dictionary
                                    //Under the userID its uploaded as a dictionary
                                    self.completeSignIn(id: user.uid, userData: userData as Dictionary<String, AnyObject>);
                                    button.stopAnimation(animationStyle: .expand, completion: {
                                        self.performSegue(withIdentifier: "toPickHabit", sender: nil)
                                    })
                                }
                            } else {//If the password was too short
                                    self.upAlert(messages: "Account Already Exists");
                                    button.stopAnimation()
                            }
                        })
            })
        })
    }

    @IBAction func signIntoExistingAccount(_ sender: Any) {

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
    //Once the user creates an account it stores in keychain wrapper to take them to the main screen instead of the login screen again
    func completeSignIn(id: String, userData: Dictionary<String, AnyObject>){
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        KeychainWrapper.standard.set(id, forKey: KEY_UID);
    }

    func setupScreen(){

        button.frame = CGRect(x: 30, y: self.view.frame.height - 120, width: self.view.frame.width - 60, height: backgroundLoginButton.frame.height)

        let placeHolderColor = blueColor

        nameField.dtLayer.backgroundColor = UIColor.clear.cgColor
        nameField.dtLayer.borderWidth = 0
        nameField.textColor = placeHolderColor
        nameField.floatPlaceholderActiveColor = placeHolderColor
        nameField.floatPlaceholderColor = placeHolderColor
        nameField.placeholderColor = placeHolderColor

        emailField.dtLayer.backgroundColor = UIColor.clear.cgColor
        emailField.dtLayer.borderWidth = 0
        emailField.paddingYErrorLabel = 10
        emailField.textColor = placeHolderColor
        emailField.floatPlaceholderActiveColor = placeHolderColor
        emailField.floatPlaceholderColor = placeHolderColor
        emailField.placeholderColor = placeHolderColor

        passwordField.dtLayer.backgroundColor = UIColor.clear.cgColor
        passwordField.dtLayer.borderWidth = 0
        passwordField.textColor = placeHolderColor
        passwordField.floatPlaceholderActiveColor = placeHolderColor
        passwordField.floatPlaceholderColor = placeHolderColor
        passwordField.placeholderColor = placeHolderColor

        confirmPasswordField.dtLayer.backgroundColor = UIColor.clear.cgColor
        confirmPasswordField.dtLayer.borderWidth = 0
        confirmPasswordField.textColor = placeHolderColor
        confirmPasswordField.floatPlaceholderActiveColor = placeHolderColor
        confirmPasswordField.floatPlaceholderColor = placeHolderColor
        confirmPasswordField.placeholderColor = placeHolderColor

        self.view.addSubview(button)

        button.leadingAnchor.constraint(equalTo: backgroundLoginButton.leadingAnchor, constant: 0).isActive = true
        button.trailingAnchor.constraint(equalTo: backgroundLoginButton.trailingAnchor, constant: 0).isActive = true
        button.topAnchor.constraint(equalTo: backgroundLoginButton.topAnchor, constant: 0).isActive = true
        button.bottomAnchor.constraint(equalTo: backgroundLoginButton.bottomAnchor, constant: 0).isActive = true



        button.backgroundColor = .white
        button.setTitle("Create Account", for: .normal)
        button.titleLabel?.font =  UIFont(name: "D-DIN-Bold", size: 20)
        button.cornerRadius = 25.0
        button.spinnerColor = .white
        button.addTarget(self, action: #selector(createAccountPressed(_:)), for: .touchUpInside)
        buttonGradient(button: button)



        nameField.textContentType = UITextContentType("")
        emailField.textContentType = UITextContentType("")
        passwordField.textContentType = UITextContentType("")
        confirmPasswordField.textContentType = UITextContentType("")
        emailField.keyboardType = .emailAddress
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= (keyboardSize.height - 40)
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += (keyboardSize.height - 40)
            }
        }
    }
}


extension newUserVC{

    //Funtion to make sure the user enters everything correctly
    func validateData() -> Bool {

        guard nameField.text != "" else{
            nameField.showError(message: "Please Enter Name.")
            return false
        }

        guard emailField.text != "" else{
            emailField.showError(message: "Please Enter Email.")
            return false
        }

        guard validateEmail(enteredEmail: self.emailField.text!) else{
            emailField.showError(message: "Please Enter Valid Email")
            return false
        }

        guard (passwordField.text?.count)! > 5 else {
            passwordField.showError(message: "Password must be atleast 6 characters")
            return false
        }

        guard passwordField.text != "" else{
            passwordField.showError(message: "Please Enter Password.")
            return false
        }

        guard confirmPasswordField.text != "" else{
            confirmPasswordField.showError(message: "Please Confirm Password.")
            return false
        }

        guard passwordField.text == confirmPasswordField.text else{
            confirmPasswordField.showError(message: "Passwords Must Match")
            return false
        }
        return true
    }

}

