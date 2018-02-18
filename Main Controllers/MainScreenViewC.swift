//
//  MainScreenViewC.swift
//  Habits
//
//  Created by Ahsan Vency on 1/4/18.
//  Copyright © 2018 ahsan vency. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper
import UserNotifications

class MainScreenViewC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var animationView: UIImageView!
    @IBOutlet weak var animationLabel: UILabel!
    
    
    var intrinsicQuestions = [String]()
    var randomPopupNumber = 7
    var firstTimeLoaded = 0
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            //HabitCell().reload()
            self.tableView.reloadData()
            //self.notif()
        }
        
        
        if firstTimeLoaded == 1{
            self.animationLabel.isHidden = false
            self.animationView.isHidden = false
            UIView.animate(withDuration: 0.75, delay: 0, options: [], animations: {
                self.animationView.frame.origin.x -= 20
            }, completion: { _ in
                UIView.animate(withDuration: 0.55, delay: 0, options: [], animations: {
                    self.animationView.frame.origin.x += 20
                }, completion: { _ in
                    UIView.animate(withDuration: 0.75, delay: 0, options: [], animations: {
                        self.animationView.frame.origin.x -= 20
                    }, completion: { _ in
                        UIView.animate(withDuration: 0.75, delay: 0, options: [], animations: {
                            self.animationView.frame.origin.x += 20
                        }, completion: { _ in
                        })
                    })
                })
            })
            UIView.animate(withDuration: 1.5, delay: 1.5, options: [], animations: {
                self.animationLabel.alpha = 0
                self.animationView.alpha = 0
            }, completion: { _ in
                self.animationLabel.isHidden = true
                self.animationView.isHidden = true
            })
            self.firstTimeLoaded = 0
        }else {
            self.animationView.isHidden = true
            self.animationLabel.isHidden = true
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (success, error) in
        }
        
        
        
        let myGradient = UIImage(named: "textMainScreen.png")
        screenTitle.textColor = UIColor(patternImage: myGradient ?? UIImage())
        
        guard let user = Auth.auth().currentUser else {
            print("User not found")
            return
        }
        let uid = user.uid
//        var ref: DatabaseReference!
//        ref = Database.database().reference()
        DataService.ds.REF_HABITS.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            
            //getting habit key
            guard let firstKey = value?.allKeys[0] else {
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "NewHabitVCID") as! NewHabitVC
                self.present(newViewController, animated: true, completion: nil)
                return }
            })
    }
    
    //To start there will only be one habit
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "HabitCell", for: indexPath) as? HabitCell{
            return cell;
        }
        
        return HabitCell();
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let rewardsAction = UITableViewRowAction(style: .normal, title: "Rewards") { (action, index) in
            //current user
            guard let user = Auth.auth().currentUser else {
                return
            }
            let uid = user.uid
            
            //Gets the Habit id
            DataService.ds.REF_HABITS.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                //getting habit key
                guard let firstKey = value?.allKeys[0] else {
                    print("n")
                    return }

                let firstDict = value![firstKey] as! Dictionary<String,Any>

                var rewardsDict = firstDict["Rewards"] as? Dictionary<String, Any>
                let success = rewardsDict!["Success"] as? Int

                
                switch (success!){
                case 5..<10:
                    self.randomPopupNumber = 5;
                case 10..<20:
                    self.randomPopupNumber = 3;
                case 20..<31:
                    self.randomPopupNumber = 2;
                default:
                    self.randomPopupNumber = 10;
                    break;
                }
                let habitName = firstDict["name"] as? String
                
                self.intrinsicQuestions = ["How are you progressing with \(habitName!)?",
                    "Why do you want to continue \(habitName!)?",
                    "How does \(habitName!) relate to your values?",
                    "What do you gain by \(habitName!)?"]
                
                let test = Int(arc4random_uniform(UInt32(self.randomPopupNumber)))
                if test == 0 {
                    let intrinsicAlert = UIAlertController(title: "Intrinsic Reminder", message: self.intrinsicQuestions[Int(arc4random_uniform(UInt32(self.intrinsicQuestions.count)))], preferredStyle: UIAlertControllerStyle.alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
                        if let textField = intrinsicAlert.textFields?[0]{
                            if textField.text == ""{
//                                let reminderAlert = UIAlertController(title: "Alert", message: "Its important to answer the previous question.", preferredStyle: UIAlertControllerStyle.alert)
//                                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
//                                reminderAlert.addAction(okAction)
                                self.present(intrinsicAlert, animated: true, completion: nil)
                            }
                        }
                        self.performSegue(withIdentifier: "toRewardsScreen", sender: self) })
                    intrinsicAlert.addAction(okAction)
                    intrinsicAlert.addTextField(configurationHandler: nil)
                    self.present(intrinsicAlert, animated: true, completion: nil)
                }else{
                    self.performSegue(withIdentifier: "toRewardsScreen", sender: nil)
                }
            })
            
        }
        rewardsAction.backgroundColor = blueColor
        return [rewardsAction]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200;
    }
    
    //This is the menu button thats treated as a logout
    @IBAction func menuAsLogout(_ sender: Any) {
        let keychainResult = KeychainWrapper.standard.remove(key: KEY_UID)
        try! Auth.auth().signOut()
//        dismiss(animated: true, completion: nil)
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "MainLoginID") as! MainLogin
        self.present(newViewController, animated: true, completion: nil)
    }
    
    
    
    @IBAction func addNewHabitBtn(_ sender: Any) {
        
        guard let user = Auth.auth().currentUser else {
            print("User not found")
            return
        }
        let uid = user.uid

        DataService.ds.REF_HABITS.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            //getting habit key
            guard let firstKey = value?.allKeys[0] else {
                print("n")
                return }
            
            //using habit key to get dict
            let firstDict = value![firstKey] as! Dictionary<String,Any>
            var rewardsDict = firstDict["Rewards"] as? Dictionary<String, Any>
            var success = rewardsDict!["Success"] as? Double

            //getting dict values and assigning them to labels
            guard let successesInt = success else {
                print("none")
                return
            }

            if successesInt >= 30 {
                
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "NewHabitVCID") as! NewHabitVC
                self.present(newViewController, animated: true, completion: nil)
                
                
            } else  {
                func alert (messages: String) {
                    let myAlert = UIAlertController(title: "Alert", message: messages, preferredStyle: UIAlertControllerStyle.alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: { (alertAction: UIAlertAction) in
                    })
                    myAlert.addAction(okAction)
                    self.present(myAlert, animated: true, completion: nil)
                }
                
                alert(messages: "You need to get to 30 days before adding a new habit. You currently have \(Int(successesInt)) days.")
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func notif(){
        //Creates the notification
        let content = UNMutableNotificationContent()
        content.title = "The 5 seconds are up!"
        content.subtitle = "They are up now"
        content.body = "The 5 seconds are really up!!!!"
        //App icon for the badge
        content.badge = 1
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
        let request = UNNotificationRequest(identifier: "timerDone", content: content, trigger: trigger)
        //Adds to the notification center which has the job of displaying it
        
        UNUserNotificationCenter.current().add(request) { (error) in
        }
    }
}

class CustomProgressView: UIProgressView {
    
    var height:CGFloat = 1.0
    // Do not change this default value,
    // this will create a bug where your progressview wont work for the first x amount of pixel.
    // x being the value you put here.
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let size:CGSize = CGSize.init(width: self.frame.size.width, height: height)
        return size
    }
}
