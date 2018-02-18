//
//  whenAddPopupVC.swift
//  Habits
//
//  Created by Ahsan Vency on 1/21/18.
//  Copyright © 2018 ahsan vency. All rights reserved.
//

import UIKit
import MultiSelectSegmentedControl

class whenAddPopupVC: UIViewController{

    
    
    var weekArray = [Int]()
    var timeDict:Dictionary = [String:Int]()
    var habitRow: Int?
    var habitName: String?
    var whyLblText: String?
    var whenLblText:String?
    var whereLblText:String?
    var currentText:String?
    
    var basicStr: String?
    var intStr: String?
    var advStr: String?
    @IBOutlet weak var questionLbl: UILabel!
    @IBOutlet weak var screenTitle: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let myGradient = UIImage(named: "textWhenPopup.png")
        screenTitle.textColor = UIColor(patternImage: myGradient ?? UIImage())
        let indexSet = NSMutableIndexSet()
        weekArray.forEach(indexSet.add)
        questionLbl.text = "When can you consistently start \(habitName!)"
        segmentedControl.selectedSegmentIndexes = indexSet as IndexSet!
//        timePicker.delegate = self
//        timePicker.dataSource = self
        timePicker.backgroundColor = satinColor
        timePicker.setValue(blueColor, forKeyPath: "textColor")
        self.hideKeyboardWhenTappedAround()
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
        
        timeDict["hour"] = hour
        timeDict["minute"] = minute
        print("minute",minute)
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
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let whenView = storyBoard.instantiateViewController(withIdentifier: "NewHabitVCID") as! NewHabitVC
            whenView.weekArray = weekArray
            whenView.whenLblText = daysOfWeekStr + timeStr
            whenView.whereLblText = whereLblText!
            whenView.whyLblText = whyLblText!
            whenView.currentText = currentText!
            whenView.basicStr = basicStr!
            whenView.intStr = intStr!
            whenView.advStr = advStr!
            whenView.editButtonPressed = 0
            self.present(whenView,animated: true, completion: nil)
        }
        
    }
    
    @IBAction func backButton(_ sender: Any) {

        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let whenView = storyBoard.instantiateViewController(withIdentifier: "NewHabitVCID") as! NewHabitVC
            whenView.weekArray = weekArray
            whenView.whereLblText = whereLblText!
            whenView.whyLblText = whyLblText!
            whenView.currentText = currentText!
            whenView.basicStr = basicStr!
            whenView.intStr = intStr!
            whenView.advStr = advStr!
            whenView.editButtonPressed = 0
            self.present(whenView,animated: true, completion: nil)
    }
    
}
