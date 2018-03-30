//
//  Slide.swift
//  Habits
//
//  Created by Ahsan Vency on 3/29/18.
//  Copyright © 2018 ahsan vency. All rights reserved.
//

import UIKit
import MultiSelectSegmentedControl

class whenSlide: UIView {
    
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var segmentedControl: MultiSelectSegmentedControl!
    
    
    var timeDict:Dictionary = [String:Int]()
    var weekArray = [Int]()
    
    var daysOfWeekStr = ""
    var timeStr = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let indexSet = NSMutableIndexSet()
        weekArray.forEach(indexSet.add)
        segmentedControl.selectedSegmentIndexes = indexSet as IndexSet!
        
        let layer : CAGradientLayer = CAGradientLayer()
        layer.frame.size = self.frame.size
        
        let color0 = UIColor(red:13/255, green:76/255, blue:153/255, alpha:0.85).cgColor
        let color1 = UIColor(red:99/255, green:42/255, blue: 91/255, alpha:0.76).cgColor
        let color2 = UIColor(red:186/255, green:7/255, blue: 29/255, alpha:0.71).cgColor
        let color3 = UIColor(red:218/255, green:128/255, blue:125/255, alpha:0.86).cgColor
        let color4 = UIColor(red:247/255, green:240/255, blue: 215/255, alpha:100).cgColor
        layer.colors = [color0,color1,color2,color3,color4]
        self.layer.insertSublayer(layer, at: 0)
        
        layer.cornerRadius = 5.0
    }
    
    @IBAction func segmentSelected(_ sender: Any) {
        weekArray = []
        for x in segmentedControl.selectedSegmentIndexes{
            print(x)
            weekArray.append(Int(x))
        }
    }
    
    func save(){
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
        for x in weekArray{
            daysOfWeekStr += daysOfWeekList[x] + " "
        }
        //handles formatting time
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
    }
}

