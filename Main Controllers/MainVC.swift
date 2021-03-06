//
//  MainVC.swift
//  Habits
//
//  Created by Ahsan Vency on 4/13/18.
//  Copyright © 2018 ahsan vency. All rights reserved.
//


import UIKit
import Firebase
import SwiftKeychainWrapper
import UserNotifications
import TransitionButton
import KDCircularProgress

class MainVC: CustomTransitionViewController {

    
    @IBOutlet var loadingView: UIView!
    
    
    //Outlets for the habit
    @IBOutlet weak var habitNameLabel: UILabel!
    @IBOutlet weak var habitPic: UIImageView!
    @IBOutlet weak var whyAtWherelabel: UILabel!
    @IBOutlet weak var whenLabel: UILabel!
    @IBOutlet weak var progressView: KDCircularProgress!
    @IBOutlet weak var successfulDays: UILabel!
    
    
    @IBOutlet weak var backgroundLeadingConstraint: NSLayoutConstraint!
    
    
    //Variables for random intrinsic reminders
    var intrinsicQuestions = [String]()
    var randomPopupNumber = 7
    var habitName: String?

    
    override func viewDidAppear(_ animated: Bool) {
        
        //Updates the habit everytime the view appears and sends them a notification for the time of the habit
        DispatchQueue.main.async {
            self.updateHabit()
            self.notif()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(showSettings),
                                               name: NSNotification.Name("showSettings"),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(showEditInfo),
                                               name: NSNotification.Name("showEditInfo"),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(showEditRewards),
                                               name: NSNotification.Name("showEditRewards"),
                                               object: nil)
        
        showLoadingScreen()
        //How the notification is sent
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (success, error) in
        }
        
        //If there is a user logged in, which there always will be with users
        //Its possible for a user not to be signed in when we test on xcode based off how we test it
        guard let uid = Auth.auth().currentUser?.uid else {
            print("User not found")
            return
        }
        
        //This is where the dataservice file helps out a lot because we only have to type REF_HABITS to access the habits child of the general firebase file
        DataService.ds.REF_HABITS.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            //snapshot.value is a dictionary with all the values under that node for firebase
            let value = snapshot.value as? NSDictionary
            
            
            //getting the habit key of the specific user
            //If the user created an account but did not setup their habit it will take them to the screen to pick a habit and set it up
            guard (value?.allKeys[0]) != nil else {
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "pickHabitVCID") as! pickHabitVC
                self.present(newViewController, animated: true, completion: nil)
                return
            }
        })
    }
    
    @objc func showSettings() {
        performSegue(withIdentifier: "showSettings", sender: nil)
    }
    
    @objc func showEditInfo() {
        performSegue(withIdentifier: "showEditInfo", sender: nil)
    }
    
    @objc func showEditRewards() {
        performSegue(withIdentifier: "showEditRewards", sender: nil)
    }
    
    
    
    
    //Function that shows the inital loading screen when they open the app
    func showLoadingScreen(){
        loadingView.bounds.size.width = view.bounds.width
        loadingView.bounds.size.height = view.bounds.height
        loadingView.center = view.center
        loadingView.alpha = 1.0
        view.addSubview(loadingView)
        
        UIView.animate(withDuration: 1, delay: 0.7, options: [], animations: {
            self.loadingView.alpha = 0
        }) { (success) in
            
        }
    }
    
    

    @IBAction func menuTapped(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("ToggleSideMenu"), object: nil)
    }
    
    //This is the function that constantly updates the habit with data from firebase
    func updateHabit(){
            guard let uid = Auth.auth().currentUser?.uid else {
                return
            }
            DataService.ds.REF_HABITS.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? NSDictionary
                
                //getting habit key
                guard let firstKey = value?.allKeys[0] else {
                    return }
                //using habit key to get dict
                
                //These are the dictionaries from firebase we are accessing to setup the stuff on the mainVC
                let firstDict = value![firstKey] as! Dictionary<String,Any>
                var rewardsDict = firstDict["Rewards"] as? Dictionary<String, Any>
                
                let whyText = firstDict["Why"] as! String
                let whereText = firstDict["Where"] as! String
                
                self.habitNameLabel.text = (firstDict["name"] as! String)
                self.habitPic.image = UIImage(named: firstDict["name"] as! String)
                self.whyAtWherelabel.text = "\(whyText) at \(whereText)"
                self.progressView.angle = Double(360 * Float(rewardsDict!["Success"] as! Double/30))
//                self.progressView.angle = 90.0
                self.successfulDays.text = "\(rewardsDict!["Success"]!)"

                
//                self.habitNameLabel.text = "Public Speaking"
//                self.habitPic.image = UIImage(named: "Public Speaking")
//                self.whyAtWherelabel.text = "Share Ideas at Capital Factory"
//                self.progressView.angle = 90
//                self.successfulDays.text = "6"
                
                
                //Updating the time constantly is complicated and below is how we are doing it
                let daysDict: Dictionary = [0:"Saturday",1:"Sunday",2:"Monday",3:"Tuesday",4:"Wednesday",5:"Thursday",6:"Friday"]
                
                func getDayOfWeek()->Int {
                    let time = Date()
                    
                    let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
                    let myComponents = myCalendar.components(.weekday, from: time)
                    let weekDay = myComponents.weekday
                    return weekDay!
                }
                
                let cDay = getDayOfWeek()
                let fbTime  =  firstDict["When"] as? String
                let fbParseTime = fbTime?.split(separator: " ")//
                let fbLength = fbParseTime?.count
                let fbTimeVal = fbParseTime![fbLength! - 2 ..< fbLength! ]
                var fbTimeArray = [String]()
                var fbNewTime = ""
                for x in fbTimeVal {
                    fbTimeArray.append(String(x))
                    fbNewTime += x + " "
                }
                
                //getting habit days
                let workDaysNS: NSArray = firstDict["freq"]! as! NSArray
                var workDaysArray: Array = [Any]()
                for x in workDaysNS{
                    workDaysArray.append(x)
                }
                
                
                //fb values
                let currentHabitTimeMin =  Int(fbTimeArray[0].split(separator: ":")[1])
                var currentHabitTimeHours = Int(fbTimeArray[0].split(separator: ":")[0])
                
                if fbTimeArray[1] == "PM"{
                    currentHabitTimeHours! += 12
                }
                
                //current vals
                let date = Date()
                let calendar = Calendar.current
                let chour = calendar.component(.hour, from: date)
                let cminutes = calendar.component(.minute, from: date)
                
                
                if (chour >= currentHabitTimeHours! && cminutes > currentHabitTimeMin!){
                    //start get next workout
                    var gotWorkOut = false
                    //Check 1
                    for x in workDaysArray{
                        
                        var check = x as! Int
                    }
                    
                    //check 2
                    if  gotWorkOut == false {
                        var lowerDays = [Int]()
                        var higherDays = [Int]()
                        
                        for x in workDaysArray{
                            let value = x as! Int
                            if value < cDay {
                                lowerDays.append(value)
                            } else if value > cDay {
                                higherDays.append(value)
                            }
                            
                        }
                        
                        if higherDays.count != 0 {
                            self.whenLabel.text = "Next:  \(daysDict[higherDays[0]]!) at \(fbNewTime)"
                            gotWorkOut = true
                            
                            
                        } else if lowerDays.count != 0 {
                            self.whenLabel.text = "Next:  \(daysDict[lowerDays[0]]!) at \(fbNewTime)"
                            gotWorkOut = true
                            
                        } else {
                            self.whenLabel.text = "Next:  \(daysDict[cDay]!) at \(fbNewTime)"
                            gotWorkOut = true
                            
                        }
                    }
                } else {
                    
                    //start get next workout
                    var gotWorkOut = false
                    //Check 1
                    for x in workDaysArray{
                        
                        let check = x as! Int
                        
                        if  check == cDay{
                            
                            self.whenLabel.text = "Next:  \(daysDict[cDay]!) at \(fbNewTime)"
                            gotWorkOut = true
                        }
                    }
                    
                    //check 2
                    if  gotWorkOut == false {
                        var lowerDays = [Int]()
                        var higherDays = [Int]()
                        
                        for x in workDaysArray{
                            let value = x as! Int
                            if value < cDay {
                                lowerDays.append(value)
                            } else if value > cDay {
                                higherDays.append(value)
                            }
                            
                        }
                        
                        if higherDays.count != 0 {
                            self.whenLabel.text = "Next:  \(daysDict[higherDays[0]]!) at \(fbNewTime)"
                            
                            gotWorkOut = true
                            
                        } else if lowerDays.count != 0 {
                            self.whenLabel.text = "Next:  \(daysDict[lowerDays[0]]!) at \(fbNewTime)"
                            gotWorkOut = true
                            
                        } else {
                            self.whenLabel.text = "Next:  \(daysDict[cDay]!) at \(fbNewTime)"
                            gotWorkOut = true
                            
                        }
                    }
                }
                
//                self.whenLabel.text = "Monday at 7:30 PM"
                
            }) { (error) in
                print(error.localizedDescription)
            }
//        })
    }
    
    //When they hit the achievedButton in general
    @IBAction func achievedButon(_ sender: Any) {
        
        //current user
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        //let uid = user.uid
        
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
            
            //Based on their successes the odds of getting a random intrinsic reminder change
            //They get more reminders towards the end of the 30 days instead of the beginning
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
            self.habitName = (firstDict["name"] as! String)
            
            self.intrinsicQuestions = ["How are you progressing with \(self.habitName!)?",
                "Why do you want to continue \(self.habitName!)?",
                "How does \(self.habitName!) relate to your values?",
                "What do you gain by \(self.habitName!)?"]
            
            //Setups the random asking of intrinsic reminders
            let test = Int(arc4random_uniform(UInt32(self.randomPopupNumber)))
            if test == 0 {
                let intrinsicAlert = UIAlertController(title: "Intrinsic Reminder", message: self.intrinsicQuestions[Int(arc4random_uniform(UInt32(self.intrinsicQuestions.count)))], preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
                    if let textField = intrinsicAlert.textFields?[0]{
                        if textField.text == ""{
                            self.present(intrinsicAlert, animated: true, completion: nil)
                        } else{
                            self.performSegue(withIdentifier: "toRewardsScreen", sender: self)
                        }
                    }
                })
                intrinsicAlert.addAction(okAction)
                intrinsicAlert.addTextField(configurationHandler: nil)
                self.present(intrinsicAlert, animated: true, completion: nil)
            }else{
                self.performSegue(withIdentifier: "toRewardsScreen", sender: nil)
            }
        })
    }
    
    @IBAction func logOut(_ sender: Any) {
        //Removes the object stored in keychainWrapper so once they logout and reopen the app they will be on the login screen
        KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        try! Auth.auth().signOut()
        //        dismiss(animated: true, completion: nil)
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "loginID") as! loginVC
        view.window?.layer.add(bottomTransition(duration: 0.5), forKey: nil)
        self.present(newViewController, animated: false, completion: nil)
    }
    
    //Sends them the notification an hour before their habit time
    func notif(){
        guard let uid = Auth.auth().currentUser?.uid else {
            print("User not found")
            return
        }
        
        //Accesses the data from firebase again
        DataService.ds.REF_HABITS.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            
            //getting habit key
            guard let firstKey = value?.allKeys[0] else {
                print("n")
                return }
            
            //using habit key to get dict
            let firstDict = value![firstKey] as! Dictionary<String,Any>
            
            //Complicated way to access the time and update it
            self.habitName = (firstDict["name"] as! String)
            let fbTime  =  firstDict["When"] as? String
            let fbParseTime = fbTime?.split(separator: " ")//
            let fbLength = fbParseTime?.count
            let fbTimeVal = fbParseTime![fbLength! - 2 ..< fbLength! ]
            var fbTimeArray = [String]()
            
            
            var fbNewTime = ""
            for x in fbTimeVal {
                fbTimeArray.append(String(x))
                fbNewTime += x + " "
            }
            
            
            //fb values
            guard let currentHabitTimeMin =  Int(fbTimeArray[0].split(separator: ":")[1]) else {
                print("error")
                return
            }
            guard var currentHabitTimeHours = Int(fbTimeArray[0].split(separator: ":")[0]) else {
                print("error")
                return
            }
            
            //Creates the notification
            let content = UNMutableNotificationContent()
            content.title = "Reminder"
            
            guard Auth.auth().currentUser != nil else {
                return
            }
            
            content.body = "Its almost time to start \(String(describing: self.habitName!))."
            //App icon for the badge
            content.badge = 1
            var date = DateComponents()
            
            //If its PM adds 12 to it because XCode works off 24 hour time we asked them for 12 hours with AM and PM
            //Also why its kinda complicated
            if fbTimeArray[1] == "PM"{
                currentHabitTimeHours += 12
            }
            
            //Subtracts one hour so we can remind them an hour before their habit
            date.hour = (currentHabitTimeHours - 1)
            date.minute = (currentHabitTimeMin)
            let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
            let request = UNNotificationRequest(identifier: "timerDone", content: content, trigger: trigger)
            //Adds to the notification center which has the job of displaying it
            
            UNUserNotificationCenter.current().add(request) { (error) in
            }
            
        })
    }
    
}
