//
//  editInfoVC.swift
//  Habits
//
//  Created by Ahsan Vency on 4/12/18.
//  Copyright © 2018 ahsan vency. All rights reserved.
//

import UIKit
import Firebase
import MultiSelectSegmentedControl

class editInfoVC: UIViewController {
    
    //Variables
    var weekArray = [Int]()
    var timeDict:Dictionary = [String:Int]()

    
    //Outlets
    @IBOutlet weak var whyField: fancyField!
    @IBOutlet weak var whereField: fancyField!
    
    @IBOutlet weak var whenPicker: UIDatePicker!
    @IBOutlet weak var segmentedControl: MultiSelectSegmentedControl!
    
    @IBOutlet weak var confirmButton: roundedButton!
    
    
    func upAlert (messages: String) {
        let myAlert = UIAlertController(title: "Alert", message: messages, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        whenPicker.setValue(UIColor.white, forKeyPath: "textColor")
        
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
            
            self.whyField.text = firstDict["Why"] as! String
            self.whereField.text = firstDict["Where"] as! String
            
            let workDaysNS: NSArray = firstDict["freq"]! as! NSArray
            for x in workDaysNS{
                self.weekArray.append(x as! Int)
            }
            
            
            let indexSet = NSMutableIndexSet()
            self.weekArray.forEach(indexSet.add)
            self.segmentedControl.selectedSegmentIndexes = indexSet as IndexSet!
            
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        self.hideKeyboardWhenTappedAround()
    }
    
    
    @IBAction func segmentSelected(_ sender: Any) {
        
        weekArray = []
        
        for x in segmentedControl.selectedSegmentIndexes{

            weekArray.append(Int(x))
        }
    }
    
    @IBAction func confirm(_ sender: Any) {
        
        let time = whenPicker.date
        let calender = Calendar.current
        let components = calender.dateComponents([.year,.month,.day,.hour,.minute,.second], from: time)
        
        guard let hour = components.hour else
        {   print("error")
            return
        }
        guard let minute = components.minute else
        {
            print("error")
            return
        }
        
        
        var daysOfWeekList = ["sa","su","m","t","w","th","f"]
        var daysOfWeekStr = ""
        for x in weekArray{
            daysOfWeekStr += daysOfWeekList[x] + " "
        }
        
        
        var timeStr = ""
        if hour > 11 {
            if hour > 12{
                timeStr += String(hour - 12) + ":"
            } else {
                timeStr += String(hour) + ":"
            }
            
            if minute < 10{
                timeStr +=  "0" + String(minute) + " PM"
                
            } else {
                timeStr += String(minute) + " PM"
            }
            
        }else {
            if hour == 0 {
                timeStr +=  "12" + ":"
            } else {
                timeStr += String(hour) + ":"
            }
            
            if minute < 10{
                timeStr +=  "0" + String(minute) + " PM"
                
            } else {
                timeStr += String(minute) + " AM"
            }
        }
        
       if validate(){
            dismiss(animated: true, completion: nil)
            //database instance
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
                let whenString = daysOfWeekStr + timeStr
                ref.child("Habits").child(uid).child("\(firstKey)").updateChildValues(["When":whenString])
                ref.child("Habits").child(uid).child("\(firstKey)").updateChildValues(["Why":self.whyField.text!])
                ref.child("Habits").child(uid).child("\(firstKey)").updateChildValues(["Where":self.whereField.text!])
                ref.child("Habits").child(uid).child("\(firstKey)").updateChildValues(["freq":self.weekArray])
                // ...
            }) { (error) in
                print(error.localizedDescription)
            }
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let mainScreen = storyBoard.instantiateViewController(withIdentifier: "mainVCID") as! MainVC
            view.window?.layer.add(leftTransition(duration: 0.5), forKey: nil)
            self.present(mainScreen,animated: false, completion: nil)
        }else{
            self.upAlert(messages: "Please Fill Out Everything.")
        }
    }
    
    func validate() -> Bool{
        if whyField.text == ""{
            self.upAlert(messages: "Please fill out Why.")
            return false
        }
        else if whereField.text == ""{
            self.upAlert(messages: "Please fill out Where.")
            return false
        }else if weekArray.count == 0{
            self.upAlert(messages: "Please choose the days of the week.")
            return false
        }
        return true
    }
    
    @IBAction func back(_ sender: Any) {
        view.window?.layer.add(leftTransition(duration: 0.5), forKey: nil)
        dismiss(animated: false, completion: nil)
    }
}


