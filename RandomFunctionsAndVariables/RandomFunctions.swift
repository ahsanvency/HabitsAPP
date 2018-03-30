//
//  RandomFunctions.swift
//  Habits
//
//  Created by ahsan vency on 1/2/18.
//  Copyright © 2018 ahsan vency. All rights reserved.
//

import Foundation
import UIKit

//Functions
func validateEmail(enteredEmail:String) -> Bool {
    let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
    return emailPredicate.evaluate(with: enteredEmail)
}

let KEY_UID = "uid"

let habitsDict = ["Why": "Click To Edit", "When": "Click To Edit", "Where": "Click To Edit"];

let SHADOW_GRAY: CGFloat = 120.0 / 255.0

let blueColor : UIColor = UIColor(r: 13, g: 76, b: 153)
let satinColor : UIColor = UIColor(r: 247, g: 239, b: 208)
let maroonColor : UIColor = UIColor(r: 186, g: 7, b: 29)
let seaFoamColor : UIColor = UIColor(r: 9, g: 42, b: 48)

let habitList = ["Running","Meditating","Waking Up Early","Coding","Journaling", "Eating Healthy", "Praying", "Reading", "Act of Kindness", "Lifting", "Sleeping on Time"]

extension UIColor {
    
    //This is extending the function and making it easier to use
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat){
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIViewController {
    func registerForKeyboardDidShowNotification(usingBlock block: ((NSNotification, CGSize) -> Void)? = nil) {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardDidShow, object: nil, queue: nil, using: { (notification) -> Void in
            let userInfo = notification.userInfo!
            guard let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? AnyObject)?.cgRectValue.size else { fatalError("Can't grab the keyboard frame") }
            
            block?(notification as NSNotification, keyboardSize)
        })
    }
    
    func registerForKeyboardWillHideNotification(usingBlock block: ((NSNotification) -> Void)? = nil) {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillHide, object: nil, queue: nil, using: { (notification) -> Void in
            block?(notification as NSNotification)
        })
    }
}

extension Notification.Name {
    static let habitChanged = NSNotification.Name("habitChanged")
}
