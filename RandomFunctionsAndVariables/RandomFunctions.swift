//
//  RandomFunctions.swift
//  Habits
//
//  Created by ahsan vency on 1/2/18.
//  Copyright © 2018 ahsan vency. All rights reserved.
//

import Foundation
import UIKit
import TransitionButton

//Functions

//Validates the email the user enters in the email field
func validateEmail(enteredEmail:String) -> Bool {
    let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
    return emailPredicate.evaluate(with: enteredEmail)
}

//Variable that makes our life easier with uid= userID
let KEY_UID = "uid"


//Lets us access the blue color for textfields and other text
let blueColor : UIColor = UIColor(r: 13, g: 76, b: 153)


//Sets up the gradient on the login and create account buttons
func buttonGradient(button: TransitionButton){
    
    let layer : CAGradientLayer = CAGradientLayer()
    layer.frame.size = button.frame.size
    
    let color0 = UIColor(red:13/255, green:76/255, blue:153/255, alpha:0.85).cgColor
    let color1 = UIColor(red:99/255, green:42/255, blue: 91/255, alpha:0.76).cgColor
    let color2 = UIColor(red:186/255, green:7/255, blue: 29/255, alpha:0.71).cgColor
    let color3 = UIColor(red:218/255, green:128/255, blue:125/255, alpha:0.86).cgColor
    let color4 = UIColor(red:247/255, green:240/255, blue: 215/255, alpha:100).cgColor
    layer.colors = [color0,color1,color2,color3,color4]
    
    layer.startPoint = CGPoint(x: 0.0, y: 0.5)
    layer.endPoint = CGPoint(x: 1.0, y: 0.5)
    button.layer.insertSublayer(layer, at: 0)
}


//These are the different segue transtions
class RightToLeftSegue: UIStoryboardSegue {
    override func perform() {
        let src = self.source
        let dst = self.destination
        
        src.view.superview?.insertSubview(dst.view, aboveSubview: src.view)
        dst.view.transform = CGAffineTransform(translationX: -src.view.frame.size.width, y: 0)
        
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       options: .curveEaseInOut,
                       animations: {
                        dst.view.transform = CGAffineTransform(translationX: 0, y: 0)
        },
                       completion: { finished in
                        src.present(dst, animated: false, completion: nil)
        }
        )
    }
}

class LeftToRightSegue: UIStoryboardSegue {
    override func perform() {
        let src = self.source
        let dst = self.destination
        
        src.view.superview?.insertSubview(dst.view, aboveSubview: src.view)
        dst.view.transform = CGAffineTransform(translationX: src.view.frame.size.width, y: 0)
        
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       options: .curveEaseInOut,
                       animations: {
                        dst.view.transform = CGAffineTransform(translationX: 0, y: 0)
        },
                       completion: { finished in
                        src.present(dst, animated: false, completion: nil)
        }
        )
    }
}

class bottomToTop: UIStoryboardSegue {
    override func perform() {
        let src = self.source
        let dst = self.destination
        
        src.view.superview?.insertSubview(dst.view, aboveSubview: src.view)
        dst.view.transform = CGAffineTransform(translationX: 0, y: src.view.frame.size.height)
        
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       options: .curveEaseInOut,
                       animations: {
                        dst.view.transform = CGAffineTransform(translationX: 0, y: 0)
        },
                       completion: { finished in
                        src.present(dst, animated: false, completion: nil)
        }
        )
    }
}

//These transitions are called in the code itself
//I'm going to make it one function with variables being passed through for the subtype, as a fun exercise see if you can figure it out
func bottomTransition(duration: Double) -> CATransition{
    let transition = CATransition()
    transition.duration = duration
    transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    transition.type = kCATransitionPush
    transition.subtype = kCATransitionFromBottom
    return transition
}

func leftTransition(duration: Double) -> CATransition{
    let transition = CATransition()
    transition.duration = duration
    transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    transition.type = kCATransitionPush
    transition.subtype = kCATransitionFromLeft
    return transition
}

func rightTransition(duration: Double) -> CATransition{
    let transition = CATransition()
    transition.duration = duration
    transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    transition.type = kCATransitionPush
    transition.subtype = kCATransitionFromRight
    return transition
}


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
    
    func hideMenuWhenTappedAround(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.hideMenu))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func hideMenu(){
        
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
