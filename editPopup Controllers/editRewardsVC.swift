//
//  editRewardsVC.swift
//  Habits
//
//  Created by Ahsan Vency on 4/13/18.
//  Copyright © 2018 ahsan vency. All rights reserved.
//

import UIKit
import Firebase

class editRewardsVC: UIViewController {

    @IBOutlet weak var basicReward1: fancyField!
    @IBOutlet weak var basicReward2: fancyField!
    @IBOutlet weak var intReward1: fancyField!
    @IBOutlet weak var intReward2: fancyField!
    @IBOutlet weak var advReward: fancyField!
    
    
    func upAlert (messages: String) {
        let myAlert = UIAlertController(title: "Alert", message: messages, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
            
            self.basicReward1.text = rewardsDict["basicReward1"] as! String
            self.basicReward2.text = rewardsDict["basicReward2"] as! String
            self.intReward1.text = rewardsDict["intReward1"] as! String
            self.intReward2.text = rewardsDict["intReward2"] as! String
            self.advReward.text = rewardsDict["advReward"] as! String
            
        }) { (error) in
            print(error.localizedDescription)
        }
        self.hideKeyboardWhenTappedAround()
    }
    
    
    @IBAction func back(_ sender: Any) {
        view.window?.layer.add(leftTransition(duration: 0.5), forKey: nil)
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func confirm(_ sender: Any) {
        if basicReward1.text != "" && basicReward2.text != "" && intReward1.text != "" && intReward2.text != "" && advReward.text != ""{
            
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
        
    }
