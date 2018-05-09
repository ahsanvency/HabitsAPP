//
//  editRewardsVC.swift
//  Habits
//
//  Created by Ahsan Vency on 4/13/18.
//  Copyright © 2018 ahsan vency. All rights reserved.
//

import UIKit
import Firebase

class editRewardsVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var basicReward1: fancyField!
    @IBOutlet weak var basicReward2: fancyField!
    @IBOutlet weak var intReward1: fancyField!
    @IBOutlet weak var intReward2: fancyField!
    @IBOutlet weak var advReward: fancyField!
    
    @IBOutlet weak var confirmButton: roundedButton!
    
    
    func upAlert (messages: String) {
        let myAlert = UIAlertController(title: "Alert", message: messages, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let rect = CGRect(x: confirmButton.frame.origin.x, y: confirmButton.frame.origin.y, width: confirmButton.frame.width, height: confirmButton.frame.height)
        let glossyBtn = GlossyButton(frame: rect, withBackgroundColor: blueColor)
        glossyBtn?.setTitle("Confirm", for: .normal)
        glossyBtn?.titleLabel?.font = UIFont(name: "D-DIN-BOLD", size: 24)
        glossyBtn?.addTarget(self, action:#selector(confirm(_:)), for: .touchUpInside)
        
        advReward.delegate = self
        intReward2.delegate = self
        
        view.addSubview(glossyBtn!)
        
        
        guard let user = Auth.auth().currentUser else {
            return
        }
        let uid = user.uid
        DataService.ds.REF_HABITS.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            guard let firstKey = value?.allKeys[0] else {
                print("n")
                return }
            
            //using habit key to get dict
            let firstDict = value![firstKey] as! Dictionary<String,Any>
            let rewardsDict = firstDict["Rewards"] as! Dictionary<String,Any>
            
            self.basicReward1.text = (rewardsDict["basicReward1"] as! String)
            self.basicReward2.text = (rewardsDict["basicReward2"] as! String)
            self.intReward1.text = (rewardsDict["intReward1"] as! String)
            self.intReward2.text = (rewardsDict["intReward2"] as! String)
            self.advReward.text = (rewardsDict["advReward"] as! String)
            
        }) { (error) in
            print(error.localizedDescription)
        }
        self.hideKeyboardWhenTappedAround()
        
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
        if textField == self.advReward || textField == self.intReward2{
            self.view.frame.origin.y -= 140
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.advReward || textField == self.intReward2{
            self.view.frame.origin.y += 140
        }
    }
    
    
    @IBAction func back(_ sender: Any) {
        view.window?.layer.add(leftTransition(duration: 0.5), forKey: nil)
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func confirm(_ glossyBtn: GlossyButton) {
        
        
        
        if validate(){
            
            dismiss(animated: true, completion: nil)
            
            var ref: DatabaseReference!
            ref = Database.database().reference()
            
            //current user
            guard let user = Auth.auth().currentUser else {
                return
            }
            let uid = user.uid
            
            ref.child("Habits").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? NSDictionary
                guard let firstKey = value?.allKeys[0] else {
                    print("n")
                    return }
                ref.child("Habits").child(uid).child("\(firstKey)").child("Rewards").updateChildValues(["basicReward1": self.basicReward1.text!, "basicReward2":self.basicReward2.text!, "intReward1":self.intReward1.text!, "intReward2":self.intReward2.text!, "advReward":self.advReward.text!])
                // ...
            }) { (error) in
                print(error.localizedDescription)
            }
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let mainScreen = storyBoard.instantiateViewController(withIdentifier: "mainVCID") as! MainVC
            view.window?.layer.add(leftTransition(duration: 0.5), forKey: nil)
            self.present(mainScreen,animated: false, completion: nil)
        }else {
            self.upAlert(messages: "Please fill out all fields")
        }
        }
    
    func validate() -> Bool{
        if basicReward1.text == ""{
            self.upAlert(messages: "Please enter the first basic reward.")
            return false
        }
        else if basicReward2.text == ""{
            self.upAlert(messages: "Please enter the second basic reward.")
            return false
        }
        else if intReward1.text == ""{
            self.upAlert(messages: "Please enter the first intermediate reward.")
            return false
        }
        else if intReward2.text == ""{
            self.upAlert(messages: "Please enter the second intermediate reward.")
            return false
        }
        else if advReward.text == ""{
            self.upAlert(messages: "Please enter the advanced reward.")
            return false
        }
        return true
    }
    
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += (keyboardSize.height - 75)
            }
        }
    }
        
    }
