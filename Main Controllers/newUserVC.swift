//
//  newUserVC.swift
//  Habits
//
//  Created by Ahsan Vency on 3/28/18.
//  Copyright © 2018 ahsan vency. All rights reserved.
//



import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
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
        dismiss(animated: true, completion: nil)
    }
    
    
    //This function will be called everytime there is an error with the values the user entered. The message determining the error will be passed through to the function and displayed on the screen.
    func upAlert (messages: String) {
        let myAlert = UIAlertController(title: "Alert", message: messages, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true, completion: nil)
    }
    
    //Facebook login button
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
            }
        })
    }
    
    
    //Currently dont know how to get the email of the user when they login with facebook, instead of uploading the provider its better to upload the email and name
    func firebaseAuth(_ credential: AuthCredential){
        Auth.auth().signIn(with: credential) { (user, error) in
            if let user = user {
                
                //How we get the name of the person from facebook
                FBSDKProfile.loadCurrentProfile(completion: {(profile, error) -> Void in
                    
                    if let name = profile?.name{
                        let userData = ["name" : name, "id" : profile?.userID]
                        self.completeSignIn(id: user.uid, userData: userData as Dictionary<String, AnyObject>)
                    }
                })
            }
        }
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
                self.view.frame.origin.y -= (keyboardSize.height - 100)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += (keyboardSize.height - 100)
            }
        }
    }
}

