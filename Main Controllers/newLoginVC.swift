//
//  newLoginController.swift
//  Habits
//
//  Created by Ahsan Vency on 2/28/18.
//  Copyright © 2018 ahsan vency. All rights reserved.
//

import UIKit

class newLoginVC: UIViewController {


    @IBOutlet weak var emailField: fancyField!
    @IBOutlet weak var passwordField: fancyField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        setupScreen()
        
        self.hideKeyboardWhenTappedAround()
    }
    
    func setupScreen(){
        
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
