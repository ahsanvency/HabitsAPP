//
//  newLoginController.swift
//  Habits
//
//  Created by Ahsan Vency on 2/28/18.
//  Copyright © 2018 ahsan vency. All rights reserved.
//

//So much shit to import
import TransitionButton
import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import SwiftKeychainWrapper
import DTTextField
import paper_onboarding

class loginVC: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var emailField: DTTextField!
    @IBOutlet weak var passwordField: DTTextField!
    
    
    @IBOutlet weak var backgroundLoginButton: UIButton!
    
    //This is the button that spins when the user is logging in
    let button = TransitionButton()
    
    //Variable that tracks if we need to show the loading view or not
    var loadingViewNumber: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Function that sends a notification that will eventually make the screen move up when they type into a textfield
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        setupScreen()
        
        //Function that is obvious lol
        self.hideKeyboardWhenTappedAround()
    }
    
    //Whenever the user hits the login button
    @IBAction func lognButtonPressed(_ button: TransitionButton) {
        
        //Makes sure the data they entered is valid
        guard validateData() else{
            return
        }
        
        //Starts the animation when the user hits the button
        button.startAnimation()
        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
        backgroundQueue.async(execute: {

            //Sleeps everything so the networking with firebase can happen
            sleep(UInt32(1.5));

            //Actions to login the user
            DispatchQueue.main.async(execute: { () -> Void in
                
                
                if let email = self.emailField.text, let pwd = self.passwordField.text{
                    
                    //Firebase function that signs them in
                        Auth.auth().signIn(withEmail: email, password: pwd, completion: { (user, error) in
                            //If there is an error with their login
                            if error != nil {
                                self.upAlert(messages: "Invalid Username or Password")
                                button.stopAnimation()
                                
                            //If there is no error with the login and it worked correctly
                            }else {
                                if let user = user {
                                    self.completeSignIn(id: user.uid)
                                    button.stopAnimation(animationStyle: .expand, completion: {
                                        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                        let newViewController = storyBoard.instantiateViewController(withIdentifier: "mainVCID") as! MainVC
                                        self.present(newViewController, animated: true, completion: nil)
                                    })
                                }
                            }
                        })
                }
            })
        })
    }
    
    //Function that is the alert we have to have this function on every View Controller for now
    //Trying to find a way to only have it on the functions and variables doc then calling the function anywhere easily
    func upAlert (messages: String) {
        let myAlert = UIAlertController(title: "Alert", message: messages, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true, completion: nil)
    }
    
    
    //Function that logs them into facebook
    @IBAction func facebookLogin(_ sender: Any) {
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        //want to get permissions for the name, email address and profile picture so we can set them on the menu
        //This is why logging in with facebook causes the menu to crash
        fbLoginManager.logIn(withReadPermissions: ["email","public_profile"], from: self) { (result, error) -> Void in
            if (error == nil){
                if let _ : FBSDKLoginManagerLoginResult = result {
                    do {
                        self.getFBUserData()
                    }
                }
            }
        }
    }
    
    
    func getFBUserData(){
        let graphRequest:FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"first_name,email, picture.type(large)"])
        
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                print("Error: \(String(describing: error))")
            }
            else
            {
                let data:[String:AnyObject] = result as! [String : AnyObject]
                print(data)
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        })
    }
    
    //If firebase was properly authenticated then it will send the user to the main screen
    func firebaseAuth(_ credential: AuthCredential){
        Auth.auth().signIn(with: credential) { (user, error) in
            if let user = user {
                _ = ["provider" : credential.provider]
                self.completeSignIn(id: user.uid);
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "mainVCID") as! MainVC
                self.present(newViewController, animated: true, completion: nil)
            }
        }
    }
    
    //Stores the fact they signed in so it opens the main screen everytime because they are already logged in
    func completeSignIn(id: String){
        KeychainWrapper.standard.set(id, forKey: KEY_UID);
    }
    
    //This function is used on every viewcontroller for extra setup stuff we could not do in story board
    func setupScreen(){
        let placeHolderColor = blueColor
        
        button.frame = CGRect(x: 30, y: self.view.frame.height - 115, width: self.view.frame.width - 60, height: backgroundLoginButton.frame.height)
        
        //We use a DTTextField that's what makes the placeholder float above and what makes the red letters come up to show the error
        //Can't figure out how to make the it scroll correctly for now
        emailField.dtLayer.backgroundColor = UIColor.clear.cgColor
        emailField.dtLayer.borderWidth = 0
        emailField.floatPlaceholderActiveColor = placeHolderColor
        emailField.textColor = placeHolderColor
        //Whenever there is an error this is how much the red error label should go down from the textfield but it goes down the same amount regardless of the number you put in
        emailField.paddingYErrorLabel = 10
        emailField.floatPlaceholderColor = placeHolderColor
        emailField.placeholderColor = placeHolderColor
        
        passwordField.dtLayer.backgroundColor = UIColor.clear.cgColor
        passwordField.dtLayer.borderWidth = 0
        passwordField.floatPlaceholderActiveColor = placeHolderColor
        passwordField.textColor = placeHolderColor
        passwordField.floatPlaceholderColor = placeHolderColor
        passwordField.paddingYErrorLabel = 10
        passwordField.placeholderColor = placeHolderColor
        
        
        //adds the transition button onto the screen
        self.view.addSubview(button)
        
        //Sets up the constraints for the transition button
        //I put a normal button on the main screen and set it to hidden
        //Then we use all its properties to put the TransitionButton in the same spot
        button.leadingAnchor.constraint(equalTo: backgroundLoginButton.leadingAnchor, constant: 0).isActive = true
        button.trailingAnchor.constraint(equalTo: backgroundLoginButton.trailingAnchor, constant: 0).isActive = true
        button.topAnchor.constraint(equalTo: backgroundLoginButton.topAnchor, constant: 0).isActive = true
        button.bottomAnchor.constraint(equalTo: backgroundLoginButton.bottomAnchor, constant: 0).isActive = true
        
        
        button.backgroundColor = .white
        button.setTitle("LOGIN", for: .normal)
        button.titleLabel?.font =  UIFont(name: "D-DIN-Bold", size: 20)
        button.cornerRadius = 25
        button.spinnerColor = .white
        button.addTarget(self, action: #selector(lognButtonPressed(_:)), for: .touchUpInside)
        
        buttonGradient(button: button)
        emailField.textContentType = UITextContentType("")
        passwordField.textContentType = UITextContentType("")
        emailField.keyboardType = .emailAddress
    }
    
    //Functions that make the screen go up and down with the keybaord coming up or going down
    //We have to put this on every VC for now and want to make it a general function that applies everywhere
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

//Extention to set up the DTTextField error message
extension loginVC{

    func validateData() -> Bool {

        guard emailField.text != "" else{
            emailField.showError(message: "Please Enter Email.")
            return false
        }
        
        guard passwordField.text != "" else{
            passwordField.showError(message: "Please Enter Password.")
            return false
        }
        
        return true
    }
    
}
