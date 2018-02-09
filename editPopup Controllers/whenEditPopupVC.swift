//
//  whenEditPopupVC.swift
//  Habits
//
//  Created by Ahsan Vency on 1/21/18.
//  Copyright © 2018 ahsan vency. All rights reserved.
//

import UIKit
import MultiSelectSegmentedControl
import Firebase

class whenEditPopupVC: UIViewController {
    var weekArray = [Int]()
    var timeDict:Dictionary = [String:Int]()
    var ref: DatabaseReference = Database.database().reference()

    @IBOutlet weak var screenTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myGradient = UIImage(named: "textWhenPopup.png")
        screenTitle.textColor = UIColor(patternImage: myGradient ?? UIImage())
        
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
            
            
            //using habit key to get dict
            let firstDict = value![firstKey] as! Dictionary<String,Any>
            
            //getting dict values and assigning them to labels
            
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
        
        timePicker.backgroundColor = UIColor(red: 243/255, green: 235/255, blue: 218/255, alpha: 1)
        
    }
    
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var segmentedControl: MultiSelectSegmentedControl!
    
    @IBAction func segmentSelected(_ sender: Any) {
        
        weekArray = []
        
        for x in segmentedControl.selectedSegmentIndexes{
            print(x)
            weekArray.append(Int(x))
        }
        
        
        
        
        
    }
    
    @IBAction func saveButton(_ sender: Any) {

        let time = timePicker.date
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
        if weekArray.count != 0{
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
                let strToUpdate = daysOfWeekStr + timeStr
                ref.child("Habits").child(uid).child("\(firstKey)").updateChildValues(["When":strToUpdate])
                ref.child("Habits").child(uid).child("\(firstKey)").updateChildValues(["freq":self.weekArray])
                // ...
            }) { (error) in
                print(error.localizedDescription)
            }
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let whenView = storyBoard.instantiateViewController(withIdentifier: "MainScreenViewCID") as! MainScreenViewC

            self.present(whenView,animated: true, completion: nil)
        }
        
    }
}
